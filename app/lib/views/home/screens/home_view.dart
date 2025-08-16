import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lanka_connect/components/gap.dart';
import 'package:lanka_connect/components/margin.dart';
import 'package:lanka_connect/theme/colors.dart';
import 'package:lanka_connect/views/home/widgets/bill_payment_widget.dart';

import '../../../theme/assets.dart';
import '../../../theme/dimens.dart';
import '../../../theme/text.dart';
import '../widgets/category_card.dart';
import '../widgets/notification_button.dart';
import '../widgets/service_card.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blue.shade50,
      appBar: AppBar(
        backgroundColor: AppColors.blue.shade50,
        toolbarHeight: 72,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimens.baseSize),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: AppColors.green,
                    child: Text(
                      "V",
                      style: AppTextStyles.title2.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: Dimens.defaultMargin),
                  Text(
                    "Hello Sunara!",
                    style: AppTextStyles.title1.copyWith(
                      color: AppColors.darkGreen,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  notificationButton(),
                ],
              )
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gapz(),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Dimens.defaultScreenMarginSM,
              ),
              child: Container(
                padding: const EdgeInsets.only(
                    left: Dimens.defaultScreenMarginSM,
                    right: Dimens.baseSize,
                    top: Dimens.baseSize,
                    bottom: Dimens.baseSize),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.circular(2 * Dimens.defaultRadiusL),
                  border: Border.all(color: AppColors.blue.shade200),
                ),
                child: Row(
                  children: [
                    Expanded(
                        child: Row(
                      children: [
                        Icon(
                          Iconsax.search_normal_14,
                          color: AppColors.blue.shade600,
                        ),
                        const SizedBox(width: 1.5 * Dimens.baseSize),
                        Text("Your Searches",
                            style: AppTextStyles.body2.copyWith(
                              color: AppColors.black.shade400,
                            )),
                      ],
                    )),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.blue.shade500,
                        shape: BoxShape.circle,
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          IconButton(
                            icon: Icon(Iconsax.setting_4,
                                color: AppColors.white, size: Dimens.iconSizeL),
                            onPressed: () {},
                            padding: EdgeInsets.zero,
                            splashRadius: 24,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            const Margin(),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Dimens.defaultScreenMarginSM,
              ),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimens.defaultRadiusL),
                    color: AppColors.blue),
                child: Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.blue,
                    borderRadius: BorderRadius.circular(Dimens.defaultRadiusL),
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Colors.black,
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: Dimens.defaultMargin,
                            bottom: Dimens.defaultMarginB,
                            left: Dimens.defaultMargin,
                            right: Dimens.defaultMarginB,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Gapz(),
                              Text(
                                "AI-Powered \nDocument Verification",
                                style: AppTextStyles.headline6.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  height: 1.17,
                                ),
                              ),
                              Gapz(),
                              Text(
                                "Get instant verification with AI Faster approvals and fewer errors.",
                                style: AppTextStyles.body3.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                              const Spacer(),
                              Row(
                                children: [
                                  Container(
                                    width: 24,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: AppColors.yellow,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: AppColors.glossy,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: AppColors.glossy,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: AppColors.glossy,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ],
                              ),
                              Gapz()
                            ],
                          ),
                        ),
                      ),

                      // Right: Logo section (fixed size)
                      Padding(
                        padding: const EdgeInsets.all(Dimens.defaultMarginSM),
                        child: SizedBox(
                          width: 110,
                          height: 110,
                          child: Image.asset(
                            AppAssets.logo,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: Dimens.defaultMargin),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Dimens.defaultScreenMarginSM,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Quick Access", style: AppTextStyles.headline6),
                  Text("See all",
                      style: AppTextStyles.body2.copyWith(
                        color: AppColors.black.shade400,
                      )),
                ],
              ),
            ),
            const SizedBox(height: Dimens.defaultMarginSM),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Dimens.defaultScreenMarginSM,
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(
                    Dimens.defaultMargin), // internal padding
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(Dimens.defaultRadiusL),
                  border: Border.all(color: AppColors.blue.shade200),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        categoryIcon(AppAssets.img1, "NIC \nServices", () {
                          context.push('/service-booking');
                        }),
                        categoryIcon(AppAssets.img2, "Passport \nServices", () {
                          context.push('/service-booking');
                        }),
                        categoryIcon(AppAssets.img3, "License \nServices", () {
                          context.push('/service-booking');
                        }),
                      ],
                    ),
                    Margin(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        categoryIcon(AppAssets.img1, "Land & Deed \nServices",
                            () {
                          context.push('/');
                        }),
                        categoryIcon(AppAssets.img2, "Public \nAssistance", () {
                          context.push('/public-assistance');
                        }),
                        categoryIcon(AppAssets.img3, "Public \nTransport Info",
                            () {
                          context.push('/');
                        }),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: Dimens.defaultMarginSM),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Dimens.defaultScreenMarginSM,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Bill Payments", style: AppTextStyles.headline6),
                  Text("See all",
                      style: AppTextStyles.body2.copyWith(
                        color: AppColors.black.shade400,
                      )),
                ],
              ),
            ),
            const SizedBox(height: Dimens.defaultMargin),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: Dimens.defaultMargin),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  billPaymentWidget(AppAssets.bill1, "Electricity \nBill", () {
                    context.push('/');
                  }, AppColors.red50),
                  billPaymentWidget(AppAssets.bill2, "Water \nBill", () {
                    context.push('/');
                  }, AppColors.blue50),
                  billPaymentWidget(AppAssets.bill3, "Electricity \nBill", () {
                    context.push('/');
                  }, AppColors.red100),
                  billPaymentWidget(AppAssets.bill4, "Traffic \nBill", () {
                    context.push('/');
                  }, AppColors.blue.shade100),
                ],
              ),
            ),
            const SizedBox(height: 2 * Dimens.defaultMarginSM),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Dimens.defaultScreenMarginSM,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Latest News", style: AppTextStyles.headline6),
                  Text("See all",
                      style: AppTextStyles.body2.copyWith(
                        color: AppColors.black.shade400,
                      )),
                ],
              ),
            ),
            const SizedBox(height: Dimens.defaultMargin),
            Padding(
              padding:
                  const EdgeInsets.only(left: Dimens.defaultScreenMarginSM),
              child: SizedBox(
                height: 180,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    serviceCard(AppAssets.breaking2, "", () {}),
                    const SizedBox(width: Dimens.defaultMarginB),
                    serviceCard(
                        AppAssets.breaking, "Move In/Out Services", () {}),
                    const SizedBox(width: Dimens.defaultMarginB),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 4 * Dimens.defaultMarginSM),
          ],
        ),
      ),
    );
  }
}
