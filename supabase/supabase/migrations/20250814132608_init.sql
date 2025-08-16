create type "public"."appointment_status" as enum ('Pending', 'Confirmed', 'Completed', 'Canceled', 'Waited');

create type "public"."notification_type" as enum ('Confirmation', 'Reminder', 'Update');

create type "public"."send_via_type" as enum ('Email', 'SMS', 'Both');

create type "public"."user_role" as enum ('Citizen', 'Officer', 'Admin');

create type "public"."verification_status" as enum ('Pending', 'Approved', 'Rejected');

create sequence "public"."app_user_user_id_seq";

create sequence "public"."appointment_appointment_id_seq";

create sequence "public"."appointment_document_appointment_doc_id_seq";

create sequence "public"."complaint_complaint_id_seq";

create sequence "public"."department_department_id_seq";

create sequence "public"."document_type_doc_type_id_seq";

create sequence "public"."feedback_feedback_id_seq";

create sequence "public"."message_message_id_seq";

create sequence "public"."notification_notification_id_seq";

create sequence "public"."service_service_id_seq";

create sequence "public"."time_slot_timeslot_id_seq";

create sequence "public"."user_document_user_doc_id_seq";

create table "public"."app_user" (
    "user_id" integer not null default nextval('app_user_user_id_seq'::regclass),
    "full_name" character varying(255),
    "nic_no" character varying(16),
    "email" character varying(100),
    "phone_no" character varying(15),
    "password" character varying(255),
    "role" user_role default 'Citizen'::user_role,
    "created_at" timestamp with time zone default now(),
    "updated_at" timestamp with time zone default now()
);


create table "public"."appointment" (
    "appointment_id" integer not null default nextval('appointment_appointment_id_seq'::regclass),
    "officer_id" integer,
    "citizen_id" integer,
    "service_id" integer,
    "timeslot_id" integer,
    "status" appointment_status default 'Pending'::appointment_status,
    "created_at" timestamp with time zone default now(),
    "updated_at" timestamp with time zone default now()
);


create table "public"."appointment_document" (
    "appointment_doc_id" integer not null default nextval('appointment_document_appointment_doc_id_seq'::regclass),
    "appointment_id" integer,
    "file_path" character varying(500),
    "doc_type" character varying(255),
    "uploaded_date" timestamp with time zone default now(),
    "verification_status" verification_status default 'Pending'::verification_status,
    "review" text
);


create table "public"."complaint" (
    "complaint_id" integer not null default nextval('complaint_complaint_id_seq'::regclass),
    "citizen_id" integer,
    "appointment_id" integer,
    "title" character varying(255),
    "field" text,
    "type" text,
    "created_at" timestamp with time zone default now()
);


create table "public"."department" (
    "department_id" integer not null default nextval('department_department_id_seq'::regclass),
    "title" character varying(255),
    "description" text,
    "email" character varying(100),
    "phone_no" character varying(15),
    "created_at" timestamp with time zone default now(),
    "updated_at" timestamp with time zone default now()
);


create table "public"."document_type" (
    "doc_type_id" integer not null default nextval('document_type_doc_type_id_seq'::regclass),
    "doc_type" character varying(255) not null,
    "description" text,
    "created_at" timestamp with time zone default now()
);


create table "public"."feedback" (
    "feedback_id" integer not null default nextval('feedback_feedback_id_seq'::regclass),
    "appointment_id" integer,
    "rating" integer,
    "review" text,
    "submit_time" timestamp with time zone default now()
);


create table "public"."message" (
    "message_id" integer not null default nextval('message_message_id_seq'::regclass),
    "appointment_id" integer,
    "sender_id" integer,
    "receiver_id" integer,
    "message" text,
    "send_time" timestamp with time zone default now()
);


create table "public"."notification" (
    "notification_id" integer not null default nextval('notification_notification_id_seq'::regclass),
    "appointment_id" integer,
    "citizen_id" integer,
    "type" notification_type,
    "message" text,
    "send_via" send_via_type,
    "send_time" timestamp with time zone,
    "created_at" timestamp with time zone default now()
);


create table "public"."officer_department" (
    "officer_id" integer not null,
    "department_id" integer not null,
    "created_at" timestamp with time zone default now()
);


create table "public"."required_doc_for_service" (
    "service_id" integer not null,
    "doc_type_id" integer not null,
    "is_mandatory" boolean default true,
    "created_at" timestamp with time zone default now()
);


create table "public"."service" (
    "service_id" integer not null default nextval('service_service_id_seq'::regclass),
    "department_id" integer,
    "title" character varying(255),
    "description" text,
    "created_at" timestamp with time zone default now(),
    "updated_at" timestamp with time zone default now()
);


create table "public"."time_slot" (
    "timeslot_id" integer not null default nextval('time_slot_timeslot_id_seq'::regclass),
    "service_id" integer,
    "start_time" timestamp with time zone,
    "end_time" timestamp with time zone,
    "max_appointments" integer default 1,
    "created_at" timestamp with time zone default now()
);


create table "public"."user_auth" (
    "user_id" integer not null,
    "auth_user_id" uuid not null
);


create table "public"."user_document" (
    "user_doc_id" integer not null default nextval('user_document_user_doc_id_seq'::regclass),
    "user_id" integer,
    "doc_type_id" integer,
    "file_path" character varying(500),
    "upload_time" timestamp with time zone default now(),
    "verification_status" verification_status default 'Pending'::verification_status
);


alter sequence "public"."app_user_user_id_seq" owned by "public"."app_user"."user_id";

alter sequence "public"."appointment_appointment_id_seq" owned by "public"."appointment"."appointment_id";

alter sequence "public"."appointment_document_appointment_doc_id_seq" owned by "public"."appointment_document"."appointment_doc_id";

alter sequence "public"."complaint_complaint_id_seq" owned by "public"."complaint"."complaint_id";

alter sequence "public"."department_department_id_seq" owned by "public"."department"."department_id";

alter sequence "public"."document_type_doc_type_id_seq" owned by "public"."document_type"."doc_type_id";

alter sequence "public"."feedback_feedback_id_seq" owned by "public"."feedback"."feedback_id";

alter sequence "public"."message_message_id_seq" owned by "public"."message"."message_id";

alter sequence "public"."notification_notification_id_seq" owned by "public"."notification"."notification_id";

alter sequence "public"."service_service_id_seq" owned by "public"."service"."service_id";

alter sequence "public"."time_slot_timeslot_id_seq" owned by "public"."time_slot"."timeslot_id";

alter sequence "public"."user_document_user_doc_id_seq" owned by "public"."user_document"."user_doc_id";

CREATE UNIQUE INDEX app_user_email_key ON public.app_user USING btree (email);

CREATE UNIQUE INDEX app_user_nic_no_key ON public.app_user USING btree (nic_no);

CREATE UNIQUE INDEX app_user_pkey ON public.app_user USING btree (user_id);

CREATE UNIQUE INDEX appointment_document_pkey ON public.appointment_document USING btree (appointment_doc_id);

CREATE UNIQUE INDEX appointment_pkey ON public.appointment USING btree (appointment_id);

CREATE UNIQUE INDEX complaint_pkey ON public.complaint USING btree (complaint_id);

CREATE UNIQUE INDEX department_pkey ON public.department USING btree (department_id);

CREATE UNIQUE INDEX document_type_pkey ON public.document_type USING btree (doc_type_id);

CREATE UNIQUE INDEX feedback_pkey ON public.feedback USING btree (feedback_id);

CREATE UNIQUE INDEX message_pkey ON public.message USING btree (message_id);

CREATE UNIQUE INDEX notification_pkey ON public.notification USING btree (notification_id);

CREATE UNIQUE INDEX officer_department_pkey ON public.officer_department USING btree (officer_id, department_id);

CREATE UNIQUE INDEX required_doc_for_service_pkey ON public.required_doc_for_service USING btree (service_id, doc_type_id);

CREATE UNIQUE INDEX service_pkey ON public.service USING btree (service_id);

CREATE UNIQUE INDEX time_slot_pkey ON public.time_slot USING btree (timeslot_id);

CREATE UNIQUE INDEX user_auth_auth_user_id_key ON public.user_auth USING btree (auth_user_id);

CREATE UNIQUE INDEX user_auth_pkey ON public.user_auth USING btree (user_id, auth_user_id);

CREATE UNIQUE INDEX user_auth_user_id_key ON public.user_auth USING btree (user_id);

CREATE UNIQUE INDEX user_document_pkey ON public.user_document USING btree (user_doc_id);

alter table "public"."app_user" add constraint "app_user_pkey" PRIMARY KEY using index "app_user_pkey";

alter table "public"."appointment" add constraint "appointment_pkey" PRIMARY KEY using index "appointment_pkey";

alter table "public"."appointment_document" add constraint "appointment_document_pkey" PRIMARY KEY using index "appointment_document_pkey";

alter table "public"."complaint" add constraint "complaint_pkey" PRIMARY KEY using index "complaint_pkey";

alter table "public"."department" add constraint "department_pkey" PRIMARY KEY using index "department_pkey";

alter table "public"."document_type" add constraint "document_type_pkey" PRIMARY KEY using index "document_type_pkey";

alter table "public"."feedback" add constraint "feedback_pkey" PRIMARY KEY using index "feedback_pkey";

alter table "public"."message" add constraint "message_pkey" PRIMARY KEY using index "message_pkey";

alter table "public"."notification" add constraint "notification_pkey" PRIMARY KEY using index "notification_pkey";

alter table "public"."officer_department" add constraint "officer_department_pkey" PRIMARY KEY using index "officer_department_pkey";

alter table "public"."required_doc_for_service" add constraint "required_doc_for_service_pkey" PRIMARY KEY using index "required_doc_for_service_pkey";

alter table "public"."service" add constraint "service_pkey" PRIMARY KEY using index "service_pkey";

alter table "public"."time_slot" add constraint "time_slot_pkey" PRIMARY KEY using index "time_slot_pkey";

alter table "public"."user_auth" add constraint "user_auth_pkey" PRIMARY KEY using index "user_auth_pkey";

alter table "public"."user_document" add constraint "user_document_pkey" PRIMARY KEY using index "user_document_pkey";

alter table "public"."app_user" add constraint "app_user_email_key" UNIQUE using index "app_user_email_key";

alter table "public"."app_user" add constraint "app_user_nic_no_key" UNIQUE using index "app_user_nic_no_key";

alter table "public"."appointment" add constraint "appointment_citizen_id_fkey" FOREIGN KEY (citizen_id) REFERENCES app_user(user_id) ON DELETE SET NULL not valid;

alter table "public"."appointment" validate constraint "appointment_citizen_id_fkey";

alter table "public"."appointment" add constraint "appointment_officer_id_fkey" FOREIGN KEY (officer_id) REFERENCES app_user(user_id) ON DELETE SET NULL not valid;

alter table "public"."appointment" validate constraint "appointment_officer_id_fkey";

alter table "public"."appointment" add constraint "appointment_service_id_fkey" FOREIGN KEY (service_id) REFERENCES service(service_id) ON DELETE SET NULL not valid;

alter table "public"."appointment" validate constraint "appointment_service_id_fkey";

alter table "public"."appointment" add constraint "appointment_timeslot_id_fkey" FOREIGN KEY (timeslot_id) REFERENCES time_slot(timeslot_id) ON DELETE SET NULL not valid;

alter table "public"."appointment" validate constraint "appointment_timeslot_id_fkey";

alter table "public"."appointment_document" add constraint "appointment_document_appointment_id_fkey" FOREIGN KEY (appointment_id) REFERENCES appointment(appointment_id) ON DELETE CASCADE not valid;

alter table "public"."appointment_document" validate constraint "appointment_document_appointment_id_fkey";

alter table "public"."complaint" add constraint "complaint_appointment_id_fkey" FOREIGN KEY (appointment_id) REFERENCES appointment(appointment_id) ON DELETE SET NULL not valid;

alter table "public"."complaint" validate constraint "complaint_appointment_id_fkey";

alter table "public"."complaint" add constraint "complaint_citizen_id_fkey" FOREIGN KEY (citizen_id) REFERENCES app_user(user_id) ON DELETE SET NULL not valid;

alter table "public"."complaint" validate constraint "complaint_citizen_id_fkey";

alter table "public"."feedback" add constraint "feedback_appointment_id_fkey" FOREIGN KEY (appointment_id) REFERENCES appointment(appointment_id) ON DELETE SET NULL not valid;

alter table "public"."feedback" validate constraint "feedback_appointment_id_fkey";

alter table "public"."feedback" add constraint "feedback_rating_check" CHECK (((rating >= 1) AND (rating <= 5))) not valid;

alter table "public"."feedback" validate constraint "feedback_rating_check";

alter table "public"."message" add constraint "message_appointment_id_fkey" FOREIGN KEY (appointment_id) REFERENCES appointment(appointment_id) ON DELETE SET NULL not valid;

alter table "public"."message" validate constraint "message_appointment_id_fkey";

alter table "public"."message" add constraint "message_receiver_id_fkey" FOREIGN KEY (receiver_id) REFERENCES app_user(user_id) ON DELETE SET NULL not valid;

alter table "public"."message" validate constraint "message_receiver_id_fkey";

alter table "public"."message" add constraint "message_sender_id_fkey" FOREIGN KEY (sender_id) REFERENCES app_user(user_id) ON DELETE SET NULL not valid;

alter table "public"."message" validate constraint "message_sender_id_fkey";

alter table "public"."notification" add constraint "notification_appointment_id_fkey" FOREIGN KEY (appointment_id) REFERENCES appointment(appointment_id) ON DELETE SET NULL not valid;

alter table "public"."notification" validate constraint "notification_appointment_id_fkey";

alter table "public"."notification" add constraint "notification_citizen_id_fkey" FOREIGN KEY (citizen_id) REFERENCES app_user(user_id) ON DELETE SET NULL not valid;

alter table "public"."notification" validate constraint "notification_citizen_id_fkey";

alter table "public"."officer_department" add constraint "officer_department_department_id_fkey" FOREIGN KEY (department_id) REFERENCES department(department_id) ON DELETE CASCADE not valid;

alter table "public"."officer_department" validate constraint "officer_department_department_id_fkey";

alter table "public"."officer_department" add constraint "officer_department_officer_id_fkey" FOREIGN KEY (officer_id) REFERENCES app_user(user_id) ON DELETE CASCADE not valid;

alter table "public"."officer_department" validate constraint "officer_department_officer_id_fkey";

alter table "public"."required_doc_for_service" add constraint "required_doc_for_service_doc_type_id_fkey" FOREIGN KEY (doc_type_id) REFERENCES document_type(doc_type_id) ON DELETE CASCADE not valid;

alter table "public"."required_doc_for_service" validate constraint "required_doc_for_service_doc_type_id_fkey";

alter table "public"."required_doc_for_service" add constraint "required_doc_for_service_service_id_fkey" FOREIGN KEY (service_id) REFERENCES service(service_id) ON DELETE CASCADE not valid;

alter table "public"."required_doc_for_service" validate constraint "required_doc_for_service_service_id_fkey";

alter table "public"."service" add constraint "service_department_id_fkey" FOREIGN KEY (department_id) REFERENCES department(department_id) ON DELETE SET NULL not valid;

alter table "public"."service" validate constraint "service_department_id_fkey";

alter table "public"."time_slot" add constraint "time_slot_service_id_fkey" FOREIGN KEY (service_id) REFERENCES service(service_id) ON DELETE SET NULL not valid;

alter table "public"."time_slot" validate constraint "time_slot_service_id_fkey";

alter table "public"."user_auth" add constraint "user_auth_auth_user_id_fkey" FOREIGN KEY (auth_user_id) REFERENCES auth.users(id) ON DELETE CASCADE not valid;

alter table "public"."user_auth" validate constraint "user_auth_auth_user_id_fkey";

alter table "public"."user_auth" add constraint "user_auth_auth_user_id_key" UNIQUE using index "user_auth_auth_user_id_key";

alter table "public"."user_auth" add constraint "user_auth_user_id_fkey" FOREIGN KEY (user_id) REFERENCES app_user(user_id) ON DELETE CASCADE not valid;

alter table "public"."user_auth" validate constraint "user_auth_user_id_fkey";

alter table "public"."user_auth" add constraint "user_auth_user_id_key" UNIQUE using index "user_auth_user_id_key";

alter table "public"."user_document" add constraint "user_document_doc_type_id_fkey" FOREIGN KEY (doc_type_id) REFERENCES document_type(doc_type_id) ON DELETE CASCADE not valid;

alter table "public"."user_document" validate constraint "user_document_doc_type_id_fkey";

alter table "public"."user_document" add constraint "user_document_user_id_fkey" FOREIGN KEY (user_id) REFERENCES app_user(user_id) ON DELETE CASCADE not valid;

alter table "public"."user_document" validate constraint "user_document_user_id_fkey";

grant delete on table "public"."app_user" to "anon";

grant insert on table "public"."app_user" to "anon";

grant references on table "public"."app_user" to "anon";

grant select on table "public"."app_user" to "anon";

grant trigger on table "public"."app_user" to "anon";

grant truncate on table "public"."app_user" to "anon";

grant update on table "public"."app_user" to "anon";

grant delete on table "public"."app_user" to "authenticated";

grant insert on table "public"."app_user" to "authenticated";

grant references on table "public"."app_user" to "authenticated";

grant select on table "public"."app_user" to "authenticated";

grant trigger on table "public"."app_user" to "authenticated";

grant truncate on table "public"."app_user" to "authenticated";

grant update on table "public"."app_user" to "authenticated";

grant delete on table "public"."app_user" to "service_role";

grant insert on table "public"."app_user" to "service_role";

grant references on table "public"."app_user" to "service_role";

grant select on table "public"."app_user" to "service_role";

grant trigger on table "public"."app_user" to "service_role";

grant truncate on table "public"."app_user" to "service_role";

grant update on table "public"."app_user" to "service_role";

grant delete on table "public"."appointment" to "anon";

grant insert on table "public"."appointment" to "anon";

grant references on table "public"."appointment" to "anon";

grant select on table "public"."appointment" to "anon";

grant trigger on table "public"."appointment" to "anon";

grant truncate on table "public"."appointment" to "anon";

grant update on table "public"."appointment" to "anon";

grant delete on table "public"."appointment" to "authenticated";

grant insert on table "public"."appointment" to "authenticated";

grant references on table "public"."appointment" to "authenticated";

grant select on table "public"."appointment" to "authenticated";

grant trigger on table "public"."appointment" to "authenticated";

grant truncate on table "public"."appointment" to "authenticated";

grant update on table "public"."appointment" to "authenticated";

grant delete on table "public"."appointment" to "service_role";

grant insert on table "public"."appointment" to "service_role";

grant references on table "public"."appointment" to "service_role";

grant select on table "public"."appointment" to "service_role";

grant trigger on table "public"."appointment" to "service_role";

grant truncate on table "public"."appointment" to "service_role";

grant update on table "public"."appointment" to "service_role";

grant delete on table "public"."appointment_document" to "anon";

grant insert on table "public"."appointment_document" to "anon";

grant references on table "public"."appointment_document" to "anon";

grant select on table "public"."appointment_document" to "anon";

grant trigger on table "public"."appointment_document" to "anon";

grant truncate on table "public"."appointment_document" to "anon";

grant update on table "public"."appointment_document" to "anon";

grant delete on table "public"."appointment_document" to "authenticated";

grant insert on table "public"."appointment_document" to "authenticated";

grant references on table "public"."appointment_document" to "authenticated";

grant select on table "public"."appointment_document" to "authenticated";

grant trigger on table "public"."appointment_document" to "authenticated";

grant truncate on table "public"."appointment_document" to "authenticated";

grant update on table "public"."appointment_document" to "authenticated";

grant delete on table "public"."appointment_document" to "service_role";

grant insert on table "public"."appointment_document" to "service_role";

grant references on table "public"."appointment_document" to "service_role";

grant select on table "public"."appointment_document" to "service_role";

grant trigger on table "public"."appointment_document" to "service_role";

grant truncate on table "public"."appointment_document" to "service_role";

grant update on table "public"."appointment_document" to "service_role";

grant delete on table "public"."complaint" to "anon";

grant insert on table "public"."complaint" to "anon";

grant references on table "public"."complaint" to "anon";

grant select on table "public"."complaint" to "anon";

grant trigger on table "public"."complaint" to "anon";

grant truncate on table "public"."complaint" to "anon";

grant update on table "public"."complaint" to "anon";

grant delete on table "public"."complaint" to "authenticated";

grant insert on table "public"."complaint" to "authenticated";

grant references on table "public"."complaint" to "authenticated";

grant select on table "public"."complaint" to "authenticated";

grant trigger on table "public"."complaint" to "authenticated";

grant truncate on table "public"."complaint" to "authenticated";

grant update on table "public"."complaint" to "authenticated";

grant delete on table "public"."complaint" to "service_role";

grant insert on table "public"."complaint" to "service_role";

grant references on table "public"."complaint" to "service_role";

grant select on table "public"."complaint" to "service_role";

grant trigger on table "public"."complaint" to "service_role";

grant truncate on table "public"."complaint" to "service_role";

grant update on table "public"."complaint" to "service_role";

grant delete on table "public"."department" to "anon";

grant insert on table "public"."department" to "anon";

grant references on table "public"."department" to "anon";

grant select on table "public"."department" to "anon";

grant trigger on table "public"."department" to "anon";

grant truncate on table "public"."department" to "anon";

grant update on table "public"."department" to "anon";

grant delete on table "public"."department" to "authenticated";

grant insert on table "public"."department" to "authenticated";

grant references on table "public"."department" to "authenticated";

grant select on table "public"."department" to "authenticated";

grant trigger on table "public"."department" to "authenticated";

grant truncate on table "public"."department" to "authenticated";

grant update on table "public"."department" to "authenticated";

grant delete on table "public"."department" to "service_role";

grant insert on table "public"."department" to "service_role";

grant references on table "public"."department" to "service_role";

grant select on table "public"."department" to "service_role";

grant trigger on table "public"."department" to "service_role";

grant truncate on table "public"."department" to "service_role";

grant update on table "public"."department" to "service_role";

grant delete on table "public"."document_type" to "anon";

grant insert on table "public"."document_type" to "anon";

grant references on table "public"."document_type" to "anon";

grant select on table "public"."document_type" to "anon";

grant trigger on table "public"."document_type" to "anon";

grant truncate on table "public"."document_type" to "anon";

grant update on table "public"."document_type" to "anon";

grant delete on table "public"."document_type" to "authenticated";

grant insert on table "public"."document_type" to "authenticated";

grant references on table "public"."document_type" to "authenticated";

grant select on table "public"."document_type" to "authenticated";

grant trigger on table "public"."document_type" to "authenticated";

grant truncate on table "public"."document_type" to "authenticated";

grant update on table "public"."document_type" to "authenticated";

grant delete on table "public"."document_type" to "service_role";

grant insert on table "public"."document_type" to "service_role";

grant references on table "public"."document_type" to "service_role";

grant select on table "public"."document_type" to "service_role";

grant trigger on table "public"."document_type" to "service_role";

grant truncate on table "public"."document_type" to "service_role";

grant update on table "public"."document_type" to "service_role";

grant delete on table "public"."feedback" to "anon";

grant insert on table "public"."feedback" to "anon";

grant references on table "public"."feedback" to "anon";

grant select on table "public"."feedback" to "anon";

grant trigger on table "public"."feedback" to "anon";

grant truncate on table "public"."feedback" to "anon";

grant update on table "public"."feedback" to "anon";

grant delete on table "public"."feedback" to "authenticated";

grant insert on table "public"."feedback" to "authenticated";

grant references on table "public"."feedback" to "authenticated";

grant select on table "public"."feedback" to "authenticated";

grant trigger on table "public"."feedback" to "authenticated";

grant truncate on table "public"."feedback" to "authenticated";

grant update on table "public"."feedback" to "authenticated";

grant delete on table "public"."feedback" to "service_role";

grant insert on table "public"."feedback" to "service_role";

grant references on table "public"."feedback" to "service_role";

grant select on table "public"."feedback" to "service_role";

grant trigger on table "public"."feedback" to "service_role";

grant truncate on table "public"."feedback" to "service_role";

grant update on table "public"."feedback" to "service_role";

grant delete on table "public"."message" to "anon";

grant insert on table "public"."message" to "anon";

grant references on table "public"."message" to "anon";

grant select on table "public"."message" to "anon";

grant trigger on table "public"."message" to "anon";

grant truncate on table "public"."message" to "anon";

grant update on table "public"."message" to "anon";

grant delete on table "public"."message" to "authenticated";

grant insert on table "public"."message" to "authenticated";

grant references on table "public"."message" to "authenticated";

grant select on table "public"."message" to "authenticated";

grant trigger on table "public"."message" to "authenticated";

grant truncate on table "public"."message" to "authenticated";

grant update on table "public"."message" to "authenticated";

grant delete on table "public"."message" to "service_role";

grant insert on table "public"."message" to "service_role";

grant references on table "public"."message" to "service_role";

grant select on table "public"."message" to "service_role";

grant trigger on table "public"."message" to "service_role";

grant truncate on table "public"."message" to "service_role";

grant update on table "public"."message" to "service_role";

grant delete on table "public"."notification" to "anon";

grant insert on table "public"."notification" to "anon";

grant references on table "public"."notification" to "anon";

grant select on table "public"."notification" to "anon";

grant trigger on table "public"."notification" to "anon";

grant truncate on table "public"."notification" to "anon";

grant update on table "public"."notification" to "anon";

grant delete on table "public"."notification" to "authenticated";

grant insert on table "public"."notification" to "authenticated";

grant references on table "public"."notification" to "authenticated";

grant select on table "public"."notification" to "authenticated";

grant trigger on table "public"."notification" to "authenticated";

grant truncate on table "public"."notification" to "authenticated";

grant update on table "public"."notification" to "authenticated";

grant delete on table "public"."notification" to "service_role";

grant insert on table "public"."notification" to "service_role";

grant references on table "public"."notification" to "service_role";

grant select on table "public"."notification" to "service_role";

grant trigger on table "public"."notification" to "service_role";

grant truncate on table "public"."notification" to "service_role";

grant update on table "public"."notification" to "service_role";

grant delete on table "public"."officer_department" to "anon";

grant insert on table "public"."officer_department" to "anon";

grant references on table "public"."officer_department" to "anon";

grant select on table "public"."officer_department" to "anon";

grant trigger on table "public"."officer_department" to "anon";

grant truncate on table "public"."officer_department" to "anon";

grant update on table "public"."officer_department" to "anon";

grant delete on table "public"."officer_department" to "authenticated";

grant insert on table "public"."officer_department" to "authenticated";

grant references on table "public"."officer_department" to "authenticated";

grant select on table "public"."officer_department" to "authenticated";

grant trigger on table "public"."officer_department" to "authenticated";

grant truncate on table "public"."officer_department" to "authenticated";

grant update on table "public"."officer_department" to "authenticated";

grant delete on table "public"."officer_department" to "service_role";

grant insert on table "public"."officer_department" to "service_role";

grant references on table "public"."officer_department" to "service_role";

grant select on table "public"."officer_department" to "service_role";

grant trigger on table "public"."officer_department" to "service_role";

grant truncate on table "public"."officer_department" to "service_role";

grant update on table "public"."officer_department" to "service_role";

grant delete on table "public"."required_doc_for_service" to "anon";

grant insert on table "public"."required_doc_for_service" to "anon";

grant references on table "public"."required_doc_for_service" to "anon";

grant select on table "public"."required_doc_for_service" to "anon";

grant trigger on table "public"."required_doc_for_service" to "anon";

grant truncate on table "public"."required_doc_for_service" to "anon";

grant update on table "public"."required_doc_for_service" to "anon";

grant delete on table "public"."required_doc_for_service" to "authenticated";

grant insert on table "public"."required_doc_for_service" to "authenticated";

grant references on table "public"."required_doc_for_service" to "authenticated";

grant select on table "public"."required_doc_for_service" to "authenticated";

grant trigger on table "public"."required_doc_for_service" to "authenticated";

grant truncate on table "public"."required_doc_for_service" to "authenticated";

grant update on table "public"."required_doc_for_service" to "authenticated";

grant delete on table "public"."required_doc_for_service" to "service_role";

grant insert on table "public"."required_doc_for_service" to "service_role";

grant references on table "public"."required_doc_for_service" to "service_role";

grant select on table "public"."required_doc_for_service" to "service_role";

grant trigger on table "public"."required_doc_for_service" to "service_role";

grant truncate on table "public"."required_doc_for_service" to "service_role";

grant update on table "public"."required_doc_for_service" to "service_role";

grant delete on table "public"."service" to "anon";

grant insert on table "public"."service" to "anon";

grant references on table "public"."service" to "anon";

grant select on table "public"."service" to "anon";

grant trigger on table "public"."service" to "anon";

grant truncate on table "public"."service" to "anon";

grant update on table "public"."service" to "anon";

grant delete on table "public"."service" to "authenticated";

grant insert on table "public"."service" to "authenticated";

grant references on table "public"."service" to "authenticated";

grant select on table "public"."service" to "authenticated";

grant trigger on table "public"."service" to "authenticated";

grant truncate on table "public"."service" to "authenticated";

grant update on table "public"."service" to "authenticated";

grant delete on table "public"."service" to "service_role";

grant insert on table "public"."service" to "service_role";

grant references on table "public"."service" to "service_role";

grant select on table "public"."service" to "service_role";

grant trigger on table "public"."service" to "service_role";

grant truncate on table "public"."service" to "service_role";

grant update on table "public"."service" to "service_role";

grant delete on table "public"."time_slot" to "anon";

grant insert on table "public"."time_slot" to "anon";

grant references on table "public"."time_slot" to "anon";

grant select on table "public"."time_slot" to "anon";

grant trigger on table "public"."time_slot" to "anon";

grant truncate on table "public"."time_slot" to "anon";

grant update on table "public"."time_slot" to "anon";

grant delete on table "public"."time_slot" to "authenticated";

grant insert on table "public"."time_slot" to "authenticated";

grant references on table "public"."time_slot" to "authenticated";

grant select on table "public"."time_slot" to "authenticated";

grant trigger on table "public"."time_slot" to "authenticated";

grant truncate on table "public"."time_slot" to "authenticated";

grant update on table "public"."time_slot" to "authenticated";

grant delete on table "public"."time_slot" to "service_role";

grant insert on table "public"."time_slot" to "service_role";

grant references on table "public"."time_slot" to "service_role";

grant select on table "public"."time_slot" to "service_role";

grant trigger on table "public"."time_slot" to "service_role";

grant truncate on table "public"."time_slot" to "service_role";

grant update on table "public"."time_slot" to "service_role";

grant delete on table "public"."user_auth" to "anon";

grant insert on table "public"."user_auth" to "anon";

grant references on table "public"."user_auth" to "anon";

grant select on table "public"."user_auth" to "anon";

grant trigger on table "public"."user_auth" to "anon";

grant truncate on table "public"."user_auth" to "anon";

grant update on table "public"."user_auth" to "anon";

grant delete on table "public"."user_auth" to "authenticated";

grant insert on table "public"."user_auth" to "authenticated";

grant references on table "public"."user_auth" to "authenticated";

grant select on table "public"."user_auth" to "authenticated";

grant trigger on table "public"."user_auth" to "authenticated";

grant truncate on table "public"."user_auth" to "authenticated";

grant update on table "public"."user_auth" to "authenticated";

grant delete on table "public"."user_auth" to "service_role";

grant insert on table "public"."user_auth" to "service_role";

grant references on table "public"."user_auth" to "service_role";

grant select on table "public"."user_auth" to "service_role";

grant trigger on table "public"."user_auth" to "service_role";

grant truncate on table "public"."user_auth" to "service_role";

grant update on table "public"."user_auth" to "service_role";

grant delete on table "public"."user_document" to "anon";

grant insert on table "public"."user_document" to "anon";

grant references on table "public"."user_document" to "anon";

grant select on table "public"."user_document" to "anon";

grant trigger on table "public"."user_document" to "anon";

grant truncate on table "public"."user_document" to "anon";

grant update on table "public"."user_document" to "anon";

grant delete on table "public"."user_document" to "authenticated";

grant insert on table "public"."user_document" to "authenticated";

grant references on table "public"."user_document" to "authenticated";

grant select on table "public"."user_document" to "authenticated";

grant trigger on table "public"."user_document" to "authenticated";

grant truncate on table "public"."user_document" to "authenticated";

grant update on table "public"."user_document" to "authenticated";

grant delete on table "public"."user_document" to "service_role";

grant insert on table "public"."user_document" to "service_role";

grant references on table "public"."user_document" to "service_role";

grant select on table "public"."user_document" to "service_role";

grant trigger on table "public"."user_document" to "service_role";

grant truncate on table "public"."user_document" to "service_role";

grant update on table "public"."user_document" to "service_role";


