import 'package:flutter/material.dart';
import 'package:ongi_front/core/app_colors.dart';

class ResultSimilarClubCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String info;
  final int matchRate;
  final Color backgroundColor;

  const ResultSimilarClubCard({
    super.key,
    required this.icon,
    required this.title,
    required this.info,
    required this.matchRate,
    this.backgroundColor = const Color(0xFFF0F9F4),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 24, color: Colors.blueAccent), // 예시 색상
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: 16,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  info,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: const Color(0xFF757575),
                      ),
                ),
              ],
            ),
          ),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary, width: 2),
            ),
            child: Center(
              child: Text(
                '$matchRate%',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
