import 'package:flutter/material.dart';
import '../../../theme/colors.dart';

class BookingCard extends StatelessWidget {
  final String title;
  final String name;
  final String dateTime;
  final String location;
  final String fee;
  final bool isUpcoming;

  const BookingCard({
    super.key,
    required this.title,
    required this.name,
    required this.dateTime,
    required this.location,
    required this.fee,
    this.isUpcoming = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.blue.shade200, width: 0.8),
        boxShadow: const [
          BoxShadow(
            color: Color(0x05000000),
            offset: Offset(0, 0),
            blurRadius: 20,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.black.shade500,
                        fontFamily: 'DM Sans',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppColors.black.shade500,
                        fontFamily: 'DM Sans',
                        height: 1.286,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.blue,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        isUpcoming ? 'Upcoming' : 'Closed',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w300,
                          color: Colors.white,
                          fontFamily: 'DM Sans',
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (isUpcoming)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Cancel Booking',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w300,
                      color: Colors.white,
                      fontFamily: 'DM Sans',
                      height: 1.4,
                    ),
                  ),
                ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          Container(
            height: 1,
            color: AppColors.blue.shade200,
          ),
          
          const SizedBox(height: 4),
          
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Date & Time',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: AppColors.black.shade400,
                      fontFamily: 'DM Sans',
                      height: 1.333,
                    ),
                  ),
                  Text(
                    dateTime,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      color: AppColors.fontColor,
                      fontFamily: 'DM Sans',
                      height: 1.4,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Location',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: AppColors.black.shade400,
                      fontFamily: 'DM Sans',
                      height: 1.333,
                    ),
                  ),
                  Text(
                    location,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      color: AppColors.black.shade500,
                      fontFamily: 'DM Sans',
                      height: 1.4,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Service Fee',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: AppColors.black.shade400,
                      fontFamily: 'DM Sans',
                      height: 1.333,
                    ),
                  ),
                  Text(
                    fee,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppColors.fontColor,
                      fontFamily: 'DM Sans',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
