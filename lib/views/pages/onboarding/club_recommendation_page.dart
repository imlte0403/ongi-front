import 'package:flutter/material.dart';
import 'package:ongi_front/core/app_colors.dart';

import 'package:ongi_front/core/app_spacing.dart';
import 'package:ongi_front/views/widgets/common/custom_button.dart';
import 'package:ongi_front/models/ui/matching_result_model.dart';
import 'package:ongi_front/views/widgets/matching/recommended_club_card.dart';

class ClubRecommendationPage extends StatelessWidget {
  const ClubRecommendationPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock Data
    final recommendedClubs = [
      RecommendedClub(
        name: '주말 러닝 크루',
        emoji: '🏃',
        matchRate: 92,
        memberCount: 15,
        rating: 4.8,
        description: '매주 토요일 아침, 한강에서 가볍게 러닝하며 건강한 주말을 시작해요. 초보자 환영!',
        tags: ['한강 뚝섬', '주 1회', '12 - 18명'],
      ),
      RecommendedClub(
        name: '평일 드로잉 클럽',
        emoji: '🎨',
        matchRate: 88,
        memberCount: 8,
        rating: 4.9,
        description: '퇴근 후 가볍게 그림 그리며 힐링하는 시간. 재료는 모두 준비되어 있어요.',
        tags: ['강남역', '주 2회', '4 - 8명'],
      ),
      RecommendedClub(
        name: '북클럽: 인사이트',
        emoji: '📚',
        matchRate: 81,
        memberCount: 20,
        rating: 4.7,
        description: '한 달에 한 권, 깊이 있는 대화를 나눕니다. 다양한 분야의 책을 읽어요.',
        tags: ['온라인', '월 1회', '10 - 20명'],
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '당신을 위한 모임 TOP 3',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(AppSpacing.lg),
                itemCount: recommendedClubs.length,
                itemBuilder: (context, index) {
                  return RecommendedClubCard(club: recommendedClubs[index]);
                },
              ),
            ),

            // Bottom Area
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  CustomButton(
                    text: '프로필 만들고 모임 참여하기',
                    onPressed: () {
                      // 카카오 로그인 페이지로 이동
                      Navigator.of(context).pushNamed('/login');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
