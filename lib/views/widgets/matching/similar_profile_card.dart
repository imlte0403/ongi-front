import 'package:flutter/material.dart';
import 'package:ongi_front/core/app_colors.dart';
import 'package:ongi_front/core/app_text_styles.dart';
import 'package:ongi_front/core/app_spacing.dart';
import 'package:ongi_front/models/ui/matching_result_model.dart';

class SimilarProfileCard extends StatelessWidget {
  final SimilarProfile profile;

  const SimilarProfileCard({
    super.key,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.gray200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: AppColors.gray100,
            backgroundImage: NetworkImage(profile.imageUrl),
            onBackgroundImageError: (_, __) {}, // 이미지 로드 실패 시 처리
            child: profile.imageUrl.isEmpty
                ? const Icon(Icons.person, color: AppColors.gray400)
                : null,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            profile.name,
            style: AppTextStyles.bodyBold,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            profile.mbti,
            style: AppTextStyles.caption.copyWith(color: AppColors.primary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            profile.description,
            style: AppTextStyles.caption.copyWith(color: AppColors.gray600),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
