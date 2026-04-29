import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/theme/app_theme.dart';
import '../constants/dummy_data.dart';
// import '../../features/auth/presentation/state/auth_provider.dart'; // when wired up
// import 'package:provider/provider.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentIdx = 0;
  int _score = 0;
  String? _selectedOption;
  String _showResult = ''; // '', 'correct', 'incorrect'
  bool _isFinished = false;
  bool _isReviewing = false;

  void _handleAnswer(String option) {
    if (_showResult.isNotEmpty || _isFinished || _isReviewing) return;

    final question = DummyData.quizQuestions[_currentIdx];
    setState(() {
      _selectedOption = option;
      final isCorrect = option == question.correctAnswer;
      if (isCorrect) _score++;
      _showResult = isCorrect ? 'correct' : 'incorrect';
    });

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      setState(() {
        _showResult = '';
        _selectedOption = null;
        if (_currentIdx < DummyData.quizQuestions.length - 1) {
          _currentIdx++;
        } else {
          // Finalize and save score
          _isFinished = true;
          // final authProvider = Provider.of<AuthProvider>(context, listen: false);
          // final progressInc = ((_score / quizzes.length) * 10).round();
          // authProvider.updateUserProgress(progressInc); // pseudocode
        }
      });
    });
  }

  Widget _buildReviewMode() {
    return Scaffold(
      backgroundColor: AppColors.bgGray,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 430),
          margin: const EdgeInsets.symmetric(horizontal: 0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => setState(() => _isFinished = true),
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: Colors.grey.shade100),
                        ),
                        child: const Icon(
                          LucideIcons.chevronLeft,
                          color: AppColors.brandDark,
                        ),
                      ),
                    ),
                    const Text(
                      'Review Answers',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: AppColors.brandDark,
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(24),
                  itemCount: DummyData.quizQuestions.length,
                  itemBuilder: (context, idx) {
                    final q = DummyData.quizQuestions[idx];
                    return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: Colors.grey.shade100),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x05000000),
                                offset: Offset(0, 4),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${idx + 1}. ${q.question}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.brandDark,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0x334ADE80),
                                  border: const Border(
                                    left: BorderSide(
                                      color: Color(0xFF22C55E),
                                      width: 4,
                                    ),
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      '✓ ',
                                      style: TextStyle(
                                        color: Color(0xFF166534),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      q.correctAnswer,
                                      style: const TextStyle(
                                        color: Color(0xFF166534),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                        .animate()
                        .fade(
                          duration: 300.ms,
                          delay: Duration(milliseconds: 50 * idx),
                        )
                        .slideY(begin: 0.1, end: 0);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isReviewing) return _buildReviewMode();

    final questions = DummyData.quizQuestions;
    final question = questions[min(_currentIdx, questions.length - 1)];

    return Scaffold(
      backgroundColor: AppColors.bgGray,
      body: Stack(
        children: [
          SafeArea(
            child: Center(
              child: Container(
                width: double.infinity,
                constraints: const BoxConstraints(maxWidth: 430),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: Column(
                  children: [
                    // Header Bar
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => context.go('/dashboard'),
                          child: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(color: Colors.grey.shade100),
                            ),
                            child: const Icon(
                              LucideIcons.chevronLeft,
                              color: AppColors.brandDark,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Stack(
                              children: [
                                Container(
                                  height: 14,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFD1D5DB),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  height: 14,
                                  width:
                                      ((_currentIdx) / questions.length) *
                                      MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    color: AppColors.brandYellow,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Container(
                                    alignment: Alignment.centerRight,
                                    padding: const EdgeInsets.only(right: 2),
                                    child: Container(
                                      width: 8,
                                      height: 8,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: 52,
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: Colors.grey.shade100),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '$_score',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.brandOrange,
                                  fontSize: 16,
                                  height: 1.0,
                                ),
                              ),
                              const Text(
                                'PTS',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 8,
                                  color: AppColors.brandTextLight,
                                  letterSpacing: 1.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Question Card
                    AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                          constraints: const BoxConstraints(minHeight: 220),
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: _showResult == 'correct'
                                ? const Color(0xFF4ADE80)
                                : _showResult == 'incorrect'
                                ? const Color(0xFFF87171)
                                : AppColors.brandLightPurple,
                            borderRadius: BorderRadius.circular(32),
                            boxShadow: [
                              BoxShadow(
                                color: _showResult == 'correct'
                                    ? const Color(0x664ADE80)
                                    : _showResult == 'incorrect'
                                    ? const Color(0x66F87171)
                                    : const Color(0x338B5CF6),
                                offset: const Offset(0, 10),
                                blurRadius: 30,
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 6,
                                ),
                                // ignore: deprecated_member_use
                                decoration: BoxDecoration(
                                  // ignore: deprecated_member_use
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      LucideIcons.gamepad2,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Question ${_currentIdx + 1}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 24),
                              Text(
                                question.question,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                  height: 1.2,
                                ),
                              ),
                            ],
                          ),
                        )
                        .animate(target: _showResult == 'incorrect' ? 1 : 0)
                        .shakeX(hz: 8, amount: 5, duration: 400.ms)
                        .animate(target: _showResult == 'correct' ? 1 : 0)
                        .scale(
                          begin: const Offset(1, 1),
                          end: const Offset(1.05, 1.05),
                          duration: 200.ms,
                          curve: Curves.easeOutBack,
                        )
                        .then()
                        .scale(
                          begin: const Offset(1.05, 1.05),
                          end: const Offset(1, 1),
                          duration: 200.ms,
                        ),

                    const SizedBox(height: 32),

                    // Options
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.only(bottom: 120),
                        children: question.options.map((option) {
                          final isCorrectAns = option == question.correctAnswer;
                          final isSelectedAns = _selectedOption == option;

                          Color btnBg = Colors.white;
                          Color btnBorder = Colors.transparent;
                          Color btnText = AppColors.brandText;
                          Color shadowColor = const Color(0xFFCBD5E1);
                          double yOffset = 0;
                          double shadowOffset = 6;

                          if (_showResult.isNotEmpty) {
                            if (isCorrectAns) {
                              btnBg = const Color(0xFF4ADE80);
                              btnBorder = const Color(0xFF22C55E);
                              btnText = Colors.white;
                              shadowColor = const Color(0xFF22C55E);
                            } else if (isSelectedAns) {
                              btnBg = const Color(0xFFF87171);
                              btnBorder = const Color(0xFFDC2626);
                              btnText = Colors.white;
                              shadowColor = const Color(0xFFDC2626);
                            } else {
                              // ignore: deprecated_member_use
                              btnBg = Colors.white.withOpacity(0.5);
                              // ignore: deprecated_member_use
                              btnText = AppColors.brandText.withOpacity(0.5);
                              shadowColor = const Color(0xFFE2EBF5);
                              yOffset = 4;
                              shadowOffset = 2;
                            }
                          }

                          return GestureDetector(
                            onTap: () => _handleAnswer(option),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              margin: const EdgeInsets.only(bottom: 16),
                              transform: Matrix4.translationValues(
                                0,
                                yOffset,
                                0,
                              ),
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: btnBg,
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(color: btnBorder, width: 2),
                                boxShadow: [
                                  BoxShadow(
                                    color: shadowColor,
                                    offset: Offset(0, shadowOffset),
                                  ),
                                  if (_showResult.isNotEmpty &&
                                      (isCorrectAns || isSelectedAns))
                                    // ignore: deprecated_member_use
                                    BoxShadow(
                                      // ignore: deprecated_member_use
                                      color: shadowColor.withOpacity(0.3),
                                      offset: const Offset(0, 15),
                                      blurRadius: 20,
                                      spreadRadius: -10,
                                    ),
                                ],
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                option,
                                style: TextStyle(
                                  color: btnText,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Result Overlay Icon
          if (_showResult == 'correct')
            Center(
              child:
                  Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(32),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x994ADE80),
                              blurRadius: 50,
                              offset: Offset(0, 10),
                            ),
                          ],
                        ),
                        child: const Icon(
                          LucideIcons.check,
                          size: 80,
                          color: Color(0xFF4ADE80),
                        ),
                      )
                      .animate()
                      .scale(
                        begin: const Offset(0.3, 0.3),
                        end: const Offset(1, 1),
                        duration: 400.ms,
                        curve: Curves.elasticOut,
                      )
                      .rotate(begin: -0.1, end: 0),
            ),

          if (_showResult == 'incorrect')
            Center(
              child:
                  Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(32),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x99F87171),
                              blurRadius: 50,
                              offset: Offset(0, 10),
                            ),
                          ],
                        ),
                        child: const Icon(
                          LucideIcons.x,
                          size: 80,
                          color: Color(0xFFF87171),
                        ),
                      )
                      .animate()
                      .scale(
                        begin: const Offset(0.3, 0.3),
                        end: const Offset(1, 1),
                        duration: 400.ms,
                        curve: Curves.elasticOut,
                      )
                      .rotate(begin: 0.1, end: 0),
            ),

          // Finished Bottom Sheet
          if (_isFinished)
            Container(
              // ignore: deprecated_member_use
              color: AppColors.brandDark.withOpacity(0.4),
              alignment: Alignment.bottomCenter,
              child:
                  Container(
                    constraints: const BoxConstraints(maxWidth: 430),
                    padding: const EdgeInsets.all(32),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(32),
                        topRight: Radius.circular(32),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 48,
                          height: 6,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(3),
                          ),
                          margin: const EdgeInsets.only(bottom: 32),
                        ),
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: const BoxDecoration(
                            color: AppColors.brandYellow,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Color(0x66FBBF36),
                                blurRadius: 30,
                                offset: Offset(0, 10),
                              ),
                            ],
                          ),
                          child: const Icon(
                            LucideIcons.trophy,
                            size: 40,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Quiz Complete!',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w900,
                            color: AppColors.brandDark,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text.rich(
                          TextSpan(
                            children: [
                              const TextSpan(
                                text: 'You scored ',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: AppColors.brandText,
                                ),
                              ),
                              TextSpan(
                                text: '$_score',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 16,
                                  color: AppColors.brandOrange,
                                ),
                              ),
                              TextSpan(
                                text:
                                    ' out of ${questions.length}.\nAccuracy: ${((_score / questions.length) * 100).round()}%',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: AppColors.brandText,
                                ),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),

                        // Buttons
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _isFinished = false;
                              _currentIdx = 0;
                              _score = 0;
                            });
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            decoration: BoxDecoration(
                              color: AppColors.brandPurple,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x4D8B5CF6),
                                  offset: Offset(0, 8),
                                  blurRadius: 20,
                                ),
                              ],
                            ),
                            alignment: Alignment.center,
                            child: const Text(
                              'Play Again',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _isFinished = false;
                              _isReviewing = true;
                            });
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEAEFFA),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            alignment: Alignment.center,
                            child: const Text(
                              'Review Answers',
                              style: TextStyle(
                                color: AppColors.brandPurple,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        GestureDetector(
                          onTap: () => context.go('/dashboard'),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            alignment: Alignment.center,
                            child: const Text(
                              'Back to Dashboard',
                              style: TextStyle(
                                color: AppColors.brandDark,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ).animate().slideY(
                    begin: 1.0,
                    end: 0,
                    duration: 400.ms,
                    curve: Curves.easeOutCubic,
                  ),
            ),
        ],
      ),
    );
  }
}
