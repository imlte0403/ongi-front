import 'package:flutter/material.dart';
import 'package:ongi_front/core/app_colors.dart';

class ResultDescriptionCard extends StatelessWidget {
  final List<String> descriptions;

  const ResultDescriptionCard({
    super.key,
    required this.descriptions,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: List.generate(descriptions.length, (index) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: index == descriptions.length - 1 ? 0 : 20),
            child: _buildDescriptionItem(context,
                number: index + 1, text: descriptions[index]),
          );
        }),
      ),
    );
  }

  Widget _buildDescriptionItem(BuildContext context,
      {required int number, required String text}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Center(
            child: Text(
              number.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  height: 1.5,
                ),
          ),
        ),
      ],
    );
  }
}
