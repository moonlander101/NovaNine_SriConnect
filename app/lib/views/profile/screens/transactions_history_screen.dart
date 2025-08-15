import 'package:flutter/material.dart';
import 'package:lanka_connect/theme/assets.dart';
import 'package:lanka_connect/theme/colors.dart';
import 'package:lanka_connect/theme/dimens.dart';
import 'package:lanka_connect/theme/text.dart';

import '../../../components/appbar.dart';

class TransactionsHistoryScreen extends StatefulWidget {
  const TransactionsHistoryScreen({super.key});

  @override
  State<TransactionsHistoryScreen> createState() =>
      _TransactionsHistoryScreenState();
}

class _TransactionsHistoryScreenState extends State<TransactionsHistoryScreen> {
  List<Map<String, dynamic>> transactions = [
    {
      "amount": "1400",
      "Date": "12 July 2025, 03.45PM",
      "TransId": "08/27",
      "image": AppAssets.bill2,
      "title": "Water Bill",
    },
    {
      "amount": "3200",
      "Date": "12 July 2025, 03.45PM",
      "TransId": "08/27",
      "image": AppAssets.bill1,
      "title": "CEB Bill",
    },
  ];

  // void editCard(int index) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (_) => EditPaymentCardScreen(cardData: paymentDetails[index]),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blue.shade50,
      appBar: AppBarCustom(title: 'Payment Details', isBackButtonVisible: true),
      body: Padding(
        padding: const EdgeInsets.all(Dimens.defaultScreenMarginSM),
        child: Align(
          alignment: Alignment.topLeft,
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final transaction = transactions[index];
              return GestureDetector(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(Dimens.defaultRadiusM),
                    border: Border.all(
                      color: AppColors.blue.shade200, // or any color you prefer
                      width: 1,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        transaction['image'],
                        width: 40,
                        height: 40,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              transaction['title'],
                              style: AppTextStyles.title2,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${transaction['Date']}',
                              style: AppTextStyles.body2.copyWith(
                                color: AppColors.black.shade400,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'TransId: ${transaction['TransId']}',
                              style: AppTextStyles.body2.copyWith(
                                color: AppColors.black.shade400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '-${transaction['amount']}',
                        style: AppTextStyles.title3.copyWith(
                          color: AppColors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
