import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lanka_connect/theme/colors.dart';
import '../../../components/appbar.dart';
import '../../../components/margin.dart';
import '../../../theme/text.dart';
import '../widgets/info_row.dart';

class PersonalInfoScreen extends StatelessWidget {
  const PersonalInfoScreen({super.key});
  Widget sectionTitle(String title) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(bottom: 12.0, left: 12.0),
      child: Text(
        title.toUpperCase(),
        style: AppTextStyles.body3,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blue.shade50,
      appBar: AppBarCustom(
          title: 'Personal Information', isBackButtonVisible: true),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Margin(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.blue.shade200, width: 1),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      InfoRow(
                        icon: Iconsax.profile_circle,
                        label: "Full Name",
                        value: "Vimosh Vasanthakumar",
                      ),
                      InfoRow(
                        icon: Iconsax.calendar_1,
                        label: "Date of Birth",
                        value: "2002/08/12",
                      ),
                      InfoRow(
                        icon: Iconsax.card,
                        label: "NIC card",
                        value: "200222500189",
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Margin(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.blue.shade200, width: 1),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      InfoRow(
                        icon: Iconsax.house,
                        label: "Address",
                        value:
                            "No:29, Barathi Village, Sinna Urani, Batticaloa",
                      ),
                      InfoRow(
                        icon: Iconsax.location,
                        label: "District",
                        value: "Batticaloa",
                      ),
                      InfoRow(
                        icon: Iconsax.map,
                        label: "GS Division",
                        value: "176F",
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Margin(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.blue.shade200, width: 1),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      InfoRow(
                        icon: Iconsax.call,
                        label: "Mobile Number",
                        value: "0767722120",
                      ),
                      InfoRow(
                        icon: Iconsax.sms,
                        label: "Email",
                        value: "vimosh02@gmail.com",
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
