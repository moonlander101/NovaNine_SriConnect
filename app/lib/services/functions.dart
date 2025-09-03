import 'package:lanka_connect/main.dart';
import 'package:flutter/material.dart';
import 'package:lanka_connect/models/service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TimeSlot {
  final DateTimeRange timeRange;
  final String timeSlotId;

  TimeSlot({
    required this.timeRange,
    required this.timeSlotId,
  });
}

class SupabaseFunctions {

  static Future<Map<String, dynamic>> getServiceDetails(int serviceId) async {
    final response = await supabase
      .from('service')
      .select('''
        *,
        department:department_id (
          title,
          description,
          phone_no
        )
      ''')
      .eq('service_id', serviceId)
      .single();
    return response;
  }
  
  static Stream<List<TimeSlot>> getBookedTimeSlots({
    required int serviceId,
    required DateTime start,
    required DateTime end,
  }) async* {
    final startDate = start.toString().split(' ').first;
    final res = await supabase.functions.invoke(
      '/service-booking/slots/?service_id=$serviceId&date=$startDate',
      method: HttpMethod.get,
    );
    final List data = res.data['data'] as List;

    // filter the slots based on the provided start and end times
    final slots = data.where((slot) {
      return slot['status'] == 'Pending' ||
              slot['remaining_appointments'] == 0;
    }).map((slot) {
      // Parse as local time by removing the timezone offset
      slot['start_time'] = slot['start_time'].split('+').first + '+05:30';
      slot['end_time'] = slot['end_time'].split('+').first + '+05:30';
      final startTime = DateTime.parse(slot['start_time']).toLocal();
      final endTime = DateTime.parse(slot['end_time']).toLocal();
      return TimeSlot(
        timeRange: DateTimeRange(
          start: startTime,
          end: endTime,
        ),
        timeSlotId: slot['timeslot_id'].toString(),
      );
    }).toList();
    yield slots;
  }

  static Future<bool> createBooking({
    required int serviceId,
    required String timeslotId,
  }) async {
    try {
      final res = await supabase.functions.invoke(
        '/service-booking/appointments',
        body: {
          'service_id': serviceId,
          'timeslot_id': timeslotId,
        },
      );
      if (res.status != 201) {
        throw Exception('Failed to create booking: ${res.data}');
      }
      return true;
    } catch (e) {
      print('Error creating booking: $e');
      return false;
    }
  }
}
