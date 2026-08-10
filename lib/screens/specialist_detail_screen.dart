import 'package:flutter/material.dart';
import '../core/widgets/intent_launcher.dart';
import '../core/theme/colors.dart';
import '../core/theme/typography.dart';
import '../core/theme/radius.dart';
import '../core/theme/spacing.dart';
import '../core/widgets/app_bar.dart';
import '../core/widgets/app_card.dart';
import '../core/localization/translations.dart';
import '../core/network/api_service.dart';
import '../models/specialist_model.dart';

class SpecialistDetailScreen extends StatefulWidget {
  final String doctorId;

  const SpecialistDetailScreen({
    super.key,
    required this.doctorId,
  });

  @override
  State<SpecialistDetailScreen> createState() => _SpecialistDetailScreenState();
}

class _SpecialistDetailScreenState extends State<SpecialistDetailScreen> {
  SpecialistModel? _specialist;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadDetails();
  }

  Future<void> _loadDetails() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await ApiService.getSpecialistDetails(widget.doctorId);
      if (response['success'] == true && response['data'] != null) {
        setState(() {
          _specialist = SpecialistModel.fromJson(response['data']);
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Failed to load details';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _launchPhone(String phone) async {
    await IntentLauncher.launchPhone(phone);
  }

  Future<void> _launchWeb(String url) async {
    await IntentLauncher.launchUrl(url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Specialist Profile'.tr(),
        onBackPressed: () => Navigator.of(context).pop(),
      ),
      body: SafeArea(
        child: _buildBodyContent(),
      ),
    );
  }

  Widget _buildBodyContent() {
    if (_isLoading) {
      return _buildSkeletonLoader();
    }

    if (_errorMessage != null) {
      return _buildErrorState();
    }

    if (_specialist == null) {
      return Center(child: Text('No details available'.tr()));
    }

    final spec = _specialist!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Card
          AppCard(
            padding: const EdgeInsets.all(AppSpacing.cardInternalPadding),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.08),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person_rounded,
                    color: AppColors.primary,
                    size: 40,
                  ),
                ),
                const SizedBox(width: AppSpacing.gapMedium),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (spec.name != null)
                        Text(
                          spec.name!.tr(),
                          style: AppTypography.screenTitle.copyWith(fontSize: 20),
                        ),
                      const SizedBox(height: 6),
                      if (spec.specialization != null)
                        Text(
                          spec.specialization!.tr(),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      if (spec.hospital != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          spec.hospital!.tr(),
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Details Card
          Text(
            'Information'.tr(),
            style: AppTypography.sectionHeading,
          ),
          const SizedBox(height: 8),
          AppCard(
            padding: const EdgeInsets.all(AppSpacing.cardInternalPadding),
            child: Column(
              children: [
                if (spec.city != null) ...[
                  _buildDetailRow(Icons.location_city_rounded, 'City'.tr(), spec.city!),
                  const Divider(color: Color(0xFFF1F5F9), height: 24, thickness: 1),
                ],
                if (spec.state != null) ...[
                  _buildDetailRow(Icons.map_rounded, 'State'.tr(), spec.state!),
                  const Divider(color: Color(0xFFF1F5F9), height: 24, thickness: 1),
                ],
                if (spec.address != null) ...[
                  _buildDetailRow(Icons.location_on_rounded, 'Address'.tr(), spec.address!),
                  const Divider(color: Color(0xFFF1F5F9), height: 24, thickness: 1),
                ],
                if (spec.experience != null) ...[
                  _buildDetailRow(Icons.work_rounded, 'Experience'.tr(), '${spec.experience} ${'years'.tr()}'),
                  const Divider(color: Color(0xFFF1F5F9), height: 24, thickness: 1),
                ],
                if (spec.rating != null) ...[
                  _buildDetailRow(Icons.star_rounded, 'Rating'.tr(), spec.rating.toString()),
                  const Divider(color: Color(0xFFF1F5F9), height: 24, thickness: 1),
                ],
                if (spec.phone != null) ...[
                  _buildDetailRow(Icons.phone_rounded, 'Phone'.tr(), spec.phone!),
                  const Divider(color: Color(0xFFF1F5F9), height: 24, thickness: 1),
                ],
                if (spec.website != null)
                  _buildDetailRow(Icons.public_rounded, 'Website'.tr(), spec.website!),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Action Buttons
          Row(
            children: [
              if (spec.phone != null) ...[
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _launchPhone(spec.phone!),
                    icon: const Icon(Icons.phone, size: 16),
                    label: Text('Call'.tr()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: AppRadius.buttonBorderRadius,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ],
              if (spec.mapsUrl != null) ...[
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _launchWeb(spec.mapsUrl!),
                    icon: const Icon(Icons.directions, size: 16),
                    label: Text('Directions'.tr()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: AppRadius.buttonBorderRadius,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ],
              if (spec.website != null)
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _launchWeb(spec.website!),
                    icon: const Icon(Icons.public, size: 16),
                    label: Text('Visit Website'.tr()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: AppRadius.buttonBorderRadius,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String title, String content) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.primary, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                content,
                style: const TextStyle(fontSize: 14, color: AppColors.textPrimary, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSkeletonLoader() {
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: AppColors.error),
            const SizedBox(height: 16),
            Text(
              'Unable to Load Details'.tr(),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Please try again.'.tr(),
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadDetails,
              child: Text('Retry'.tr()),
            ),
          ],
        ),
      ),
    );
  }
}
