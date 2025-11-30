import 'package:flutter/material.dart';
import 'package:ongi_front/core/app_colors.dart';
import 'package:ongi_front/views/widgets/result/result_club_card.dart';
import 'package:ongi_front/views/widgets/result/result_description_card.dart';
import 'package:ongi_front/views/widgets/result/result_similar_club_card.dart';
import 'package:ongi_front/views/widgets/result/result_stat_row.dart';
import 'package:ongi_front/views/widgets/result/result_tag_chip.dart';

/// 성격 테스트 결과 화면
class TestResultPage extends StatelessWidget {
  const TestResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. 키워드 태그 데이터
    final List<String> tags = ['유연한 대처', '다양한 활동', '균형 잡힌 시각', '평화적'];

    // 2. 상세 설명 데이터
    final List<String> descriptions = [
      '당신은 상황에 따라 유연하게 대처하며, 내향과 외향의 균형을 잘 맞춥니다.',
      '다양한 활동을 즐기고, 사람들과의 조화를 중요하게 생각합니다.',
      '그룹의 분위기를 파악하는 데 어려움이 없고, 사람들과 원활하게 지냅니다.',
    ];

    // 3. 통계 데이터
    final List<Map<String, dynamic>> stats = [
      {'label': '사교성', 'value': 0.89},
      {'label': '활동성', 'value': 0.45},
      {'label': '친밀도', 'value': 0.58},
      {'label': '몰입도', 'value': 0.80},
    ];

    // 4. 추천 클럽 데이터
    final List<Map<String, dynamic>> recommendedClubs = [
      {
        'icon': Icons.self_improvement,
        'title': '요가/명상',
        'description': '몸과 마음의 균형 찾기'
      },
      {
        'icon': Icons.directions_run,
        'title': '런닝',
        'description': '런닝 후 찾아오는 상쾌함'
      },
      {
        'icon': Icons.extension,
        'title': '보드게임',
        'description': '마음맞는 사람들과 게임'
      },
      {
        'icon': Icons.menu_book,
        'title': '북토크',
        'description': '차분한 분위기에 빠져보기'
      },
    ];

    // 5. 비슷한 클럽 데이터
    final List<Map<String, dynamic>> similarClubs = [
      {
        'icon': Icons.directions_run,
        'title': '주말 러닝 크루',
        'info': '매주 토요일 오전 · 15명 활동중',
        'matchRate': 92,
        'color': const Color(0xFFF0F9F4),
      },
      {
        'icon': Icons.menu_book,
        'title': '북토크',
        'info': '매주 토요일 오전 · 15명 활동중',
        'matchRate': 88,
        'color': const Color(0xFFFFFBE6),
      },
      {
        'icon': Icons.self_improvement,
        'title': '나마스떼 요가',
        'info': '매주 토요일 오전 · 15명 활동중',
        'matchRate': 81,
        'color': const Color(0xFFFFF0F0),
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          '결과',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 1. 결과 헤더
              Text(
                '당신의 유형은:',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 8),
              Text(
                '균형형 조화자',
                style: Theme.of(context).textTheme.displayLarge,
              ),

              const SizedBox(height: 32),

              // 2. 캐릭터 이미지 (Placeholder)
              Container(
                height: 200,
                width: 200,
                decoration: const BoxDecoration(
                  color: AppColors.secondary,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.person,
                    size: 100,
                    color: AppColors.primary,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // 3. 키워드 태그
              Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: tags.map((tag) => ResultTagChip(text: tag)).toList(),
              ),

              const SizedBox(height: 32),

              // 4. 상세 설명 카드
              ResultDescriptionCard(descriptions: descriptions),

              const SizedBox(height: 48),

              // 5. 결과 요약 (그래프)
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '결과 요약',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              const SizedBox(height: 24),
              ...stats.map((stat) => Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: ResultStatRow(
                      label: stat['label'],
                      value: stat['value'],
                    ),
                  )),

              const SizedBox(height: 48),

              // 6. 추천 클럽 유형
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '당신에게 추천하는 클럽 유형',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              const SizedBox(height: 24),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.3,
                ),
                itemCount: recommendedClubs.length,
                itemBuilder: (context, index) {
                  final club = recommendedClubs[index];
                  return ResultClubCard(
                    icon: club['icon'],
                    title: club['title'],
                    description: club['description'],
                  );
                },
              ),

              const SizedBox(height: 48),

              // 7. 비슷한 사람들이 많은 클럽 TOP 3
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '비슷한 사람들이 많은 클럽 TOP 3',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              const SizedBox(height: 24),
              ...similarClubs.map((club) => Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: ResultSimilarClubCard(
                      icon: club['icon'],
                      title: club['title'],
                      info: club['info'],
                      matchRate: club['matchRate'],
                      backgroundColor: club['color'],
                    ),
                  )),

              const SizedBox(height: 48),

              // 8. 하단 CTA
              Text(
                '나랑 비슷한 유형의 사람들은 어디있을까?',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: 모임 찾기 페이지로 이동
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.search, color: Colors.white),
                      const SizedBox(width: 8),
                      Text(
                        '모임 찾아보기',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
