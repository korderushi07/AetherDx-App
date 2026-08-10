import 'package:flutter/material.dart';
import '../core/theme/colors.dart';
import '../core/theme/typography.dart';
import '../core/theme/radius.dart';
import '../core/theme/spacing.dart';
import '../core/localization/translations.dart';
import '../core/widgets/app_bar.dart';
import '../core/widgets/app_card.dart';
import '../core/widgets/animations.dart';
import '../models/specialist_model.dart';
import '../state/consultation_state.dart';
import 'widgets/specialist_card.dart';

class SpecialistsScreen extends StatefulWidget {
  final String conditionName;
  const SpecialistsScreen({super.key, this.conditionName = 'Possible Psoriasis'});

  @override
  State<SpecialistsScreen> createState() => _SpecialistsScreenState();
}

class _SpecialistsScreenState extends State<SpecialistsScreen> {
  late ConsultationState _state;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _state = ConsultationState();
    
    _searchController.addListener(() {
      _state.setSearchQuery(_searchController.text);
    });

    // Initial fetch using widget.conditionName and default city Nagpur
    _state.fetchSpecialists(
      condition: widget.conditionName,
      city: _state.selectedCity,
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _state.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _state,
      builder: (context, _) {
        final label = _state.specialistLabel;
        final title = label.isNotEmpty ? "Recommended $label" : "Recommended Specialists";

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: CustomAppBar(
            title: title.tr(),
            onBackPressed: () => Navigator.of(context).pop(),
          ),
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Area with screening result & City Dropdown
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12),
                      
                      // Screening Result Banner
                      Text(
                        'Based on your screening result'.tr(),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.conditionName.tr(),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // City Dropdown
                      Text(
                        'City'.tr(),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _state.selectedCity,
                            isExpanded: true,
                            icon: const Icon(Icons.arrow_drop_down_rounded, color: AppColors.textSecondary, size: 28),
                            items: <String>['Nagpur', 'Delhi'].map((String city) {
                              return DropdownMenuItem<String>(
                                value: city,
                                child: Text(
                                  city.tr(),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (String? newCity) {
                              if (newCity != null) {
                                _state.fetchSpecialists(
                                  condition: widget.conditionName,
                                  city: newCity,
                                );
                              }
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Search Bar (Only display search bar if not healthy state and not error/loading state)
                      if (!_state.noConsultationRequired && !_state.isLoading && !_state.isError) ...[
                        TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Search specialists...'.tr(),
                            prefixIcon: const Icon(
                              Icons.search_rounded,
                              color: AppColors.textSecondary,
                            ),
                            suffixIcon: _searchController.text.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear_rounded, color: AppColors.textSecondary),
                                    onPressed: () {
                                      _searchController.clear();
                                      _state.setSearchQuery('');
                                    },
                                  )
                                : null,
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                    ],
                  ),
                ),

                // Main body content (loading, error, healthy, empty, success)
                Expanded(
                  child: _buildBodyContent(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBodyContent() {
    if (_state.isLoading) {
      return _buildShimmerState();
    }

    if (_state.isError) {
      return _buildErrorState();
    }

    if (_state.noConsultationRequired) {
      return _buildHealthyState();
    }

    final processed = _state.getProcessedSpecialists();

    if (processed.isEmpty) {
      return _buildEmptyState();
    }

    return _buildSuccessState(processed);
  }

  // Loading shimmer skeleton state
  Widget _buildShimmerState() {
    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      itemCount: 4,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.cardSpace),
          child: AppCard(
            padding: const EdgeInsets.all(AppSpacing.cardInternalPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SkeletonLoader(width: 64, height: 64, borderRadius: 32),
                    const SizedBox(width: AppSpacing.gapMedium),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          SkeletonLoader(width: 140, height: 16, borderRadius: 4),
                          SizedBox(height: 8),
                          SkeletonLoader(width: 100, height: 14, borderRadius: 4),
                          SizedBox(height: 8),
                          SkeletonLoader(width: 160, height: 14, borderRadius: 4),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const SkeletonLoader(width: double.infinity, height: 14, borderRadius: 4),
                const SizedBox(height: 16),
                const SkeletonLoader(width: double.infinity, height: 40, borderRadius: 18),
              ],
            ),
          ),
        );
      },
    );
  }

  // Empty state widget
  Widget _buildEmptyState() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.secondaryBg,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.medical_services_outlined,
                color: AppColors.primary,
                size: 48,
              ),
            ),
            const SizedBox(height: AppSpacing.gapLarge),
            Text(
              'No Specialists Found'.tr(),
              style: AppTypography.sectionHeading.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.gapSmall),
            Text(
              "We couldn't find a matching specialist for the selected city.".tr(),
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: 140,
              child: ElevatedButton(
                onPressed: () {
                  _state.fetchSpecialists(
                    condition: widget.conditionName,
                    city: _state.selectedCity,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadius.buttonBorderRadius,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text('Try Again'.tr(), style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Error state widget
  Widget _buildErrorState() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                color: AppColors.error,
                size: 48,
              ),
            ),
            const SizedBox(height: AppSpacing.gapLarge),
            Text(
              'Unable to Load Specialists'.tr(),
              style: AppTypography.sectionHeading.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.gapSmall),
            Text(
              'Please try again.'.tr(),
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: 140,
              child: ElevatedButton(
                onPressed: () {
                  _state.fetchSpecialists(
                    condition: widget.conditionName,
                    city: _state.selectedCity,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadius.buttonBorderRadius,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text('Retry'.tr(), style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Healthy screening state widget
  Widget _buildHealthyState() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: AppCard(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Color(0xFFDCFCE7),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_outline_rounded,
                  color: Color(0xFF15803D),
                  size: 48,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'No specialist consultation required based on this screening result.'.tr(),
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Success state specialist list
  Widget _buildSuccessState(List<SpecialistModel> list) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding, vertical: 8),
      itemCount: list.length,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        final specialist = list[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.cardSpace),
          child: SpecialistCard(specialist: specialist),
        );
      },
    );
  }
}
