import 'package:flutter/material.dart';
import '../core/theme/colors.dart';
import '../core/theme/typography.dart';
import '../core/theme/spacing.dart';
import '../core/localization/translations.dart';
import '../core/widgets/app_card.dart';
import '../models/clinic_model.dart';

class ClinicDetailScreen extends StatelessWidget {
  final ClinicModel clinic;

  const ClinicDetailScreen({
    super.key,
    required this.clinic,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Scrollable content
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Hero Image Header
              SliverAppBar(
                expandedHeight: 240,
                pinned: true,
                stretch: true,
                backgroundColor: AppColors.primary,
                leading: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_rounded,
                      color: AppColors.textPrimary,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        clinic.photoUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: AppColors.secondaryBg,
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.business_rounded,
                              color: AppColors.primary,
                              size: 64,
                            ),
                          );
                        },
                      ),
                      // Top gradient overlay to improve back button visibility
                      const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black54,
                              Colors.transparent,
                              Colors.transparent,
                            ],
                            stops: [0.0, 0.3, 1.0],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Clinic Details List
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.screenPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Info Card
                      AppCard(
                        padding: const EdgeInsets.all(AppSpacing.cardInternalPadding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Open/Closed badge & Distance
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: clinic.isOpen 
                                        ? AppColors.success.withOpacity(0.12)
                                        : Colors.grey.withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: Text(
                                    clinic.isOpen ? 'OPEN'.tr() : 'CLOSED'.tr(),
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w800,
                                      color: clinic.isOpen ? AppColors.success : AppColors.textSecondary,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.location_on_outlined,
                                      size: 16,
                                      color: AppColors.primary,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${clinic.distance} mi away'.tr(),
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),

                            // Clinic Name
                            Text(
                              clinic.name.tr(),
                              style: AppTypography.screenTitle.copyWith(
                                fontSize: 22,
                              ),
                            ),
                            const SizedBox(height: 8),

                            // Google Rating & Reviews
                            Row(
                              children: [
                                const Icon(
                                  Icons.star_rounded,
                                  size: 20,
                                  color: AppColors.warning,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  clinic.rating.toString(),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '(${clinic.reviewCount} ${'reviews'.tr()})',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: AppSpacing.sectionSpace),

                      // Contact & Availability Info
                      Text(
                        'Clinic Details'.tr(),
                        style: AppTypography.sectionHeading,
                      ),
                      const SizedBox(height: 12),
                      
                      AppCard(
                        padding: const EdgeInsets.all(AppSpacing.cardInternalPadding),
                        child: Column(
                          children: [
                            _buildInfoRow(
                              icon: Icons.map_rounded,
                              title: 'Address'.tr(),
                              content: clinic.address,
                            ),
                            const Divider(color: Color(0xFFF1F5F9), height: 24, thickness: 1),
                            _buildInfoRow(
                              icon: Icons.phone_rounded,
                              title: 'Phone Number'.tr(),
                              content: clinic.phone,
                            ),
                            const Divider(color: Color(0xFFF1F5F9), height: 24, thickness: 1),
                            _buildInfoRow(
                              icon: Icons.public_rounded,
                              title: 'Website'.tr(),
                              content: clinic.website,
                              isLink: true,
                            ),
                            const Divider(color: Color(0xFFF1F5F9), height: 24, thickness: 1),
                            _buildInfoRow(
                              icon: Icons.access_time_rounded,
                              title: 'Opening Hours'.tr(),
                              content: clinic.openingHours,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Call to action options grid
                      GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 2.2,
                        children: [
                          _buildActionTile(
                            context,
                            icon: Icons.phone_rounded,
                            label: 'Call Clinic'.tr(),
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('${'Calling'.tr()} ${clinic.name}: ${clinic.phone}'),
                                  backgroundColor: AppColors.primary,
                                ),
                              );
                            },
                          ),
                          _buildActionTile(
                            context,
                            icon: Icons.directions_rounded,
                            label: 'Get Directions'.tr(),
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('${'Opening maps directions for'.tr()} ${clinic.name}'),
                                  backgroundColor: AppColors.primary,
                                ),
                              );
                            },
                          ),
                          _buildActionTile(
                            context,
                            icon: Icons.public_rounded,
                            label: 'Visit Website'.tr(),
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('${'Opening browser for'.tr()} ${clinic.website}'),
                                  backgroundColor: AppColors.primary,
                                ),
                              );
                            },
                          ),
                          _buildActionTile(
                            context,
                            icon: Icons.share_rounded,
                            label: 'Share Clinic'.tr(),
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('${'Sharing details for'.tr()} ${clinic.name}'),
                                  backgroundColor: AppColors.primary,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String title,
    required String content,
    bool isLink = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            color: AppColors.secondaryBg,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 16,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                content,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isLink ? AppColors.primary : AppColors.textPrimary,
                  decoration: isLink ? TextDecoration.underline : TextDecoration.none,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionTile(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFFE2E8F0),
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: AppColors.primary,
                size: 20,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
