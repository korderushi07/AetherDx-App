import 'package:flutter/material.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/typography.dart';
import '../../core/theme/radius.dart';
import '../../core/theme/spacing.dart';
import '../../core/localization/translations.dart';
import '../../core/widgets/app_card.dart';
import '../../models/specialist_model.dart';
import '../specialist_detail_screen.dart';

class SpecialistCard extends StatelessWidget {
  final SpecialistModel specialist;

  const SpecialistCard({
    super.key,
    required this.specialist,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.cardInternalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar Placeholder
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person_rounded,
                  color: AppColors.primary,
                  size: 36,
                ),
              ),
              const SizedBox(width: AppSpacing.gapMedium),
              
              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (specialist.name != null)
                      Text(
                        specialist.name!.tr(),
                        style: AppTypography.cardTitle.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    const SizedBox(height: 4),
                    if (specialist.specialization != null)
                      Text(
                        specialist.specialization!.tr(),
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    const SizedBox(height: 4),
                    if (specialist.hospital != null)
                      Text(
                        specialist.hospital!.tr(),
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    if (specialist.city != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        specialist.city!.tr(),
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Experience & Rating Row
          Row(
            children: [
              if (specialist.experience != null) ...[
                const Icon(Icons.work_outline_rounded, size: 16, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Text(
                  '${specialist.experience} ${'years exp'.tr()}',
                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                ),
                const SizedBox(width: 16),
              ],
              if (specialist.rating != null) ...[
                const Icon(Icons.star_rounded, size: 16, color: AppColors.warning),
                const SizedBox(width: 4),
                Text(
                  specialist.rating.toString(),
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
              ],
            ],
          ),
          
          if (specialist.address != null) ...[
            const SizedBox(height: 8),
            Text(
              specialist.address!.tr(),
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          
          const SizedBox(height: 12),
          
          // View Details CTA
          SizedBox(
            width: double.infinity,
            height: 40,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => SpecialistDetailScreen(doctorId: specialist.id),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: AppRadius.buttonBorderRadius,
                ),
              ),
              child: Text(
                'View Details'.tr(),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
