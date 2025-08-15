import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:u_credit_card/u_credit_card.dart';

import '../../../components/appbar.dart';

class PaymentDetailsScreen extends StatefulWidget {
  const PaymentDetailsScreen({super.key});

  @override
  State<PaymentDetailsScreen> createState() => _PaymentDetailsScreenState();
}

class _PaymentDetailsScreenState extends State<PaymentDetailsScreen> {
  List<Map<String, dynamic>> paymentDetails = [
    {
      "type": CardType.debit,
      "number": "1234567812345678",
      "holder": "Vimosh Vasanthakumar",
      "expiry": "08/27",
      "validFrom": "08/22",
      "cvv": "123",
      "color": Colors.blue,
      "balance": 2500.75,
      "providerLogo": const FlutterLogo()
    },
    {
      "type": CardType.credit,
      "number": "8765432187654321",
      "holder": "Vimosh Vasanthakumar",
      "expiry": "11/26",
      "validFrom": "11/21",
      "cvv": "456",
      "color": Colors.purple,
      "balance": 10500.50,
      "providerLogo": const FlutterLogo()
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
      appBar: AppBarCustom(title: 'Payment Details', isBackButtonVisible: true),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            height: 220, // adjust to card height
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: paymentDetails.length,
              itemBuilder: (context, index) {
                final card = paymentDetails[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: GestureDetector(
                    // onTap: () => editCard(index),
                    child: CreditCardUi(
                      cardHolderFullName: card['holder'] ?? '',
                      cardNumber: card['number'] ?? '',
                      validFrom: card['validFrom'] ?? '',
                      validThru: card['expiry'] ?? '',
                      topLeftColor: card['color'] ?? Colors.blue,
                      doesSupportNfc: true,
                      placeNfcIconAtTheEnd: true,
                      cardType: card['type'],
                      cardProviderLogo: card['providerLogo'],
                      cardProviderLogoPosition: CardProviderLogoPosition.right,
                      enableFlipping: true,
                      cvvNumber: card['cvv'] ?? '',
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () {
          // Navigator.pushNamed(context, '/add-payment-method');
        },
        child: const Icon(Iconsax.add),
      ),
    );
  }
}
