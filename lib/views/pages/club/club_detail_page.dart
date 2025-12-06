import 'package:flutter/material.dart';
import 'package:ongi_front/core/app_colors.dart';
import 'package:ongi_front/core/app_spacing.dart';
import 'package:ongi_front/core/app_text_styles.dart';
import 'package:ongi_front/models/entities/club_detail_model.dart';
import 'package:ongi_front/models/mock/mock_club_detail.dart';
import 'package:ongi_front/views/pages/chat/chat_room_page.dart';
import 'package:ongi_front/views/widgets/common/bottom_button_container.dart';
import 'package:ongi_front/views/widgets/common/custom_button.dart';
import 'package:ongi_front/utils/app_logger.dart';
import 'package:intl/intl.dart';

/// 모임 상세 페이지
class ClubDetailPage extends StatelessWidget {
  final int clubId;

  const ClubDetailPage({
    super.key,
    required this.clubId,
  });

  @override
  Widget build(BuildContext context) {
    // Mock 데이터 사용
    final club = MockClubDetail.weekendRunningCrew;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                // 앱바 + 커버 이미지
                _buildSliverAppBar(context, club),

                // 컨텐츠
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDescriptionSection(club),
                        const SizedBox(height: AppSpacing.xl),
                        _buildMembersSection(club),
                        const SizedBox(height: AppSpacing.xl),
                        _buildNextMeetingSection(club),
                        const SizedBox(height: AppSpacing.xl),
                        _buildRulesSection(club),
                        const SizedBox(height: AppSpacing.xl),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 하단 버튼
          _buildBottomButton(context, club),
        ],
      ),
    );
  }

  /// 슬리버 앱바 + 커버 이미지
  Widget _buildSliverAppBar(BuildContext context, ClubDetail club) {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      backgroundColor: AppColors.background,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          club.name,
          style: AppTextStyles.bodyLarge.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              club.coverImageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: AppColors.primary,
                child: const Center(
                  child: Icon(Icons.groups, size: 64, color: Colors.white54),
                ),
              ),
            ),
            // 그라데이션 오버레이
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.7),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 모임 소개 섹션
  Widget _buildDescriptionSection(ClubDetail club) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '모임 소개',
          style: AppTextStyles.sectionTitle.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            club.description,
            style: AppTextStyles.body.copyWith(
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ),
        ),
      ],
    );
  }

  /// 모임 멤버 섹션
  Widget _buildMembersSection(ClubDetail club) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '모임 멤버 (${club.members.length}명)',
          style: AppTextStyles.sectionTitle.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: AppSpacing.md,
            crossAxisSpacing: AppSpacing.md,
            childAspectRatio: 0.8,
          ),
          itemCount: club.members.length,
          itemBuilder: (context, index) {
            final member = club.members[index];
            return Column(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: AppColors.surface,
                  backgroundImage: member.profileImageUrl != null
                      ? NetworkImage(member.profileImageUrl!)
                      : null,
                  child: member.profileImageUrl == null
                      ? Icon(Icons.person, color: AppColors.textTertiary)
                      : null,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  member.nickname,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  /// 다음 예정 모임 섹션
  Widget _buildNextMeetingSection(ClubDetail club) {
    if (club.nextMeeting == null) return const SizedBox.shrink();

    final meeting = club.nextMeeting!;

    // 날짜 포맷 (로케일 에러 방지용 try-catch)
    String formattedDate;
    try {
      final dateFormat = DateFormat('M월 d일 (E)', 'ko_KR');
      final timeFormat = DateFormat('a h:mm', 'ko_KR');
      formattedDate =
          '${dateFormat.format(meeting.scheduledAt)} ${timeFormat.format(meeting.scheduledAt)} · ${meeting.location}';
      AppLogger.debug('[ClubDetailPage] 날짜 포맷 성공: $formattedDate');
    } catch (e) {
      AppLogger.error('[ClubDetailPage] 날짜 포맷 에러: $e');
      // fallback: 기본 포맷
      formattedDate =
          '${meeting.scheduledAt.month}월 ${meeting.scheduledAt.day}일 · ${meeting.location}';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '다음 예정된 모임',
          style: AppTextStyles.sectionTitle.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.calendar_today,
                  color: AppColors.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      meeting.title,
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      formattedDate,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// 모임 규칙 섹션
  Widget _buildRulesSection(ClubDetail club) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '모임 규칙',
          style: AppTextStyles.sectionTitle.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: club.rules.map((rule) {
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '•  ',
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        rule,
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.textSecondary,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  /// 하단 버튼
  Widget _buildBottomButton(BuildContext context, ClubDetail club) {
    return BottomButtonContainer(
      child: CustomButton(
        text: '채팅 시작하기',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ChatRoomPage(
                clubId: club.id,
                clubName: club.name,
              ),
            ),
          );
        },
      ),
    );
  }
}
