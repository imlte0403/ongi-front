import 'package:flutter/material.dart';
import 'package:ongi_front/core/app_colors.dart';
import 'package:ongi_front/core/app_text_styles.dart';
import 'package:ongi_front/core/app_spacing.dart';
import 'package:ongi_front/models/ui/matching_result_model.dart';

class RecommendedClubCard extends StatelessWidget {
  final RecommendedClub club;

  const RecommendedClubCard({
    super.key,
    required this.club,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.gray200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Icon + Name + Match Rate
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Club Icon/Emoji
              Container(
                width: 48,
                height: 48,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  // color: AppColors.gray50, // 디자인상 배경이 없어보임
                  shape: BoxShape.circle,
                ),
                child: Text(
                  club.emoji,
                  style: const TextStyle(fontSize: 32),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),

              // Club Name & Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      club.name,
                      style: AppTextStyles.titleMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${club.memberCount}명 참여 중 | ${club.rating}점',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.gray500,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),

              // Match Rate Badge
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.success,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${club.matchRate}%',
                  style: AppTextStyles.bodyBold.copyWith(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.md),

          // Description
          Text(
            club.description,
            style: AppTextStyles.body.copyWith(
              color: AppColors.gray700,
              height: 1.5,
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          // Tags
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: club.tags.map((tag) {
              // 태그 아이콘 매핑 (간단한 로직)
              String icon = '';
              if (tag.contains('한강')) {
                icon = '📍 ';
              } else if (tag.contains('주'))
                icon = '🗓️ ';
              else if (tag.contains('명')) icon = '👥 ';

              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(
                      0xFFE0F2F1), // 연한 민트색 (Secondary보다 조금 더 진하거나 다른 톤)
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$icon$tag',
                  style: AppTextStyles.caption.copyWith(
                    color: const Color(0xFF00695C), // 진한 민트색 텍스트
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
