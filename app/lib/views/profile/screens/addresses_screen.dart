
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../components/icon_button.dart';
import '../../../components/appbar.dart';
import '../../../components/gap.dart';
import '../../../models/address.dart';
import '../../../theme/colors.dart';
import '../../../theme/dimens.dart';
import '../../../theme/text.dart';

class AddressesScreen extends StatelessWidget {
  final String userId;

  AddressesScreen({super.key, required this.userId});

  // Demo static addresses
  final List<Address> _demoAddresses = [
    Address(
      id: "1",
      name: "Home",
      addressType: AddressType.home,
      unitNumber: "12",
      buildingName: "Sunrise Apartments",
      street: "Main Street",
      city: "Colombo",
      district: "Western",
      phoneNumber: "0112345678",
      postalCode: "10000",
      country: "Sri Lanka",
    ),
    Address(
      id: "2",
      name: "Office",
      addressType: AddressType.work,
      unitNumber: "5A",
      buildingName: "Tech Park Tower",
      street: "Business Road",
      city: "Kandy",
      district: "Central",
      phoneNumber: "0812345678",
      postalCode: "20000",
      country: "Sri Lanka",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blue.shade50,
      appBar: AppBarCustom(title: 'Addresses'),
      body: _demoAddresses.isEmpty
          ? Center(
              child: const Text(
                'No addresses found.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              itemCount: _demoAddresses.length,
              itemBuilder: (context, index) {
                final address = _demoAddresses[index];
                return Container(
                  margin: const EdgeInsets.only(
                      right: Dimens.defaultScreenMarginSM,
                      top: Dimens.defaultMarginSM,
                      left: Dimens.defaultScreenMarginSM),
                  padding: const EdgeInsets.all(Dimens.defaultMarginSM),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.border,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: AppColors.blue.shade100,
                                  radius: 16,
                                  child: Icon(
                                    address.addressType == AddressType.home
                                        ? Iconsax.house5
                                        : address.addressType ==
                                                AddressType.work
                                            ? Icons.work
                                            : Icons.location_on,
                                    color: AppColors.blue,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Text(
                                  address.name,
                                  style: AppTextStyles.title2,
                                ),
                              ],
                            ),
                            Gapz(),
                            Text(
                              "No: ${address.unitNumber}, ${address.buildingName}",
                              style: AppTextStyles.body1,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "${address.street}, ${address.city}, ${address.district}",
                              style: AppTextStyles.body2.copyWith(
                                color: AppColors.black.shade400,
                              ),
                            ),
                            const SizedBox(height: 4),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomIconButton(
                            icon: Icons.edit,
                            onPressed: () =>
                                _navigateToEditAddress(context, address),
                            iconColor: AppColors.darkGreen,
                            backgroundColor: AppColors.white,
                            borderColor: AppColors.border,
                            size: 20,
                            height: 40,
                          ),
                          SizedBox(width: Dimens.defaultMarginSM),
                          CustomIconButton(
                            icon: Icons.delete,
                            iconColor: AppColors.red,
                            backgroundColor: AppColors.white,
                            borderColor: AppColors.border,
                            size: 20,
                            height: 40,
                            onPressed: () {
                              // For demo, just remove locally
                              _demoAddresses.removeAt(index);
                              (context as Element).markNeedsBuild();
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddAddress(context),
        backgroundColor: AppColors.blue,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _navigateToAddAddress(BuildContext context) {
    context.push('/add-address');
  }

  void _navigateToEditAddress(BuildContext context, Address address) {
    context.push(
      '/edit-address',
      extra: address,
    );
  }
}
