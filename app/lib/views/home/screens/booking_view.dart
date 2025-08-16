import 'package:flutter/material.dart';
import '../../../theme/colors.dart';
import '../widgets/booking_card.dart';
import '../widgets/today_schedule.dart';
import '../widgets/toggle_tabs.dart';

class BookingView extends StatefulWidget {
  const BookingView({super.key});

  @override
  State<BookingView> createState() => _BookingViewState();
}

class _BookingViewState extends State<BookingView> {
  bool isUpcoming = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 16),
        child: _buildCustomAppBar(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Divider
            Container(
              height: 1,
              color: AppColors.blue.shade200,
              margin: const EdgeInsets.symmetric(horizontal: 1),
            ),
            
            const SizedBox(height: 24),
            
            // Today Section
            const TodaySchedule(),
            
            const SizedBox(height: 20),
            
            // Toggle tabs
            ToggleTabs(
              isUpcoming: isUpcoming,
              onToggle: (value) {
                setState(() {
                  isUpcoming = value;
                });
              },
            ),
            
            const SizedBox(height: 20),
            
            // Booking cards
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  BookingCard(
                    title: 'Update NIC',
                    name: 'Vimosh Vasanthakumar',
                    dateTime: 'Jul 21, 2025 | 08.00 AM - 10.00 AM',
                    location: 'District Secretariat - Moratuwa',
                    fee: 'Rs. 2000',
                    isUpcoming: isUpcoming,
                  ),
                  const SizedBox(height: 10),
                  BookingCard(
                    title: 'Obtain Birth Certificate',
                    name: 'Vimosh Vasanthakumar', 
                    dateTime: 'Dec 20, 2025 | 08.00 AM - 10.00 AM',
                    location: 'District Secretariat - Moratuwa',
                    fee: 'Rs. 1500',
                    isUpcoming: isUpcoming,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomAppBar() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        child: Row(
          children: [
            Container(
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
            Expanded(
              child: Container(
                alignment: Alignment.center,
                child: const Text(
                  'My Bookings',
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
            const SizedBox(width: 48), // Spacer to center title
          ],
        ),
      ),
    );
  }
}
