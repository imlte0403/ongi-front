import 'package:flutter/material.dart';
import 'package:ongi_front/core/app_colors.dart';

/// 프로필 아바타 위젯
/// 프로필 이미지 또는 기본 아이콘을 표시
class ProfileAvatar extends StatelessWidget {
  final String? imageUrl;
  final double radius;
  final bool showEditButton;
  final VoidCallback? onEditTap;

  const ProfileAvatar({
    super.key,
    this.imageUrl,
    this.radius = 50.0,
    this.showEditButton = false,
    this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: radius,
          backgroundColor: AppColors.gray200,
          backgroundImage: imageUrl != null ? NetworkImage(imageUrl!) : null,
          child: imageUrl == null
              ? Icon(
                  Icons.person,
                  size: radius,
                  color: AppColors.gray400,
                )
              : null,
        ),
        if (showEditButton)
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: onEditTap,
              child: Container(
                width: radius * 0.6,
                height: radius * 0.6,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: Icon(
                  Icons.camera_alt,
                  size: radius * 0.3,
                  color: Colors.white,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
