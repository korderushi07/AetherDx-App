import 'package:flutter/material.dart';
import 'package:aetherdx/core/theme/colors.dart';
import 'package:aetherdx/core/theme/typography.dart';
import 'package:aetherdx/core/theme/radius.dart';
import 'package:aetherdx/core/theme/spacing.dart';
import 'package:aetherdx/core/localization/translations.dart';
import 'package:aetherdx/core/widgets/app_bar.dart';
import 'package:aetherdx/core/widgets/app_button.dart';
import 'package:aetherdx/core/widgets/app_card.dart';

class SpecialistsScreen extends StatelessWidget {
  const SpecialistsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Nearby Specialists'.tr(),
        onBackPressed: () => Navigator.of(context).pop(),
        showNotification: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              // Header text
              Text(
                'Recommended Specialists'.tr(),
                style: AppTypography.screenTitle,
              ),
              const SizedBox(height: 10),
              Text(
                'Based on your recent nail health analysis indicating a potential fungal infection, we recommend consulting these nearby specialists.'.tr(),
                style: const TextStyle(
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
                        Text(
                          'DERMATOLOGISTS'.tr(),
                          style: const TextStyle(
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
                      name: 'Dr. Elena Rostova'.tr(),
                      specialty: 'SKIN & NAIL SPECIALIST'.tr(),
                      distance: '1.2 miles away'.tr(),
                      buttonText: 'Book Appointment'.tr(),
                      isPrimaryButton: true,
                      onButtonPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Appointment booking sheet opened'.tr()),
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
                      name: 'Dr. Marcus Lin'.tr(),
                      specialty: 'DERMATOLOGY'.tr(),
                      distance: '3.4 miles away'.tr(),
                      buttonText: 'View Profile'.tr(),
                      isPrimaryButton: false,
                      onButtonPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Profile opened'.tr()),
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
                  Text(
                    'Nearby Clinics'.tr(),
                    style: AppTypography.sectionHeading,
                  ),
                  TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Viewing all nearby clinics'.tr()),
                          backgroundColor: AppColors.primary,
                        ),
                      );
                    },
                    child: Text(
                      'SEE ALL'.tr(),
                      style: const TextStyle(
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
                              Text(
                                'Apex Dermatology & Clinic'.tr(),
                                style: AppTypography.cardTitle,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '100 Medical Plaza, Suite 250'.tr(),
                                style: const TextStyle(
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
                    Row(
                      children: [
                        const Icon(Icons.map_outlined, size: 16, color: AppColors.textSecondary),
                        const SizedBox(width: 4),
                        Text(
                          '0.8 mi'.tr(),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Icon(Icons.star_rounded, size: 16, color: AppColors.warning),
                        const SizedBox(width: 4),
                        Text(
                          '4.8'.tr(),
                          style: const TextStyle(
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
                            text: 'Call'.tr(),
                            icon: Icons.phone_outlined,
                            isPrimary: false,
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Calling Apex Dermatology & Clinic: +1 (555) 123-4567'.tr()),
                                  backgroundColor: AppColors.primary,
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: AppButton(
                            text: 'Directions'.tr(),
                            icon: Icons.explore_outlined,
                            isPrimary: false,
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Opening Google Maps directions to Apex Dermatology'.tr()),
                                  backgroundColor: AppColors.primary,
                                ),
                              );
                            },
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
                      name.tr(),
                      style: AppTypography.cardTitle,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      specialty.tr(),
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
                          distance.tr(),
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
            text: buttonText.tr(),
            isPrimary: isPrimaryButton,
            icon: isPrimaryButton ? Icons.calendar_month_outlined : null,
            onPressed: onButtonPressed,
          ),
        ],
      ),
    );
  }
}
