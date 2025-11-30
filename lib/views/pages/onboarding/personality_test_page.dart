import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ongi_front/core/app_colors.dart';
import 'package:ongi_front/core/app_spacing.dart';
import 'package:ongi_front/viewmodels/personality_test_viewmodel.dart';
import 'package:ongi_front/views/pages/onboarding/test_result_page.dart';
import 'package:ongi_front/views/widgets/question/question_option_button.dart';

/// 성격 테스트 질문 화면
class PersonalityTestPage extends StatefulWidget {
  const PersonalityTestPage({super.key});

  @override
  State<PersonalityTestPage> createState() => _PersonalityTestPageState();
}

class _PersonalityTestPageState extends State<PersonalityTestPage> {
  @override
  void initState() {
    super.initState();
    // 화면 로드 시 초기화
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PersonalityTestViewModel>().initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PersonalityTestViewModel>(
      builder: (context, viewModel, child) {
        // 로딩 중
        if (viewModel.isLoading) {
          return const Scaffold(
            backgroundColor: AppColors.background,
            body: Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            ),
          );
        }

        // 에러 발생
        if (viewModel.error != null) {
          return Scaffold(
            backgroundColor: AppColors.background,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: AppColors.error,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    viewModel.error!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.error,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  ElevatedButton(
                    onPressed: () => viewModel.initialize(),
                    child: const Text('다시 시도'),
                  ),
                ],
              ),
            ),
          );
        }

        // 질문이 없음
        if (viewModel.questions.isEmpty) {
          return const Scaffold(
            backgroundColor: AppColors.background,
            body: Center(
              child: Text('질문을 불러오는 중...'),
            ),
          );
        }

        final question = viewModel.currentQuestion;
        if (question == null) {
          return const Scaffold(
            backgroundColor: AppColors.background,
            body: Center(
              child: Text('질문을 찾을 수 없습니다'),
            ),
          );
        }

        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 600),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 32,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 상단: 진행 상황 (N/10)
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '${viewModel.currentQuestionIndex + 1}/10',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF757575),
                            ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // 질문 번호 + 카테고리 뱃지
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Q${viewModel.currentQuestionIndex + 1}.',
                          style: Theme.of(context).textTheme.displayLarge,
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.secondary,
                            borderRadius: BorderRadius.circular(11),
                          ),
                          child: Text(
                            question.category ?? '활동 패턴',
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // 질문 텍스트
                    Text(
                      question.text,
                      style: Theme.of(context)
                          .textTheme
                          .headlineLarge
                          ?.copyWith(
                            fontWeight: FontWeight.w600, // Semibold override
                          ),
                    ),

                    const SizedBox(height: 48),

                    // 선택지 리스트
                    Expanded(
                      child: ListView.separated(
                        itemCount: question.options.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final option = question.options[index];
                          final isSelected =
                              viewModel.currentSelectedOption == option.id;

                          return QuestionOptionButton(
                            text: option.text,
                            isSelected: isSelected,
                            onTap: () => viewModel.selectAnswer(option.id),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 32),

                    // 하단 버튼
                    Row(
                      children: [
                        // 이전 버튼 (Q1에서는 표시 안 함)
                        if (!viewModel.isFirstQuestion)
                          Expanded(
                            child: SizedBox(
                              height: 56,
                              child: OutlinedButton(
                                onPressed: viewModel.previousQuestion,
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: const Color(0xFFE0E0E0),
                                  foregroundColor: AppColors.textDisabled,
                                  side: BorderSide.none,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text('이전'),
                              ),
                            ),
                          ),

                        if (!viewModel.isFirstQuestion)
                          const SizedBox(width: 12),

                        // 다음 버튼
                        Expanded(
                          flex: viewModel.isFirstQuestion ? 1 : 2,
                          child: SizedBox(
                            height: 56,
                            child: ElevatedButton(
                              onPressed:
                                  (viewModel.currentSelectedOption == null ||
                                          viewModel.currentSelectedOption == 0)
                                      ? null
                                      : () {
                                          if (viewModel.isLastQuestion) {
                                            _submitAndNavigateToResult(context);
                                          } else {
                                            viewModel.nextQuestion();
                                          }
                                        },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                disabledBackgroundColor:
                                    const Color(0xFFE0E0E0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                viewModel.isLastQuestion ? '결과 보러가기' : '다음',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _submitAndNavigateToResult(BuildContext context) async {
    final viewModel = context.read<PersonalityTestViewModel>();

    // 로딩 다이얼로그 표시
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(
          color: AppColors.primary,
        ),
      ),
    );

    try {
      await viewModel.submitAnswers();

      if (!context.mounted) return;

      // 로딩 다이얼로그 닫기
      Navigator.of(context).pop();

      // 결과 페이지로 이동
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const TestResultPage(),
        ),
      );
    } catch (e) {
      if (!context.mounted) return;

      // 로딩 다이얼로그 닫기
      Navigator.of(context).pop();

      // 에러 메시지 표시
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }
}
