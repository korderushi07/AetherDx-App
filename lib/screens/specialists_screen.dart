import 'package:flutter/material.dart';
import 'package:maroapp/core/theme/colors.dart';
import 'package:maroapp/core/theme/spacing.dart';
import 'package:maroapp/core/theme/typography.dart';
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
                style: AppTypography.heading1,
              ),
              const SizedBox(height: 4),
              const Text(
                'Matching: Fungal Infection',
                style: AppTypography.overline,
              ),
              const SizedBox(height: 12),
              const Text(
                'Based on your recent nail health analysis indicating a potential fungal infection, we recommend consulting these nearby specialists.',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: AppSpacing.sectionSpace),

              // Specialists Directory List (Removed Mint background wrapper)
              const Text(
                'SKIN & NAIL CLINICIANS',
                style: AppTypography.overline,
              ),
              const SizedBox(height: 12),

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
              const SizedBox(height: 12),

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
              const SizedBox(height: AppSpacing.sectionSpace),

              // Nearby Clinics Section Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'NEARBY CLINICS',
                    style: AppTypography.overline,
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'SEE ALL',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Clinic 1 Card (Apex Dermatology)
              _buildClinicCard(
                imageUrl: 'https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?auto=format&fit=crop&q=80&w=300',
                name: 'Apex Dermatology & Clinic',
                address: '100 Medical Plaza, Suite 250',
                distance: '0.8 mi',
                rating: '4.8',
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
              // 48px Circular avatar image with 1px border
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.border, width: 1.0),
                ),
                child: ClipOval(
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: AppColors.secondaryBg,
                        alignment: Alignment.center,
                        child: const Icon(Icons.person_rounded, color: AppColors.textSecondary, size: 24),
                      );
                    },
                  ),
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
                      '$specialty · $distance',
                      style: AppTypography.caption,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Action button
          AppButton(
            text: textScaleCorrect(buttonText),
            isPrimary: isPrimaryButton,
            backgroundColor: isPrimaryButton ? AppColors.primary : Colors.white,
            textColor: isPrimaryButton ? Colors.white : AppColors.textPrimary,
            borderColor: isPrimaryButton ? null : AppColors.border,
            icon: isPrimaryButton ? Icons.calendar_month_outlined : null,
            onPressed: onButtonPressed,
          ),
        ],
      ),
    );
  }

  Widget _buildClinicCard({
    required String imageUrl,
    required String name,
    required String address,
    required String distance,
    required String rating,
  }) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 80x80px Clinic thumbnail with 12px radius
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  imageUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 80,
                      height: 80,
                      color: AppColors.secondaryBg,
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
                      name,
                      style: AppTypography.cardTitle,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      address,
                      style: AppTypography.caption,
                    ),
                    const SizedBox(height: 6),
                    // Distance + Rating inline
                    Row(
                      children: [
                        const Icon(Icons.map_outlined, size: 14, color: AppColors.textSecondary),
                        const SizedBox(width: 4),
                        Text(
                          '$distance  ·  ',
                          style: AppTypography.caption.copyWith(fontWeight: FontWeight.w600),
                        ),
                        const Icon(Icons.star_rounded, size: 14, color: AppColors.warning),
                        const SizedBox(width: 4),
                        Text(
                          rating,
                          style: AppTypography.caption.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Action buttons Call & Directions
          Row(
            children: [
              Expanded(
                child: AppButton(
                  text: 'Call',
                  icon: Icons.phone_outlined,
                  isPrimary: false,
                  backgroundColor: Colors.white,
                  textColor: AppColors.textPrimary,
                  borderColor: AppColors.border,
                  onPressed: () {},
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AppButton(
                  text: 'Directions',
                  icon: Icons.explore_outlined,
                  isPrimary: false,
                  backgroundColor: Colors.white,
                  textColor: AppColors.textPrimary,
                  borderColor: AppColors.border,
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String textScaleCorrect(String text) {
    return text;
  }
}
