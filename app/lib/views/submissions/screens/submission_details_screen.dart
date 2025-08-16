import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lanka_connect/components/appbar.dart';
import 'package:lanka_connect/components/gap.dart';
import 'dart:math';
import '../../../theme/colors.dart';
import '../../../theme/dimens.dart';
import '../../../theme/text.dart';

class SubmissionDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> data;

  const SubmissionDetailsScreen({
    super.key,
    required this.data,
  });

  @override
  State<SubmissionDetailsScreen> createState() =>
      _SubmissionDetailsScreenState();
}

class _SubmissionDetailsScreenState extends State<SubmissionDetailsScreen> {
  final List<String> stages = [
    "Application Submitted",
    "Document Verification",
    "Field Officer Assessment",
    "Committee Review",
    "Approval & Benefit Activation",
  ];

  final List<String> rejectionReasons = [
    "Your verified household income exceeds the maximum threshold for Samurdhi eligibility.",
    "Your verified household income exceeds the maximum threshold for Samurdhi eligibility.",
    "Your verified household income exceeds the maximum threshold for Samurdhi eligibility.",
    "Your verified household income exceeds the maximum threshold for Samurdhi eligibility.",
  ];

  late List<Map<String, dynamic>> timeline;

  @override
  void initState() {
    super.initState();
    timeline = _generateTimeline();
  }

  List<Map<String, dynamic>> _generateTimeline() {
    final random = Random();
    List<Map<String, dynamic>> data = [];

    int rejectedIndex = random.nextBool() ? random.nextInt(stages.length) : -1;
    int inProgressIndex =
        rejectedIndex == -1 ? random.nextInt(stages.length) : -1;

    for (int i = 0; i < stages.length; i++) {
      String status = "Pending";
      String? reason;

      if (rejectedIndex != -1) {
        if (i < rejectedIndex) {
          status = "Resolved";
        } else if (i == rejectedIndex) {
          status = "Rejected";
          reason = rejectionReasons[random.nextInt(rejectionReasons.length)];
        } else {
          status = "Pending";
        }
      } else {
        if (i < inProgressIndex) {
          status = "Completed";
        } else if (i == inProgressIndex) {
          status = "In Progress";
        } else {
          status = "Pending";
        }
      }

      data.add({
        "title": stages[i],
        "status": status,
        "date": DateTime.now()
            .subtract(Duration(days: stages.length - i))
            .toString()
            .split(".")[0],
        "reason": reason,
      });
    }

    return data;
  }

  @override
  Widget build(BuildContext context) {
    // Find rejected step if any
    final rejectedStep = timeline
        .firstWhere((step) => step["status"] == "Rejected", orElse: () => {});

    return Scaffold(
      appBar: AppBarCustom(
        title: 'Submission Details',
        isActionIconVisible: true,
        actionIcon: Icons.auto_awesome,
        onActionPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Action button pressed')),
          );
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            card(),
            Gapz(),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.blue.shade200),
                borderRadius: BorderRadius.circular(Dimens.defaultRadiusM),
              ),
              child: Column(
                children: timeline.asMap().entries.map((entry) {
                  final index = entry.key;
                  final step = entry.value;

                  IconData stepIcon;
                  if (step["status"] == "Resolved") {
                    stepIcon = Icons.check_circle;
                  } else if (step["status"] == "In Progress") {
                    stepIcon = Iconsax.clock;
                  } else if (step["status"] == "Rejected") {
                    stepIcon = Icons.cancel;
                  } else {
                    stepIcon = Icons.circle_outlined;
                  }

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundColor: step["status"] == "Rejected"
                                ? AppColors.red
                                : AppColors.blue,
                            child: Icon(stepIcon,
                                color: AppColors.white, size: 20),
                          ),
                          if (index != timeline.length - 1)
                            Container(
                              width: 2,
                              height: 32,
                              color: AppColors.blue.shade100,
                            ),
                        ],
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              step["title"],
                              style: AppTextStyles.title3.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text("Date: ${step["date"]}",
                                style: AppTextStyles.body3),
                          ],
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),

            /// Rejection reason shown below the container
            if (rejectedStep.isNotEmpty && rejectedStep["reason"] != null)
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 12.0),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.red),
                  borderRadius: BorderRadius.circular(Dimens.defaultRadiusM),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(Dimens.defaultPadding),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: AppColors.red,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Rejection Reason",
                              style: AppTextStyles.title3.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppColors.red,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Reason: ${rejectedStep["reason"]}",
                              style: AppTextStyles.body2,
                              maxLines: 5,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Container card() {
    final Color statusColor = widget.data['statusColor'] ?? AppColors.blue;
    final String status = widget.data['status'] ?? 'Unknown';
    final String submittedOn = widget.data['submittedOn'] ?? 'N/A';
    final String image = widget.data['image'] ?? '';
    final Color bgColor = widget.data['bgColor'] ?? AppColors.blue.shade50;

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
                      widget.data['title'] ?? 'No Title',
                      style: AppTextStyles.title2,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    widget.data['subtitle'] ?? 'No Subtitle',
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
              Text("Submission ID: ",
                  style: AppTextStyles.body3
                      .copyWith(color: AppColors.black.shade300)),
              Text("SM129045", style: AppTextStyles.body3),
            ],
          ),
        ],
      ),
    );
  }
}
