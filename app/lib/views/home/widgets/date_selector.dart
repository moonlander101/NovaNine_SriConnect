import 'package:flutter/material.dart';
import '../../../theme/colors.dart';

class DateSelector extends StatelessWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;

  const DateSelector({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 26),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: _buildDateCards(),
      ),
    );
  }

  List<Widget> _buildDateCards() {
    List<Widget> cards = [];
    DateTime startDate = selectedDate.subtract(Duration(days: selectedDate.weekday - 1));
    
    for (int i = 0; i < 6; i++) {
      DateTime date = startDate.add(Duration(days: i));
      bool isSelected = date.day == selectedDate.day && 
                       date.month == selectedDate.month && 
                       date.year == selectedDate.year;
      
      cards.add(_buildDateCard(
        date.day.toString(),
        _getDayName(date.weekday),
        isSelected,
        () => onDateSelected(date),
      ));
    }
    
    return cards;
  }

  Widget _buildDateCard(String day, String dayName, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.blue : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.blue.shade200,
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Text(
              day,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : AppColors.blue,
                fontFamily: 'Noto Sans',
                letterSpacing: 0.2,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              dayName,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: isSelected ? Colors.white : AppColors.blue,
                fontFamily: 'Noto Sans',
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getDayName(int weekday) {
    const days = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];
    return days[weekday - 1];
  }
}
