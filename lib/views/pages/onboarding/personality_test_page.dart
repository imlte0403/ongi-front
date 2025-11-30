import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_spacing.dart';
import '../../../core/app_text_styles.dart';
import '../../../viewmodels/personality_test_viewmodel.dart';
import '../../widgets/common/progress_bar.dart';
import '../../widgets/question/question_option_button.dart';

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
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('성격 테스트'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Consumer<PersonalityTestViewModel>(
        builder: (context, viewModel, child) {
          // 로딩 중
          if (viewModel.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            );
          }
          
          // 에러 발생
          if (viewModel.error != null) {
            return Center(
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
                    style: AppTextStyles.body.copyWith(
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
            );
          }
          
          // 질문이 없음
          if (viewModel.questions.isEmpty) {
            return const Center(
              child: Text('질문을 불러오는 중...'),
            );
          }
          
          final question = viewModel.currentQuestion;
          if (question == null) {
            return const Center(
              child: Text('질문을 찾을 수 없습니다'),
            );
          }
          
          return Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 600),
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 진행 바
                  ProgressBar(
                    current: viewModel.currentQuestionIndex + 1,
                    total: viewModel.questions.length,
                  ),
                  
                  const SizedBox(height: AppSpacing.xl),
                  
                  // 질문 번호 뱃지
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '질문 ${viewModel.currentQuestionIndex + 1}',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.background,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: AppSpacing.md),
                  
                  // 질문 텍스트
                  Text(
                    question.text,
                    style: AppTextStyles.bodyLarge,
                  ),
                  
                  const SizedBox(height: AppSpacing.lg),
                  
                  // 선택지 리스트 (4개)
                  Expanded(
                    child: ListView.separated(
                      itemCount: question.options.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: AppSpacing.md),
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
                  
                  const SizedBox(height: AppSpacing.lg),
                  
                  // 이전/다음 버튼
                  Row(
                    children: [
                      // 이전 버튼
                      if (!viewModel.isFirstQuestion)
                        Expanded(
                          child: OutlinedButton(
                            onPressed: viewModel.previousQuestion,
                            child: const Text('이전'),
                          ),
                        ),
                      
                      if (!viewModel.isFirstQuestion)
                        const SizedBox(width: AppSpacing.md),
                      
                      // 다음/결과보기 버튼
                      Expanded(
                        flex: viewModel.isFirstQuestion ? 1 : 1,
                        child: ElevatedButton(
                          onPressed: (viewModel.currentSelectedOption == null ||
                                  viewModel.currentSelectedOption == 0)
                              ? null
                              : () {
                                  if (viewModel.isLastQuestion) {
                                    // 마지막 질문이면 결과 화면으로
                                    _submitAndNavigateToResult(context);
                                  } else {
                                    // 다음 질문으로
                                    viewModel.nextQuestion();
                                  }
                                },
                          child: Text(
                            viewModel.isLastQuestion ? '결과보기' : '다음',
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
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
      
      // TODO: 결과 화면으로 이동
      // Navigator.of(context).pushReplacement(
      //   MaterialPageRoute(
      //     builder: (_) => const TestResultPage(),
      //   ),
      // );
      
      // 임시: 성공 메시지
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('결과: ${viewModel.result?.profileType ?? "분석 중"}'),
          backgroundColor: AppColors.success,
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
