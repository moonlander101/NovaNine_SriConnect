import 'package:flutter/material.dart';
import '../../../theme/colors.dart';
import 'appointment_card.dart';
import 'time_label.dart';

class DailySchedule extends StatelessWidget {
  final DateTime selectedDate;

  const DailySchedule({
    super.key,
    required this.selectedDate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Time labels
          Container(
            padding: const EdgeInsets.only(top: 4),
            child: const Column(
              children: [
                TimeLabel(time: '08.00'),
                SizedBox(height: 49),
                TimeLabel(time: '10.00'),
                SizedBox(height: 49),
                TimeLabel(time: '12.00'),
                SizedBox(height: 49),
                TimeLabel(time: '14.00'),
                SizedBox(height: 49),
                TimeLabel(time: '16.00'),
                SizedBox(height: 49),
                TimeLabel(time: '18.00'),
                SizedBox(height: 49),
                TimeLabel(time: '20.00'),
              ],
            ),
          ),
          
          const SizedBox(width: 32),
          
          // Appointments
          Expanded(
            child: Column(
              children: _buildAppointmentsForDate(),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildAppointmentsForDate() {
    // Mock data - in a real app, you'd fetch this from your data source
    List<Widget> appointments = [];
    
    // Check if selected date has appointments (mock logic)
    if (selectedDate.day == DateTime.now().day && 
        selectedDate.month == DateTime.now().month &&
        selectedDate.year == DateTime.now().year) {
      // Today's appointments
      appointments.addAll([
        const AppointmentCard(
          title: 'Update NIC',
          time: '08.00 AM - 10.00 AM',
          location: 'Divisional Secretariat - Moratuwa',
        ),
        const SizedBox(height: 52),
        const AppointmentCard(
          title: 'Obtain Birth Certificate',
          time: '12.00 AM - 14.00 PM',
          location: '',
        ),
      ]);
    } else if (selectedDate.day == 21 && selectedDate.month == 7) {
      // July 21st appointments
      appointments.addAll([
        const AppointmentCard(
          title: 'Passport Application',
          time: '09.00 AM - 11.00 AM',
          location: 'Immigration Office - Colombo',
        ),
      ]);
    } else {
      // No appointments
      appointments.add(
        Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 50),
            child: Text(
              'No appointments for this date',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.black.shade400,
                fontFamily: 'DM Sans',
              ),
            ),
          ),
        ),
      );
    }
    
    return appointments;
  }
}
