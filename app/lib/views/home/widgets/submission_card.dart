
import 'package:flutter/material.dart';

import '../../../theme/colors.dart';
import '../../../theme/dimens.dart';
import '../../../theme/text.dart';

class SubmissionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String status;
  final Color statusColor;
  final String submittedOn;
  final String actionOn;
  final String image;
  final Color bgColor;

  const SubmissionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.status,
    required this.statusColor,
    required this.submittedOn,
    required this.actionOn,
    required this.image,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Dimens.defaultRadiusM),
        border: Border.all(
          color: AppColors.blue.shade200,
        ),
      ),
      padding: const EdgeInsets.all(Dimens.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 32,
                backgroundColor: bgColor,
                child: ClipOval(
                  child: Image.asset(
                    image,
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 280,
                    child: Text(
                      title,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: AppTextStyles.body3,
                  ),
                  SizedBox(height: 4),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor,
                      borderRadius: BorderRadius.circular(Dimens.defaultRadius),
                    ),
                    child: Text(
                      status,
                      style: AppTextStyles.body3.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 12),
                    ),
                  ),
                  SizedBox(height: 4),
                ],
              ),
            ],
          ),
          SizedBox(height: 4),
          Divider(
            height: 16,
            thickness: 1,
            color: AppColors.blue.shade200,
          ),
          SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Submitted on: ",
                  style: AppTextStyles.body3
                      .copyWith(color: AppColors.black.shade300)),
              Text(submittedOn, style: AppTextStyles.body3),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Action Taken on: ",
                  style: AppTextStyles.body3
                      .copyWith(color: AppColors.black.shade300)),
              Text(actionOn, style: AppTextStyles.body3),
            ],
          ),
        ],
      ),
    );
  }
}
