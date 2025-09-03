import 'package:flutter/material.dart';
import 'package:lanka_connect/booking_calendar/src/core/booking_calendar.dart';
import 'package:lanka_connect/booking_calendar/src/model/booking_service.dart';
import 'package:lanka_connect/booking_calendar/src/model/enums.dart';
import 'package:lanka_connect/services/functions.dart';

class ServiceDetails {
  final int serviceId;
  final int departmentId;
  final String title;
  final String description;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Department department;

  ServiceDetails({
    required this.serviceId,
    required this.departmentId,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.department,
  });
}

class Department {
  final String title;
  final String phoneNo;
  final String description;

  Department({
    required this.title,
    required this.phoneNo,
    required this.description,
  });
}
  

class SingleServiceScreen extends StatefulWidget {
  final int serviceId;

  const SingleServiceScreen({
    super.key,
    required this.serviceId,
  });

  @override
  State<SingleServiceScreen> createState() => _SingleServiceScreenState();
}

class _SingleServiceScreenState extends State<SingleServiceScreen> {
  final now = DateTime.now();
  late ServiceDetails bookingService;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _initServiceDetails();
  }

  void _initServiceDetails() async {
    setState(() {
      isLoading = true;
    });
    final serviceDetails = await SupabaseFunctions.getServiceDetails(widget.serviceId);
    setState(() {
      bookingService = ServiceDetails(
        serviceId: serviceDetails['service_id'],
        departmentId: serviceDetails['department_id'],
        title: serviceDetails['title'],
        description: serviceDetails['description'],
        createdAt: DateTime.parse(serviceDetails['created_at']),
        updatedAt: DateTime.parse(serviceDetails['updated_at']),
        department: Department(
          title: serviceDetails['department']['title'],
          phoneNo: serviceDetails['department']['phone_no'],
          description: serviceDetails['department']['description'],
        ),
      );
      isLoading = false;
    });
  }

  Stream<List<TimeSlot>> getBookingStream({required DateTime end, required DateTime start}) {
    return SupabaseFunctions.getBookedTimeSlots(
      serviceId: widget.serviceId,
      start: start,
      end: end,
    );
  }

  Future<bool> uploadBooking({required BookingService newBooking}) async {
    final success = await SupabaseFunctions.createBooking(
      serviceId: widget.serviceId,
      timeslotId: '94',
    );

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Appointment booked successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to book appointment. Please try again.')),
      );
    }

    return success;
  }

  List<DateTimeRange> convertStreamResult({required dynamic streamResult}) {
    if (streamResult is List<TimeSlot>) {
      return streamResult.map((slot) => slot.timeRange).toList();
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          // Service Details
          Container(
            margin: const EdgeInsets.all(16.0),
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bookingService.title,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  bookingService.description,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.business,
                            color: Theme.of(context).colorScheme.primary,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Department: ${bookingService.department.title}',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.phone,
                            color: Theme.of(context).colorScheme.primary,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Contact: ${bookingService.department.phoneNo}',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            height: 32,
            color: Colors.grey,
            indent: 16,
            endIndent: 16,
            thickness: 0.5,
          ),
          // Booking Calendar
          Expanded(
            child: BookingCalendar(
              bookingService: BookingService(
                serviceId: widget.serviceId.toString(),
                serviceName: bookingService.title,
                serviceDuration: 60,
                bookingStart: DateTime(now.year, now.month, now.day, 8, 0),
                bookingEnd: DateTime(now.year, now.month, now.day, 17, 00),
              ),
              convertStreamResultToDateTimeRanges: convertStreamResult,
              getBookingStream: getBookingStream,
              uploadBooking: uploadBooking,
              // pauseSlots: generatePauseSlots(),
              // pauseSlotText: 'LUNCH',
              // hideBreakTime: false,
              loadingWidget: const Text('Loading available slots...'),
              uploadingWidget: const CircularProgressIndicator(),
              startingDayOfWeek: StartingDayOfWeek.monday,
              wholeDayIsBookedWidget: const Text('Sorry, no appointments available for this day'),
              // Disable weekends
              // disabledDays: [6, 7],
            ),
          ),
        ],
      ),
    );
  }
}