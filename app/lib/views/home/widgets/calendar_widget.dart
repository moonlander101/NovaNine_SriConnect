import 'package:flutter/material.dart';
import '../../../theme/colors.dart';

class CalendarWidget extends StatefulWidget {
  final DateTime selectedDay;
  final Function(DateTime, DateTime) onDaySelected;

  const CalendarWidget({
    super.key,
    required this.selectedDay,
    required this.onDaySelected,
  });

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  late DateTime _focusedDay;

  @override
  void initState() {
    super.initState();
    _focusedDay = widget.selectedDay;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 32),
      padding: const EdgeInsets.all(29.49),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(19.66),
        border: Border.all(color: AppColors.blue.shade200, width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            offset: Offset(0, 0),
            blurRadius: 32,
          ),
        ],
      ),
      child: Column(
        children: [
          // Month navigation
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => _changeMonth(-1),
                child: Icon(
                  Icons.arrow_back_ios,
                  color: AppColors.blue,
                  size: 19.66,
                ),
              ),
              Text(
                '${_getMonthName(_focusedDay.month)} ${_focusedDay.year}',
                style: TextStyle(
                  fontSize: 17.203,
                  fontWeight: FontWeight.w400,
                  color: AppColors.fontColor,
                  fontFamily: 'Noto Sans',
                ),
              ),
              GestureDetector(
                onTap: () => _changeMonth(1),
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.blue,
                  size: 19.66,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 27.033),
          
          // Day headers
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildDayHeader('SAN'),
              _buildDayHeader('MON'),
              _buildDayHeader('TUE'),
              _buildDayHeader('WED'),
              _buildDayHeader('THU'),
              _buildDayHeader('FRI'),
              _buildDayHeader('SAT'),
            ],
          ),
          
          const SizedBox(height: 9.83),
          
          // Calendar grid
          ..._buildCalendarWeeks(),
        ],
      ),
    );
  }

  Widget _buildDayHeader(String day) {
    return Container(
      width: 36.863,
      height: 24.575,
      alignment: Alignment.center,
      child: Text(
        day,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: AppColors.black.shade300,
          fontFamily: 'Avenir Next LT Pro',
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _buildCalendarDay(int? day, bool isSelected, bool isCurrentMonth) {
    if (day == null) {
      return const SizedBox(width: 36.863, height: 36.863);
    }

    return GestureDetector(
      onTap: isCurrentMonth ? () {
        final newDate = DateTime(_focusedDay.year, _focusedDay.month, day);
        widget.onDaySelected(newDate, newDate);
      } : null,
      child: Container(
        width: 36.863,
        height: 36.863,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.blue : Colors.transparent,
          borderRadius: BorderRadius.circular(35.634),
        ),
        alignment: Alignment.center,
        child: Text(
          day.toString(),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : 
                   isCurrentMonth ? AppColors.black.shade400 : 
                   AppColors.black.shade300,
            fontFamily: 'Avenir Next LT Pro',
          ),
        ),
      ),
    );
  }

  List<Widget> _buildCalendarWeeks() {
    List<Widget> weeks = [];
    DateTime firstDayOfMonth = DateTime(_focusedDay.year, _focusedDay.month, 1);
    
    // Start from the first Sunday of the calendar grid
    DateTime startDate = firstDayOfMonth.subtract(Duration(days: firstDayOfMonth.weekday % 7));
    
    for (int week = 0; week < 6; week++) {
      List<Widget> days = [];
      
      for (int day = 0; day < 7; day++) {
        DateTime currentDate = startDate.add(Duration(days: week * 7 + day));
        bool isCurrentMonth = currentDate.month == _focusedDay.month;
        bool isSelected = currentDate.day == widget.selectedDay.day && 
                         currentDate.month == widget.selectedDay.month &&
                         currentDate.year == widget.selectedDay.year;
        
        days.add(_buildCalendarDay(
          isCurrentMonth ? currentDate.day : null,
          isSelected && isCurrentMonth,
          isCurrentMonth,
        ));
      }
      
      weeks.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: days,
      ));
      
      if (week < 5) {
        weeks.add(const SizedBox(height: 9.83));
      }
      
      // Stop if we've shown all days of the month and the week is complete
      if (startDate.add(Duration(days: (week + 1) * 7)).month != _focusedDay.month && 
          startDate.add(Duration(days: week * 7 + 6)).month != _focusedDay.month) {
        break;
      }
    }
    
    return weeks;
  }

  void _changeMonth(int delta) {
    setState(() {
      _focusedDay = DateTime(_focusedDay.year, _focusedDay.month + delta, 1);
    });
  }

  String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }
}
