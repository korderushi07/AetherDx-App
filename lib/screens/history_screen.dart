import 'package:flutter/material.dart';
import 'result_screen.dart';

class HistoryScreen extends StatelessWidget {
  final VoidCallback onBackPressed;

  const HistoryScreen({
    super.key,
    required this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    const Color darkTeal = Color(0xFF1F484C);
    const Color slateText = Color(0xFF1E293B);
    const Color mutedText = Color(0xFF64748B);
    const Color borderGrey = Color(0xFFF1F5F9);

    final List<Map<String, dynamic>> historyData = [
      {
        'date': 'Nov 1, 2025',
        'condition': 'Fungal Infection',
        'confidence': '92%',
        'region': 'Left Index Finger',
        'action': 'Topical Antifungal',
        'titleColor': const Color(0xFF1F484C),
        'badgeBg': const Color(0xFF1F484C),
        'badgeText': Colors.white,
        'reportParams': {
          'conditionName': 'Fungal Infection',
          'matchPercentage': 92,
          'confidenceLabel': 'High confidence',
          'description': 'A common fungal infection of the nail, causing discoloration, scaling, and thickening. It is often caused by dermatophytes.',
          'keySigns': 'Discoloration, scaling under the nail, thickening, and crumbly edges',
          'nextSteps': 'Consult a dermatologist to confirm diagnosis and obtain prescription antifungal medication',
          'careTips': 'Keep nails dry and clean, wear breathable socks, and avoid sharing nail clippers',
        }
      },
      {
        'date': 'March 20, 2025',
        'condition': 'Healthy Nail',
        'confidence': '98%',
        'region': 'Right Thumb',
        'action': 'Routine Care',
        'titleColor': slateText,
        'badgeBg': const Color(0xFFE2E8F0),
        'badgeText': slateText,
        'reportParams': {
          'conditionName': 'Healthy Nail',
          'matchPercentage': 98,
          'confidenceLabel': 'Very high confidence',
          'description': 'Your nail appears healthy and shows no major signs of infection, psoriasis, or other common disorders.',
          'keySigns': 'Smooth texture, consistent pinkish hue, normal thickness, and intact cuticle',
          'nextSteps': 'No immediate medical action required. Maintain your routine hand and nail hygiene',
          'careTips': 'Moisturize cuticles, trim nails straight across, and avoid harsh chemical nail products',
        }
      },
      {
        'date': 'Feb 18, 2025',
        'condition': 'Nail Psoriasis',
        'confidence': '85%',
        'region': 'Left Thumb',
        'action': 'Dermatologist Consult',
        'titleColor': const Color(0xFF8C5333),
        'badgeBg': const Color(0xFFFEE2E2),
        'badgeText': const Color(0xFF991B1B),
        'reportParams': {
          'conditionName': 'Nail Psoriasis',
          'matchPercentage': 85,
          'confidenceLabel': 'High confidence',
          'description': 'A chronic autoimmune condition that affects nail cells, causing changes in appearance.',
          'keySigns': 'Pitting, discoloration, rough texture, and nail thickening',
          'nextSteps': 'Consult a dermatologist for proper diagnosis and treatment',
          'careTips': 'Keep nails moisturized, avoid trauma, and manage stress',
        }
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            // 1. Header Row (Back, Title, Notification Bell)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back Button
                  GestureDetector(
                    onTap: onBackPressed,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.02),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: slateText,
                        size: 20,
                      ),
                    ),
                  ),
                  // Title
                  const Text(
                    'Analysis History',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: slateText,
                      letterSpacing: -0.5,
                    ),
                  ),
                  // Bell Notification Icon
                  Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: const Icon(
                          Icons.notifications_outlined,
                          color: slateText,
                          size: 20,
                        ),
                      ),
                      Positioned(
                        right: 2,
                        top: 2,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Color(0xFFEF4444),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // 2. Action Filter Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Showing all past nail analysis entries',
                    style: TextStyle(
                      fontSize: 13,
                      color: mutedText,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(
                          Icons.filter_list_rounded,
                          color: slateText,
                          size: 16,
                        ),
                        SizedBox(width: 6),
                        Text(
                          'Filter',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: slateText,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 3. Timeline Entries List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 80.0),
                itemCount: historyData.length,
                itemBuilder: (context, index) {
                  final item = historyData[index];
                  final bool isFirst = index == 0;
                  final bool isLast = index == historyData.length - 1;

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
                                            color: darkTeal,
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
                              Text(
                                item['date'],
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: slateText,
                                ),
                              ),
                              const SizedBox(height: 10),

                              // Report Card
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(20.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(color: borderGrey, width: 1.5),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.02),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Row 1: Upper labels
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: const [
                                        Text(
                                          'CONDITION DETECTED',
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xFF94A3B8),
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                        Text(
                                          'CONFIDENCE SCORE',
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xFF94A3B8),
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
                                        Text(
                                          item['condition'],
                                          style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w800,
                                            color: item['titleColor'],
                                          ),
                                        ),
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
                                      color: borderGrey,
                                      thickness: 1.5,
                                      height: 24,
                                    ),

                                    // Row 3: Metadata columns
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Analyzed Region',
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: mutedText,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              item['region'],
                                              style: const TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w700,
                                                color: slateText,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Recommended Action',
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: mutedText,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              item['action'],
                                              style: const TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w700,
                                                color: slateText,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const Divider(
                                      color: borderGrey,
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
                                        children: const [
                                          Text(
                                            'View full report',
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w800,
                                              color: darkTeal,
                                            ),
                                          ),
                                          SizedBox(width: 4),
                                          Icon(
                                            Icons.chevron_right_rounded,
                                            color: darkTeal,
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
