import 'package:flutter/material.dart';
import 'package:ongi_front/core/app_colors.dart';
import 'package:ongi_front/core/app_text_styles.dart';
import 'package:ongi_front/core/app_spacing.dart';
import 'package:ongi_front/views/widgets/common/custom_button.dart';
import 'package:ongi_front/models/ui/matching_result_model.dart';
import 'package:ongi_front/views/widgets/matching/similar_profile_card.dart';
import 'package:ongi_front/views/widgets/matching/category_stat_card.dart';
import 'package:ongi_front/views/pages/onboarding/club_recommendation_page.dart';

class MatchingResultPage extends StatelessWidget {
  const MatchingResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock Data
    final similarProfiles = [
      SimilarProfile(
        name: '김민수',
        mbti: 'ENFP',
        imageUrl: '', // Placeholder
        description: '새로운 사람 만나는 걸 좋아해요!',
      ),
      SimilarProfile(
        name: '이영희',
        mbti: 'ENTP',
        imageUrl: '',
        description: '토론과 아이디어 공유를 즐깁니다.',
      ),
      SimilarProfile(
        name: '박지성',
        mbti: 'ESFP',
        imageUrl: '',
        description: '분위기 메이커 역할을 자처해요.',
      ),
    ];

    final categoryStats = [
      CategoryStat(label: '운동', icon: '🏃', percentage: 32),
      CategoryStat(label: '예술', icon: '🎨', percentage: 28),
      CategoryStat(label: '음악', icon: '🎵', percentage: 25),
      CategoryStat(label: '독서', icon: '📚', percentage: 15),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('당신과 비슷한 사람들',
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,),),
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
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '"열정적인 탐험가" 유형의\n사람들은 이런 특징이 있어요',
                      style: AppTextStyles.pageTitle,
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    // Similar Profiles List
                    SizedBox(
                      height: 200,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: similarProfiles.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: AppSpacing.md),
                        itemBuilder: (context, index) {
                          return SimilarProfileCard(
                              profile: similarProfiles[index]);
                        },
                      ),
                    ),

                    const SizedBox(height: AppSpacing.xl),

                    const Text(
                      '이런 모임을 좋아해요',
                      style: AppTextStyles.sectionTitle,
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // Category Stats Grid
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: AppSpacing.md,
                        mainAxisSpacing: AppSpacing.md,
                        childAspectRatio: 1.4,
                      ),
                      itemCount: categoryStats.length,
                      itemBuilder: (context, index) {
                        return CategoryStatCard(stat: categoryStats[index]);
                      },
                    ),

                    const SizedBox(height: AppSpacing.xl),

                    // Illustration Placeholder
                    Center(
                      child: Container(
                        width: 200,
                        height: 150,
                        color: AppColors.gray100,
                        alignment: Alignment.center,
                        child: const Text('Illustration Here\n(Matching Theme)',
                            textAlign: TextAlign.center),
                      ),
                    ),
                  ],
                ),
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
                    text: '나에게 맞는 모임 찾기',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ClubRecommendationPage(),
                        ),
                      );
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
