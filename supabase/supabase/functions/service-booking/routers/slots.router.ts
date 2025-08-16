import express from "express";
import { getAvailableSlots, getSlotById, getSlots, updateSlot } from "../handlers/slots.ts";
export const router = express.Router();

router.get('/service-booking/slots', getSlots)
router.get('/service-booking/slots/available', getAvailableSlots)
router.get('/service-booking/slots/:id', getSlotById)
router.put('/service-booking/slots/:id', updateSlot)