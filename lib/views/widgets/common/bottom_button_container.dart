import 'package:flutter/material.dart';
import 'package:ongi_front/core/app_colors.dart';
import 'package:ongi_front/core/app_spacing.dart';

/// 하단 고정 버튼 컨테이너
/// 그림자와 Safe Area를 포함한 하단 버튼 영역
class BottomButtonContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;

  const BottomButtonContainer({
    super.key,
    required this.child,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: child,
      ),
    );
  }
}
