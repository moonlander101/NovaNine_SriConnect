import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../theme/colors.dart';
import '../widgets/calendar_widget.dart';
import '../widgets/date_selector.dart';
import '../widgets/daily_schedule.dart';

class CalendarView extends StatefulWidget {
  const CalendarView({super.key});

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  DateTime _selectedDay = DateTime.now();
  bool _isMonthlyView = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFDFF),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 16),
        child: _buildCustomAppBar(),
      ),
      body: Column(
        children: [
          // Divider
          Container(
            height: 1,
            color: AppColors.blue.shade200,
            margin: const EdgeInsets.symmetric(horizontal: 1),
          ),
          
          const SizedBox(height: 24),
            
            if (_isMonthlyView) ...[
              // Monthly Calendar View
              CalendarWidget(
                selectedDay: _selectedDay,
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                  });
                },
              ),
            ] else ...[
              // Daily View
              // Month/Year Label
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Row(
                  children: [
                    Text(
                      '${_getMonthName(_selectedDay.month)}, ${_selectedDay.year}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF000000),
                        fontFamily: 'DM Sans',
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 28),
              
              // Date selector
              DateSelector(
                selectedDate: _selectedDay,
                onDateSelected: (date) {
                  setState(() {
                    _selectedDay = date;
                  });
                },
              ),
              
              const SizedBox(height: 42),
              
              // Daily schedule
              Expanded(
                child: SafeArea(
                  child: DailySchedule(selectedDate: _selectedDay),
                ),
              ),
            ],
            
            const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildCustomAppBar() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.blue.shade200, width: 0.8),
                ),
                child: Icon(
                  Icons.arrow_back_ios_new,
                  color: AppColors.blue.shade600,
                  size: 20,
                ),
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.center,
                child: const Text(
                  'My Calendar',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1C1D21),
                    fontFamily: 'Noto Sans',
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  _isMonthlyView = !_isMonthlyView;
                });
              },
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _isMonthlyView ? AppColors.blue : Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.blue.shade200, width: 0.8),
                ),
                child: Icon(
                  Iconsax.calendar_1,
                  color: _isMonthlyView ? Colors.white : AppColors.blue.shade600,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }
}
