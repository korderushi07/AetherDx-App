import 'package:flutter/material.dart';
import 'package:maroapp/core/theme/colors.dart';
import 'package:maroapp/core/theme/typography.dart';
import 'package:maroapp/core/theme/radius.dart';
import 'package:maroapp/core/theme/spacing.dart';
import 'package:maroapp/core/widgets/app_bar.dart';
import 'package:maroapp/core/widgets/app_button.dart';
import 'package:maroapp/core/widgets/app_card.dart';

class SpecialistsScreen extends StatelessWidget {
  const SpecialistsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Medcare',
        onBackPressed: () => Navigator.of(context).pop(),
        showNotification: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              // Header text
              const Text(
                'Recommended Specialists',
                style: AppTypography.screenTitle,
              ),
              const SizedBox(height: 10),
              const Text(
                'Based on your recent nail health analysis indicating a potential fungal infection, we recommend consulting these nearby specialists.',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: AppSpacing.sectionSpace),

              // Specialists Container Card
              AppCard(
                backgroundColor: AppColors.secondaryBg,
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // DERMATOLOGISTS category header banner
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.medical_services_outlined,
                            color: AppColors.primary,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'DERMATOLOGISTS',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w900,
                            color: AppColors.primary,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Doctor 1 Card (Elena Rostova)
                    _buildDoctorCard(
                      context,
                      imageUrl: 'https://images.unsplash.com/photo-1559839734-2b71ea197ec2?auto=format&fit=crop&q=80&w=300',
                      name: 'Dr. Elena Rostova',
                      specialty: 'SKIN & NAIL SPECIALIST',
                      distance: '1.2 miles away',
                      buttonText: 'Book Appointment',
                      isPrimaryButton: true,
                      onButtonPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Appointment booking sheet opened'),
                            backgroundColor: AppColors.primary,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),

                    // Doctor 2 Card (Marcus Lin)
                    _buildDoctorCard(
                      context,
                      imageUrl: 'https://images.unsplash.com/photo-1622253692010-333f2da6031d?auto=format&fit=crop&q=80&w=300',
                      name: 'Dr. Marcus Lin',
                      specialty: 'DERMATOLOGY',
                      distance: '3.4 miles away',
                      buttonText: 'View Profile',
                      isPrimaryButton: false,
                      onButtonPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Profile opened'),
                            backgroundColor: AppColors.primary,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.sectionSpace),

              // Nearby Clinics Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Nearby Clinics',
                    style: AppTypography.sectionHeading,
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'SEE ALL',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Clinic 1 Card (Apex Dermatology)
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: AppRadius.imageBorderRadius,
                          child: Image.network(
                            'https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?auto=format&fit=crop&q=80&w=300',
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 80,
                                height: 80,
                                color: const Color(0xFFE2E8F0),
                                alignment: Alignment.center,
                                child: const Icon(Icons.business_rounded, color: AppColors.textSecondary, size: 36),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Apex Dermatology & Clinic',
                                style: AppTypography.cardTitle,
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                '100 Medical Plaza, Suite 250',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Clinic details row (0.8 mi, 4.8)
                    const Row(
                      children: [
                        Icon(Icons.map_outlined, size: 16, color: AppColors.textSecondary),
                        SizedBox(width: 4),
                        Text(
                          '0.8 mi',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        SizedBox(width: 16),
                        Icon(Icons.star_rounded, size: 16, color: AppColors.warning),
                        SizedBox(width: 4),
                        Text(
                          '4.8',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Action buttons
                    Row(
                      children: [
                        Expanded(
                          child: AppButton(
                            text: 'Call',
                            icon: Icons.phone_outlined,
                            isPrimary: false,
                            onPressed: () {},
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: AppButton(
                            text: 'Directions',
                            icon: Icons.explore_outlined,
                            isPrimary: false,
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDoctorCard(
    BuildContext context, {
    required String imageUrl,
    required String name,
    required String specialty,
    required String distance,
    required String buttonText,
    required bool isPrimaryButton,
    required VoidCallback onButtonPressed,
  }) {
    return AppCard(
      child: Column(
        children: [
          Row(
            children: [
              // Doctor Avatar Image
              ClipRRect(
                borderRadius: AppRadius.imageBorderRadius,
                child: Image.network(
                  imageUrl,
                  width: 64,
                  height: 64,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 64,
                      height: 64,
                      color: const Color(0xFFE2E8F0),
                      alignment: Alignment.center,
                      child: const Icon(Icons.person_rounded, color: AppColors.textSecondary, size: 32),
                    );
                  },
                ),
              ),
              const SizedBox(width: 14),
              // Doctor Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: AppTypography.cardTitle,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      specialty,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textSecondary,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    // Distance row
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, size: 14, color: AppColors.primary),
                        const SizedBox(width: 4),
                        Text(
                          distance,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Action button
          AppButton(
            text: buttonText,
            isPrimary: isPrimaryButton,
            icon: isPrimaryButton ? Icons.calendar_month_outlined : null,
            onPressed: onButtonPressed,
          ),
        ],
      ),
    );
  }
}
