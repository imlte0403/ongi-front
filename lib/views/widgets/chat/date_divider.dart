import 'package:flutter/material.dart';
import 'package:ongi_front/core/app_colors.dart';
import 'package:ongi_front/core/app_spacing.dart';
import 'package:ongi_front/core/app_text_styles.dart';

/// 날짜 구분선 위젯
class DateDivider extends StatelessWidget {
  final String date;

  const DateDivider({
    super.key,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Center(
        child: Text(
          date,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.textDisabled,
          ),
        ),
      ),
    );
  }
}
