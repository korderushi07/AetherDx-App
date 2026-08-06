import 'package:flutter/material.dart';
import 'package:aetherdx/core/theme/colors.dart';
import 'package:aetherdx/core/theme/typography.dart';
import 'package:aetherdx/core/localization/translations.dart';
import 'package:aetherdx/core/widgets/app_bar.dart';
import 'package:aetherdx/core/widgets/app_card.dart';
import '../core/network/api_service.dart';
import 'result_screen.dart';

class HistoryScreen extends StatefulWidget {
  final VoidCallback onBackPressed;

  const HistoryScreen({
    super.key,
    required this.onBackPressed,
  });

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<Map<String, dynamic>> _historyData = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchHistory();
  }

  Future<void> _fetchHistory() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final data = await ApiService.getPredictionHistory();
      
      final List<Map<String, dynamic>> formatted = data.map((item) {
        final predictedClass = item['predicted_class'] as String? ?? 'Healthy';
        final confidence = (item['confidence'] as num?)?.toDouble() ?? 0.0;
        final createdAt = item['created_at'] as String? ?? '';
        
        final reportParams = _mapModelResult(predictedClass, confidence);
        final visualParams = _getVisualParams(predictedClass);
        
        return {
          'date': _formatDate(createdAt),
          'condition': visualParams['condition'],
          'confidence': '${(confidence * 100).toInt()}%',
          'region': 'Fingernail',
          'action': visualParams['action'],
          'titleColor': visualParams['titleColor'],
          'badgeBg': visualParams['badgeBg'],
          'badgeText': visualParams['badgeText'],
          'reportParams': reportParams,
        };
      }).toList();

      setState(() {
        _historyData = formatted;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Map<String, dynamic> _getVisualParams(String predictedClass) {
    switch (predictedClass) {
      case 'Psoriasis':
        return {
          'condition': 'Nail Psoriasis'.tr(),
          'titleColor': const Color(0xFF8C5333),
          'badgeBg': const Color(0xFFFEE2E2),
          'badgeText': AppColors.error,
          'action': 'Dermatologist Consult'.tr(),
        };
      case 'Liver Disease':
        return {
          'condition': 'Terry\'s Nails'.tr(),
          'titleColor': const Color(0xFFB45309),
          'badgeBg': const Color(0xFFFEF3C7),
          'badgeText': const Color(0xFFD97706),
          'action': 'Hepatologist Consult'.tr(),
        };
      case 'Healthy':
      default:
        return {
          'condition': 'Healthy Nail'.tr(),
          'titleColor': AppColors.textPrimary,
          'badgeBg': AppColors.secondaryBg,
          'badgeText': AppColors.primary,
          'action': 'Routine Care'.tr(),
        };
    }
  }

  Map<String, dynamic> _mapModelResult(String predictedClass, double confidence) {
    final int match = (confidence * 100).toInt();
    final String confidenceLabel = confidence >= 0.85 ? 'High confidence'.tr() : 'Moderate confidence'.tr();
    
    switch (predictedClass) {
      case 'Psoriasis':
        return {
          'conditionName': 'Nail Psoriasis'.tr(),
          'matchPercentage': match,
          'confidenceLabel': confidenceLabel,
          'description': 'A chronic autoimmune condition that affects nail cells, causing changes in appearance like pitting or scaling.'.tr(),
          'keySigns': 'Pitting, yellow-brown discoloration, and crumbling nail texture'.tr(),
          'nextSteps': 'Consult a dermatologist for a focused clinical skin examination'.tr(),
          'careTips': 'Keep your hands well-moisturized, trim nails straight, and avoid mechanical injury'.tr(),
        };
      case 'Liver Disease':
        return {
          'conditionName': 'Terry\'s Nails (Possible Liver Health Sign)'.tr(),
          'matchPercentage': match,
          'confidenceLabel': confidenceLabel,
          'description': 'A structural nail change where the nail plate appears pale/white except for a thin dark band at the tip, which can correspond to metabolic or liver factors.'.tr(),
          'keySigns': 'Pale white nail bed, narrow pink/red distal band, loss of half-moon lunula'.tr(),
          'nextSteps': 'Consult a general practitioner or gastroenterologist for standard liver function tests'.tr(),
          'careTips': 'Maintain a balanced nutritious diet, limit sodium/saturated fats, and strictly avoid alcohol'.tr(),
        };
      case 'Healthy':
      default:
        return {
          'conditionName': 'Healthy Nails'.tr(),
          'matchPercentage': match,
          'confidenceLabel': confidenceLabel,
          'description': 'Your nail structure and texture appear completely normal and healthy, showing no signs of systemic conditions.'.tr(),
          'keySigns': 'Smooth and even nail plate, pink nail beds, firm and flexible tip'.tr(),
          'nextSteps': 'Maintain your current daily nail hygiene and healthy balanced diet'.tr(),
          'careTips': 'Keep hands clean and moisturized, avoid aggressive cleaning under nails, and let nails breathe between polishes'.tr(),
        };
    }
  }

  String _formatDate(String isoString) {
    try {
      final date = DateTime.parse(isoString);
      final months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      return '${months[date.month - 1]} ${date.day}, ${date.year}';
    } catch (_) {
      return 'Recent';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Analysis History'.tr(),
        onBackPressed: widget.onBackPressed,
        showNotification: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 2. Action Filter Bar (Only show if there is data or loading)
            if (!_isLoading && _errorMessage == null && _historyData.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Showing all past nail analysis entries'.tr(),
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: _fetchHistory,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.refresh_rounded,
                              color: AppColors.textPrimary,
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Refresh'.tr(),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 16),

            // 3. Main Content Area
            Expanded(
              child: _buildBodyContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBodyContent() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline_rounded,
                color: AppColors.error,
                size: 48,
              ),
              const SizedBox(height: 16),
              Text(
                'Failed to load history'.tr(),
                style: AppTypography.sectionHeading.copyWith(color: AppColors.error),
              ),
              const SizedBox(height: 8),
              Text(
                _errorMessage!.tr(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _fetchHistory,
                icon: const Icon(Icons.refresh_rounded),
                label: Text('Retry'.tr()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_historyData.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  color: AppColors.secondaryBg,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.assignment_outlined,
                  color: AppColors.primary,
                  size: 48,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'No scan history found'.tr(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Start scanning your nails from the Dashboard to see your diagnostic reports recorded here.'.tr(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _fetchHistory,
                icon: const Icon(Icons.refresh_rounded),
                label: Text('Refresh'.tr()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 120.0),
      itemCount: _historyData.length,
      itemBuilder: (context, index) {
        final item = _historyData[index];
        final bool isFirst = index == 0;
        final bool isLast = index == _historyData.length - 1;
        final bool showDateHeader = index == 0 || _historyData[index]['date'] != _historyData[index - 1]['date'];

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Left Timeline Column
              SizedBox(
                width: 32,
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    // Connector line
                    Positioned(
                      top: isFirst ? 14 : 0,
                      bottom: isLast ? 0 : 0,
                      child: Container(
                        width: 2,
                        decoration: BoxDecoration(
                          color: isLast
                              ? Colors.transparent
                              : const Color(0xFFE2E8F0),
                        ),
                      ),
                    ),
                    if (isLast)
                      Positioned(
                        top: 0,
                        bottom: 14,
                        child: Container(
                          width: 2,
                          color: const Color(0xFFE2E8F0),
                        ),
                      ),
                    // Bullet Dot
                    Positioned(
                      top: 6,
                      child: isFirst
                          ? Container(
                              width: 16,
                              height: 16,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.primary,
                                  width: 4,
                                ),
                              ),
                            )
                          : Container(
                              width: 10,
                              height: 10,
                              decoration: const BoxDecoration(
                                color: Color(0xFFCBD5E1),
                                shape: BoxShape.circle,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),

              // Right Details Column & Card
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Date Header
                    if (showDateHeader) ...[
                      Text(
                        item['date'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],

                    // Report Card
                    AppCard(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Row 1: Upper labels
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'CONDITION DETECTED'.tr(),
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.placeholder,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              Text(
                                'CONFIDENCE SCORE'.tr(),
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.placeholder,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),

                          // Row 2: Title and badge
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  item['condition'],
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w800,
                                    color: item['titleColor'],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: item['badgeBg'],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  item['confidence'],
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                    color: item['badgeText'],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Divider(
                            color: AppColors.secondaryBg,
                            thickness: 1.5,
                            height: 24,
                          ),

                          // Row 3: Metadata columns
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Analyzed Region'.tr(),
                                      style: AppTypography.caption,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      (item['region'] as String).tr(),
                                      softWrap: true,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                flex: 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Recommended Action'.tr(),
                                      style: AppTypography.caption,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      (item['action'] as String).tr(),
                                      softWrap: true,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const Divider(
                            color: AppColors.secondaryBg,
                            thickness: 1.5,
                            height: 24,
                          ),

                          // Row 4: View full report link
                          GestureDetector(
                            onTap: () {
                              final report = item['reportParams'] as Map<String, dynamic>;
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => ResultScreen(
                                    conditionName: report['conditionName'],
                                    matchPercentage: report['matchPercentage'],
                                    confidenceLabel: report['confidenceLabel'],
                                    description: report['description'],
                                    keySigns: report['keySigns'],
                                    nextSteps: report['nextSteps'],
                                    careTips: report['careTips'],
                                  ),
                                ),
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  'View full report'.tr(),
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.primary,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(
                                  Icons.chevron_right_rounded,
                                  color: AppColors.primary,
                                  size: 16,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
