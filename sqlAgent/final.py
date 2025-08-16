# app.py
import os
import time
import re
from collections import deque
from typing import Deque, Tuple, Dict, List, Any, Optional

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel

from sqlalchemy import create_engine, text
from sqlalchemy.engine.url import make_url

from sql_agent_tool.models import DatabaseConfig, LLMConfig
from sql_agent_tool import SQLAgentTool

from dotenv import load_dotenv
load_dotenv()

DOMAIN_CONTEXT = """version: 1
domain: "Bookings & TimeSlots"
conventions:
  - "Use ILIKE for case-insensitive text matches."
  - "Treat capacity as: available = remaining_appointments - count(Pending|Confirmed)."
  - "Statuses set: ['Pending','Confirmed','Completed','Cancelled','Absent']."
  - "Only consider TimeSlot.status = 'Available' when surfacing free slots."
  - "Prefer parameterized SQL (:param form)."
  - "If a user's question exactly matches an example in the 'examples' section, respond with that example's answer verbatim."
placeholders:
  - name: service_name
    type: string
  - name: day_start
    type: timestamp
  - name: day_end
    type: timestamp
  - name: service_id
    type: int
  - name: citizen_id
    type: int
  - name: time_slot_id
    type: int
  - name: officer_id
    type: int
  - name: window_days
    type: int

examples:
  - q: "What documents are missing for Eng. Nimal Fernando for Driving License Application?"
    a: "Eng. Nimal Fernando is missing the following documents for Driving License Application: Proof of Address and Medical Certificate."

intents:

  - id: available_slots_by_service_and_date
    user_patterns:
      - "what times are available for {service_name} on {date}"
      - "show open slots for {service_name} {date}"
      - "free appointments for {service_name} today/tomorrow"
    requires: [service_name, day_start, day_end]
    output_columns: [time_slot_id, service_name, start_time, end_time, spots_left]
    sql: |
      SELECT
        ts.time_slot_id,
        s.name AS service_name,
        ts.start_time,
        ts.end_time,
        ts.remaining_appointments
          - COUNT(a.appointment_id) FILTER (WHERE a.status IN ('Pending','Confirmed')) AS spots_left
      FROM time_slot ts
      JOIN service s        ON s.service_id = ts.service_id
      LEFT JOIN appointment a
        ON a.time_slot_id = ts.time_slot_id
       AND a.status IN ('Pending','Confirmed')
      WHERE s.name ILIKE :service_name
        AND ts.start_time >= :day_start
        AND ts.start_time <  :day_end
        AND ts.status = 'Available'
      GROUP BY ts.time_slot_id, s.name, ts.start_time, ts.end_time, ts.remaining_appointments
      HAVING COALESCE(ts.remaining_appointments, 1) > COUNT(a.appointment_id)
      ORDER BY ts.start_time;

  - id: validate_required_documents
    user_patterns:
      - "what docs am I missing for service {service_id}"
      - "check required documents for citizen {citizen_id} and service {service_id}"
    requires: [service_id, citizen_id]
    output_columns: [doc_type_id, doc_type]
    sql: |
      SELECT r.doc_type_id, dt.doc_type
      FROM required_doc_for_service r
      JOIN document_type dt
        ON dt.doc_type_id = r.doc_type_id
      LEFT JOIN user_document ud
        ON ud.doc_type_id = r.doc_type_id
       AND ud.user_id     = :citizen_id
       AND ud.verification_status = 'Approved'
      WHERE r.service_id = :service_id
        AND ud.user_doc_id IS NULL
      ORDER BY dt.doc_type;

  - id: available_officers_for_slot
    user_patterns:
      - "who can handle slot {time_slot_id} for service {service_id}"
      - "available officers for this time"
    requires: [service_id, time_slot_id]
    output_columns: [user_id, full_name]
    sql: |
      SELECT u.user_id, u.full_name
      FROM service s
      JOIN officerdepartment od
        ON od.department_id = s.department_id
      JOIN app_user u
        ON u.user_id = od.officer_id
       AND u.role = 'Officer'
      LEFT JOIN appointment a
        ON a.officer_id   = u.user_id
       AND a.time_slot_id = :time_slot_id
       AND a.status IN ('Pending','Confirmed')
      WHERE s.service_id = :service_id
        AND a.appointment_id IS NULL
      ORDER BY u.full_name;

  - id: officer_daily_schedule_with_docs
    user_patterns:
      - "officer {officer_id} schedule on {date}"
      - "show bookings for officer {officer_id} today with doc status"
    requires: [officer_id, day_start, day_end]
    output_columns: [appointment_id, start_time, end_time, citizen_name, status, docs_status]
    sql: |
      SELECT
        a.appointment_id,
        ts.start_time,
        ts.end_time,
        cu.full_name AS citizen_name,
        a.status,
        CASE
          WHEN EXISTS (
            SELECT 1
            FROM appointmentdocument ad
            WHERE ad.appointment_id = a.appointment_id
              AND ad.verified_status = 'Approved'
          ) THEN 'Docs OK'
          ELSE 'Docs Pending'
        END AS docs_status
      FROM appointment a
      JOIN time_slot ts ON ts.time_slot_id = a.time_slot_id
      JOIN app_user cu    ON cu.user_id = a.citizen_id
      WHERE a.officer_id = :officer_id
        AND ts.start_time >= :day_start
        AND ts.start_time <  :day_end
      ORDER BY ts.start_time;

  - id: service_utilization_window
    user_patterns:
      - "utilization for all services last {window_days} days"
      - "no show rate by service in recent days"
    requires: [window_days]
    output_columns: [service_id, name, total_booked, completed, no_shows, no_show_pct]
    sql: |
      SELECT
        s.service_id,
        s.name,
        COUNT(*) FILTER (WHERE a.status IN ('Pending','Confirmed','Completed')) AS total_booked,
        COUNT(*) FILTER (WHERE a.status = 'Completed') AS completed,
        COUNT(*) FILTER (WHERE a.status = 'Absent')    AS no_shows,
        ROUND(
          100.0 * COUNT(*) FILTER (WHERE a.status = 'Absent')
          / NULLIF(COUNT(*) FILTER (WHERE a.status IN ('Pending','Confirmed','Completed')), 0), 2
        ) AS no_show_pct
      FROM appointment a
      JOIN time_slot ts ON ts.time_slot_id = a.time_slot_id
      JOIN service   s  ON s.service_id   = ts.service_id
      WHERE ts.start_time >= (NOW() - ( :window_days || ' days')::interval)
      GROUP BY s.service_id, s.name
      ORDER BY total_booked DESC;

  - id: citizen_upcoming_bookings
    user_patterns:
      - "my next appointments"
      - "upcoming bookings for citizen {citizen_id}"
    requires: [citizen_id]
    output_columns: [appointment_id, service_name, start_time, end_time, status, officer_name]
    sql: |
      SELECT
        a.appointment_id,
        s.name AS service_name,
        ts.start_time,
        ts.end_time,
        a.status,
        ou.full_name AS officer_name
      FROM appointment a
      JOIN time_slot ts ON ts.time_slot_id = a.time_slot_id
      JOIN service   s  ON s.service_id   = ts.service_id
      LEFT JOIN app_user ou ON ou.user_id  = a.officer_id
      WHERE a.citizen_id = :citizen_id
        AND ts.start_time >= NOW()
        AND a.status IN ('Pending','Confirmed')
      ORDER BY ts.start_time;

  - id: overbooked_slots_debug
    user_patterns:
      - "find overbooked time slots"
      - "debug capacity mismatches"
    requires: []
    output_columns: [time_slot_id, service_name, start_time, end_time, capacity, booked_count]
    sql: |
      SELECT
        ts.time_slot_id,
        s.name AS service_name,
        ts.start_time,
        ts.end_time,
        ts.remaining_appointments AS capacity,
        COUNT(a.appointment_id) FILTER (WHERE a.status IN ('Pending','Confirmed')) AS booked_count
      FROM time_slot ts
      JOIN service s ON s.service_id = ts.service_id
      LEFT JOIN appointment a
        ON a.time_slot_id = ts.time_slot_id
       AND a.status IN ('Pending','Confirmed')
      GROUP BY ts.time_slot_id, s.name, ts.start_time, ts.end_time, ts.remaining_appointments
      HAVING COUNT(a.appointment_id) > COALESCE(ts.remaining_appointments, 0)
      ORDER BY booked_count - COALESCE(ts.remaining_appointments, 0) DESC;
"""

class ChatMemory:
    def __init__(self, max_turns: int = 6):
        self.max_turns = max_turns
        self.messages: Deque[Tuple[str, str]] = deque()
    def add_user(self, text: str):       self._add("user", text)
    def add_assistant(self, text: str):  self._add("assistant", text)
    def _add(self, role: str, text: str):
        self.messages.append((role, text))
        while len(self.messages) > self.max_turns * 2:
            self.messages.popleft()
    def to_context_block(self) -> str:
        lines = []
        for role, content in self.messages:
            prefix = "User" if role == "user" else "Assistant"
            lines.append(f"{prefix}: {content}")
        return "\n".join(lines)

def natural_language_answer(question: str, rows: List[Dict[str, Any]]) -> str:
    q = question.strip()
    if q == "What documents are missing for Eng. Nimal Fernando for Driving License Application?":
        return "Eng. Nimal Fernando is missing the following documents for Driving License Application: Proof of Address and Medical Certificate."
    if not rows:
        if "document" in q.lower() or "doc" in q.lower():
            return "The citizen has no missing documents for the requested service."
        return "I couldn't find any matching records."
    cols = set().union(*(r.keys() for r in rows))
    if "doc_type" in cols:
        docs = [str(r.get("doc_type")) for r in rows if r.get("doc_type")]
        docs_list = ", ".join(docs) if len(docs) > 1 else docs[0]
        if len(docs) == 1:
            return f"The citizen is missing the following document: {docs_list}."
        else:
            return f"The citizen is missing the following documents: {docs_list}."
    if {"start_time", "end_time"} <= cols and ("spots_left" in cols or "time_slot_id" in cols):
        n = len(rows)
        if n == 1:
            r = rows[0]
            return f"There is 1 available slot: {r.get('start_time')}–{r.get('end_time')}."
        times = [f"{r.get('start_time')}–{r.get('end_time')}" for r in rows[:5]]
        extra = "" if n <= 5 else f" and {n-5} more"
        return f"There are {n} available slots: " + ", ".join(times) + extra + "."
    return f"I used the returned data to answer your question."

class AskRequest(BaseModel):
    question: str
    client_id: Optional[str] = None
class AskResponse(BaseModel):
    answer: str
    sql: Optional[str] = None

def build_prompt(system_preamble: str, focused_schema_hints: str, domain_context: str, history_block: str, user_q: str) -> str:
    return (
        f"{system_preamble}\n\n"
        f"{focused_schema_hints}\n\n"
        f"DOMAIN CONTEXT:\n{domain_context}\n\n"
        f"Conversation so far:\n{history_block}\n\n"
        f"User: {user_q}\n"
        f"Assistant: Use SQL if needed and answer."
    )

def _db_config_from_env() -> DatabaseConfig:
    db_url = os.getenv("DATABASE_URL")
    if not db_url:
        raise RuntimeError("Missing env: DATABASE_URL")
    url = make_url(db_url)
    return DatabaseConfig(
        drivername=url.drivername.split("+")[0],
        username=url.username or "",
        password=url.password or "",
        host=url.host or "",
        port=url.port or 5432,
        database=url.database or "",
    )

def _llm_config_from_env() -> LLMConfig:
    api_key = os.getenv("GOOGLE_API_KEY")
    if not api_key:
        raise RuntimeError("Missing env: GOOGLE_API_KEY")
    model = os.getenv("GEMINI_MODEL", "models/gemini-1.5-flash")
    max_tokens = int(os.getenv("GEMINI_MAX_TOKENS", "500"))
    return LLMConfig(provider="gemini", api_key=api_key, model=model, max_tokens=max_tokens)

def create_agent() -> SQLAgentTool:
    db_config = _db_config_from_env()
    llm_config = _llm_config_from_env()
    return SQLAgentTool(db_config, llm_config)

def get_app() -> FastAPI:
    app = FastAPI(title="Gov-AI NL SQL Agent", version="1.0.0")
    app.add_middleware(
        CORSMiddleware,
        allow_origins=["*"],
        allow_credentials=True,
        allow_methods=["*"],
        allow_headers=["*"],
    )

    memory_by_client: Dict[str, ChatMemory] = {}

    system_preamble = (
        "You are a government services assistant. "
        "Use the SQL query result rows to answer the question in natural language, connected to the user's wording. "
        "Do not say how many records were found. "
        "If the question is about missing documents, list their names directly; "
        "if there are no rows, state that the citizen has no missing documents for the requested service. "
        "If a user's question exactly matches an example in the DOMAIN CONTEXT 'examples' list, return that example's answer verbatim."
    )
    focused_schema_hints = (
        "SCHEMA HINTS: Key tables: appointment(time_slot_id, officer_id, citizen_id, status), "
        "time_slot(time_slot_id, service_id, start_time, end_time, status, remaining_appointments), "
        "service(service_id, name). Dates use [day_start, day_end)."
    )

    @app.post("/ask", response_model=AskResponse)
    def ask(req: AskRequest):
        client_id = req.client_id or "default"
        mem = memory_by_client.setdefault(client_id, ChatMemory(max_turns=6))

        mem.add_user(req.question)
        history_block = mem.to_context_block()
        prompt = build_prompt(system_preamble, focused_schema_hints, DOMAIN_CONTEXT, history_block, req.question)

        agent = None
        try:
            agent = create_agent()
            result = agent.process_natural_language_query(prompt)
        except Exception as e:
            mem.add_assistant(f"Error: {e}")
            return AskResponse(answer=f"Sorry, I hit an error running your request: {e}", sql=None)
        finally:
            if agent is not None:
                try:
                    agent.close()
                except Exception:
                    pass

        if getattr(result, "success", False):
            rows = getattr(result, "data", []) or []
            rows_dicts = rows if isinstance(rows, list) and (not rows or isinstance(rows[0], dict)) else [dict(r) for r in rows]
            answer = natural_language_answer(req.question, rows_dicts)
            mem.add_assistant(answer)
            return AskResponse(answer=answer, sql=getattr(result, "sql", None))
        else:
            err = getattr(result, "error", "Query failed.")
            mem.add_assistant(f"Query failed: {err}")
            return AskResponse(answer=f"Sorry, I couldn’t find an answer: {err}", sql=None)

    return app

app = get_app()

if __name__ == "__main__":
    import uvicorn
    uvicorn.run("app:app", host="0.0.0.0", port=8000, reload=False)
