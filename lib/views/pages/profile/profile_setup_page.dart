import 'package:flutter/material.dart';
import 'package:ongi_front/core/app_colors.dart';
import 'package:ongi_front/core/app_spacing.dart';
import 'package:ongi_front/core/app_text_styles.dart';
import 'package:ongi_front/views/widgets/common/profile_avatar.dart';
import 'package:ongi_front/views/widgets/common/labeled_text_field.dart';
import 'package:ongi_front/views/widgets/common/bottom_button_container.dart';
import 'package:ongi_front/views/widgets/common/custom_button.dart';
import 'package:ongi_front/views/pages/profile/profile_complete_page.dart';

/// 프로필 설정 페이지
/// 카카오 로그인 후 자기소개를 입력하는 페이지
class ProfileSetupPage extends StatefulWidget {
  final String nickname;
  final String? email;
  final String? profileImageUrl;

  const ProfileSetupPage({
    super.key,
    required this.nickname,
    this.email,
    this.profileImageUrl,
  });

  @override
  State<ProfileSetupPage> createState() => _ProfileSetupPageState();
}

class _ProfileSetupPageState extends State<ProfileSetupPage> {
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  static const int _maxBioLength = 200;

  @override
  void initState() {
    super.initState();
    _nicknameController.text = widget.nickname;
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '프로필 설정',
          style: AppTextStyles.bodyLarge.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: AppSpacing.xl),

            // 프로필 이미지
            ProfileAvatar(
              imageUrl: widget.profileImageUrl,
              radius: 60,
              showEditButton: true,
              onEditTap: () {
                // TODO: 이미지 선택 기능
              },
            ),

            const SizedBox(height: AppSpacing.xl),

            // 닉네임 입력
            LabeledTextField(
              label: '닉네임',
              controller: _nicknameController,
              hintText: '닉네임을 입력하세요',
            ),

            const SizedBox(height: AppSpacing.lg),

            // 자기소개 입력
            LabeledTextField(
              label: '자기소개',
              controller: _bioController,
              maxLines: 5,
              maxLength: _maxBioLength,
              onChanged: (value) => setState(() {}),
              hintText:
                  '모임에서 사용할 자기소개를 작성해주세요.\n예) 밴드 좋아하는 20대 중반 남자입니다.\n주말마다 한강에서 러닝하는 것을 좋아해요.',
            ),

            const SizedBox(height: AppSpacing.xs),

            // 글자 수
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                '${_bioController.text.length}/$_maxBioLength',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.xl * 2),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomButton(),
    );
  }

  Widget _buildBottomButton() {
    final isValid = _nicknameController.text.trim().isNotEmpty;

    return BottomButtonContainer(
      child: CustomButton(
        text: '완료',
        onPressed: isValid ? _onComplete : () {},
      ),
    );
  }

  void _onComplete() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileCompletePage(
          nickname: _nicknameController.text.trim(),
          bio: _bioController.text.trim(),
          profileImageUrl: widget.profileImageUrl,
        ),
      ),
    );
  }
}
