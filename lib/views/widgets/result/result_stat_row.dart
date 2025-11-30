import 'package:flutter/material.dart';
import 'package:ongi_front/core/app_colors.dart';

class ResultStatRow extends StatelessWidget {
  final String label;
  final double value;

  const ResultStatRow({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            Text(
              '${(value * 100).toInt()}%',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: const Color(0xFF9E9E9E),
                  ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: value,
            backgroundColor: const Color(0xFFF5F5F5),
            color: AppColors.primary,
            minHeight: 8,
          ),
        ),
      ],
    );
  }
}
