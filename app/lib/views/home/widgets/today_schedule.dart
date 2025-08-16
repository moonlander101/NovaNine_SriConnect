import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../theme/colors.dart';
import '../screens/calendar_view.dart';
import 'appointment_card.dart';
import 'time_label.dart';

class TodaySchedule extends StatelessWidget {
  const TodaySchedule({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 32),
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.blue.shade200, width: 1),
      ),
      child: Column(
        children: [
          // Today header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Today',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: AppColors.fontColor,
                        fontFamily: 'DM Sans',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '2 Bookings',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: AppColors.fontColor,
                        fontFamily: 'DM Sans',
                        height: 1.333,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CalendarView(),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
                    decoration: BoxDecoration(
                      color: AppColors.blue,
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(color: AppColors.blue.shade200, width: 0.6),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            Iconsax.receipt,
                            color: AppColors.blue,
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Calendar',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                            fontFamily: 'DM Sans',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Divider
          Container(
            height: 0.5,
            color: AppColors.blue.shade200,
            margin: const EdgeInsets.symmetric(horizontal: 24),
          ),
          
          const SizedBox(height: 20),
          
          // Appointments timeline
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Time labels
                Container(
                  padding: const EdgeInsets.all(4),
                  child: const Column(
                    children: [
                      TimeLabel(time: '08.00'),
                      SizedBox(height: 49),
                      TimeLabel(time: '10.00'),
                      SizedBox(height: 49),
                      TimeLabel(time: '12.00'),
                      SizedBox(height: 49),
                      TimeLabel(time: '14.00'),
                    ],
                  ),
                ),
                
                const SizedBox(width: 32),
                
                // Appointments
                const Expanded(
                  child: Column(
                    children: [
                      AppointmentCard(
                        title: 'Update NIC',
                        time: '08.00 AM - 10.00 AM',
                        location: 'Divisional Secretariat - Moratuwa',
                      ),
                      SizedBox(height: 52),
                      AppointmentCard(
                        title: 'Obtain Birth Certificate',
                        time: '12.00 AM - 14.00 PM',
                        location: 'District Secretariat - Moratuwa',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
