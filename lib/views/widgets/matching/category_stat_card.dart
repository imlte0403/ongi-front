import 'package:flutter/material.dart';
import 'package:ongi_front/core/app_colors.dart';
import 'package:ongi_front/core/app_text_styles.dart';
import 'package:ongi_front/core/app_spacing.dart';
import 'package:ongi_front/models/ui/matching_result_model.dart';

class CategoryStatCard extends StatelessWidget {
  final CategoryStat stat;

  const CategoryStatCard({
    super.key,
    required this.stat,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.gray50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            stat.icon,
            style: const TextStyle(fontSize: 32),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            stat.label,
            style: AppTextStyles.bodyBold,
          ),
          const SizedBox(height: 4),
          Text(
            '${stat.percentage}%',
            style: AppTextStyles.titleMedium.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
