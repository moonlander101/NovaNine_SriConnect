import 'package:flutter/material.dart';
import '../../../components/appbar.dart';
import '../../../theme/colors.dart';

class PublicAssistanceScreen extends StatelessWidget {
  const PublicAssistanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blue.shade50,
      appBar: const AppBarCustom(
        title: 'Public Assistance',
        isBackButtonVisible: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.blue.shade200, width: 1),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x05000000),
                      offset: Offset(0, 0),
                      blurRadius: 20,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: AppColors.blue.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.people_outline,
                            color: AppColors.blue,
                            size: 30,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Public Assistance',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.fontColor,
                                  fontFamily: 'DM Sans',
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Government assistance programs and support services',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.black.shade400,
                                  fontFamily: 'DM Sans',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Services List
              Text(
                'Available Services',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.fontColor,
                  fontFamily: 'DM Sans',
                ),
              ),
              
              const SizedBox(height: 16),
              
              Expanded(
                child: ListView(
                  children: [
                    _buildServiceCard(
                      'Financial Assistance',
                      'Government grants and financial support programs',
                      Icons.account_balance_wallet,
                    ),
                    _buildServiceCard(
                      'Housing Support',
                      'Housing assistance and accommodation programs',
                      Icons.home,
                    ),
                    _buildServiceCard(
                      'Healthcare Aid',
                      'Medical assistance and healthcare support',
                      Icons.medical_services,
                    ),
                    _buildServiceCard(
                      'Education Support',
                      'Educational grants and scholarship programs',
                      Icons.school,
                    ),
                    _buildServiceCard(
                      'Employment Aid',
                      'Job training and employment assistance',
                      Icons.work,
                    ),
                    _buildServiceCard(
                      'Disability Support',
                      'Support services for persons with disabilities',
                      Icons.accessible,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildServiceCard(String title, String description, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.blue.shade200, width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x05000000),
            offset: Offset(0, 0),
            blurRadius: 20,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.blue.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: AppColors.blue,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.fontColor,
                    fontFamily: 'DM Sans',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.black.shade400,
                    fontFamily: 'DM Sans',
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: AppColors.black.shade300,
            size: 16,
          ),
        ],
      ),
    );
  }
}
