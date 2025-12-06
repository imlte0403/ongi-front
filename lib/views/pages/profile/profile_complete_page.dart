import 'package:flutter/material.dart';
import 'package:ongi_front/core/app_colors.dart';
import 'package:ongi_front/core/app_spacing.dart';
import 'package:ongi_front/core/app_text_styles.dart';
import 'package:ongi_front/views/widgets/common/profile_avatar.dart';
import 'package:ongi_front/views/widgets/common/bottom_button_container.dart';
import 'package:ongi_front/views/pages/club/club_detail_page.dart';

/// 프로필 완성 페이지
/// 프로필 설정이 완료된 후 보여지는 확인 페이지
class ProfileCompletePage extends StatelessWidget {
  final String nickname;
  final String bio;
  final String? profileImageUrl;

  const ProfileCompletePage({
    super.key,
    required this.nickname,
    required this.bio,
    this.profileImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            children: [
              const SizedBox(height: AppSpacing.xl * 2),

              // 헤더 텍스트
              _buildHeader(),

              const SizedBox(height: AppSpacing.xl),

              // 프로필 카드
              Expanded(
                child: Center(
                  child: _buildProfileCard(),
                ),
              ),

              // 하단 버튼들
              _buildBottomButtons(context),

              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Text(
          '프로필이 완성되었습니다!',
          style: AppTextStyles.pageTitle.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          '모임에서 사용할 프로필이 준비되었습니다',
          style: AppTextStyles.body.copyWith(
            color: AppColors.textTertiary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildProfileCard() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 프로필 이미지
          ProfileAvatar(
            imageUrl: profileImageUrl,
            radius: 50,
          ),

          const SizedBox(height: AppSpacing.lg),

          // 닉네임
          Text(
            nickname,
            style: AppTextStyles.sectionTitle.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          // 자기소개
          if (bio.isNotEmpty)
            Text(
              bio,
              style: AppTextStyles.body.copyWith(
                color: AppColors.textDisabled,
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),

          if (bio.isEmpty)
            Text(
              '자기소개가 없습니다.',
              style: AppTextStyles.body.copyWith(
                color: AppColors.textTertiary,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
        ],
      ),
    );
  }

  Widget _buildBottomButtons(BuildContext context) {
    return Column(
      children: [
        // 다시 수정하기 버튼
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            '다시 수정하기',
            style: AppTextStyles.body.copyWith(
              color: AppColors.textTertiary,
            ),
          ),
        ),

        const SizedBox(height: AppSpacing.sm),

        // 모임 채팅방 입장하기 버튼
        BottomButtonContainer(
          padding: EdgeInsets.zero,
          child: SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ClubDetailPage(clubId: 1),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '모임 채팅방 입장하기',
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  const Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
