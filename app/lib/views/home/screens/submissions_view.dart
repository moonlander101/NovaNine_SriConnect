import 'package:flutter/material.dart';
import 'package:lanka_connect/components/appbar.dart';
import 'package:lanka_connect/theme/text.dart';

import '../../../theme/assets.dart';
import '../../../theme/colors.dart';
import '../../../theme/dimens.dart';
import '../../submissions/screens/submission_details_screen.dart';
import '../widgets/submission_card.dart';

class SubmissionsScreen extends StatefulWidget {
  const SubmissionsScreen({super.key});

  @override
  State<SubmissionsScreen> createState() => _SubmissionsScreenState();
}

class _SubmissionsScreenState extends State<SubmissionsScreen> {
  final List<String> categories = [
    "All",
    "Utilities & Payments",
    "Public Services",
    "Infrastructure",
    "Land & Property",
    "Legal"
  ];

  String selectedCategory = "All";

  final List<Map<String, dynamic>> submissions = [
    {
      "title": "Samurdhi Welfare Application",
      "subtitle": "Ministry of Finance – Samurdhi Division",
      "status": "Rejected",
      "statusColor": Colors.red,
      "category": "Public Services",
      "submittedOn": "20 May 2025, 04:51 PM",
      "actionOn": "05 June 2025, 11:35 AM",
      "image": AppAssets.bill1,
      "bgColor": AppColors.red50
    },
    {
      "title": "Electricity Bill Overcharge Complaint",
      "subtitle": "Ceylon Electricity Board",
      "status": "Resolved",
      "statusColor": Colors.green,
      "category": "Utilities & Payments",
      "submittedOn": "05 July 2025, 09:03 AM",
      "actionOn": "08 July 2025, 04:45 PM",
      "image": AppAssets.bill2,
      "bgColor": AppColors.blue50
    },
    {
      "title": "Water Supply Disruption Report",
      "subtitle": "National Water Supply & Drainage Board",
      "status": "Pending",
      "statusColor": Colors.orange,
      "category": "Infrastructure",
      "submittedOn": "05 July 2025, 09:03 AM",
      "actionOn": "3–5 working days",
      "image": AppAssets.bill3,
      "bgColor": AppColors.red100
    },
  ];

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredSubmissions = selectedCategory == "All"
        ? submissions
        : submissions
            .where((item) => item["category"] == selectedCategory)
            .toList();

    return Scaffold(
      backgroundColor: AppColors.blue.shade50,
      appBar: AppBarCustom(title: "Submissions", isBackButtonVisible: false),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(Dimens.defaultScreenMarginSM),
            child: LayoutBuilder(
              builder: (context, constraints) {
          double availableWidth = constraints.maxWidth - 16;
          double chipMinWidth = 90;
          int chipsPerLine = (availableWidth / chipMinWidth).floor();
          int maxChips = chipsPerLine * 2;

          bool showMore = categories.length > maxChips;
          List<String> visibleCategories =
              showMore ? categories.sublist(0, maxChips - 1) : categories;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
            ...visibleCategories.map((cat) {
              bool isSelected = cat == selectedCategory;
              return GestureDetector(
                onTap: () {
                  setState(() {
              selectedCategory = cat;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
              color:
                  isSelected ? AppColors.blue : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.blue,
                width: 1,
              ),
                  ),
                  child: Text(
              cat,
              style: AppTextStyles.body3.copyWith(
                color: isSelected
                    ? AppColors.white
                    : AppColors.blue,
              ),
                  ),
                ),
              );
            }),
            if (showMore)
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
              context: context,
              builder: (context) => ListView(
                children: categories.map((cat) {
                  bool isSelected = cat == selectedCategory;
                  return ListTile(
                    title: Text(cat),
                    selected: isSelected,
                    onTap: () {
                setState(() {
                  selectedCategory = cat;
                });
                Navigator.pop(context);
                    },
                  );
                }).toList(),
              ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.grey.shade300,
                width: 1,
              ),
                  ),
                  child: const Text(
              "+ more",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
                  ),
                ),
              ),
                ],
              ),
            ],
          );
              },
            ),
          ),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(
            horizontal: Dimens.defaultScreenMarginSM),
              itemCount: filteredSubmissions.length,
              itemBuilder: (context, index) {
          final item = filteredSubmissions[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
            builder: (context) => SubmissionDetailsScreen(data: item),
                ),
              );
            },
            child: SubmissionCard(
              title: item["title"],
              subtitle: item["subtitle"],
              status: item["status"],
              statusColor: item["statusColor"],
              submittedOn: item["submittedOn"],
              actionOn: item["actionOn"],
              image: item["image"],
              bgColor: item["bgColor"],
            ),
          );
              },
            ),
          ),
        ],
      ),
    );
  }
}
