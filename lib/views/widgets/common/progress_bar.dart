import 'package:flutter/material.dart';
import '../../../core/app_colors.dart';


/// 진행 상황 표시 바
/// N/10 형식으로 현재 진행도를 표시
class ProgressBar extends StatelessWidget {
  final int current;
  final int total;
  final double height;
  
  const ProgressBar({
    super.key,
    required this.current,
    required this.total,
    this.height = 4.0,
  });
  
  @override
  Widget build(BuildContext context) {
    final progress = current / total;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 진행 바
        Container(
          height: height,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(height / 2),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: progress,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(height / 2),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        // 텍스트
        Text(
          '$current/$total',
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textTertiary,
          ),
        ),
      ],
    );
  }
}
