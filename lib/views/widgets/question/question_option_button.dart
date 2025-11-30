import 'package:flutter/material.dart';
import 'package:ongi_front/core/app_colors.dart';

/// 질문 선택지 버튼
/// 선택 시 Primary 색상 배경, 미선택 시 테두리만 표시
class QuestionOptionButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const QuestionOptionButton({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(
          minHeight: 60,
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 18,
          horizontal: 20,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          border: Border.all(
            color: AppColors.primary,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          text,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: isSelected ? Colors.white : Colors.black,
              ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
