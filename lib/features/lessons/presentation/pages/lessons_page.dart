import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../../../../../core/di/injection_container.dart' as di;
import '../../../../../core/theme/app_theme.dart';
import '../../domain/entities/lesson_entity.dart';
import '../state/lessons_provider.dart';

class LessonsPage extends StatelessWidget {
  const LessonsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LessonsProvider(getLessons: di.sl()),
      child: const _LessonsView(),
    );
  }
}

class _LessonsView extends StatelessWidget {
  const _LessonsView();

  @override
  Widget build(BuildContext context) {
    final lessonsProvider = context.watch<LessonsProvider>();
    final state = lessonsProvider.state;

    return Scaffold(
      backgroundColor: AppColors.bgGray,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 430),
          margin: const EdgeInsets.symmetric(horizontal: 0),
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          decoration: const BoxDecoration(
            color: Colors.white,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFF5F7FA), Color(0xFFE2EBF5)],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              const Text(
                'Pick a New\nLearning Lesson',
                style: TextStyle(
                  fontSize: 32,
                  height: 1.1,
                  fontWeight: FontWeight.w900,
                  color: AppColors.brandDark,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x08000000),
                      offset: Offset(0, 2),
                      blurRadius: 15,
                    ),
                  ],
                ),
                child: TextField(
                  onChanged: lessonsProvider.updateSearchQuery,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.brandDark,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Search...',
                    hintStyle: TextStyle(
                      color: AppColors.brandTextLight,
                      fontWeight: FontWeight.normal,
                    ),
                    prefixIcon: Icon(
                      LucideIcons.search,
                      color: AppColors.brandTextLight,
                      size: 20,
                    ),
                    suffixIcon: Icon(
                      LucideIcons.settings,
                      color: AppColors.brandTextLight,
                      size: 20,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 18,
                      horizontal: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: LessonsProvider.tabs.map((tab) {
                    final isActive = state.activeDifficulty == tab;
                    return GestureDetector(
                      onTap: () => lessonsProvider.updateDifficulty(tab),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: isActive ? AppColors.brandDark : Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: isActive
                                ? AppColors.brandDark
                                : Colors.grey.shade200,
                          ),
                        ),
                        child: Text(
                          tab,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: isActive
                                ? Colors.white
                                : AppColors.brandText,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 24),
              if (state.error != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    state.error!.message,
                    style: const TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              Expanded(
                child: state.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.separated(
                        padding: const EdgeInsets.only(bottom: 120),
                        itemCount: state.lessons.length,
                        separatorBuilder: (c, i) => const SizedBox(height: 20),
                        itemBuilder: (context, index) {
                          final lesson = state.lessons[index];
                          return _LessonCard(
                            lesson: lesson,
                            onStart: () => context.go('/flashcards'),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LessonCard extends StatelessWidget {
  final LessonEntity lesson;
  final VoidCallback onStart;

  const _LessonCard({required this.lesson, required this.onStart});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 170),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          Positioned(
            right: -20,
            bottom: -20,
            child: Opacity(
              opacity: 0.9,
              child: lesson.image != null
                  ? Image.network(
                      lesson.image!,
                      width: 180,
                      height: 180,
                      fit: BoxFit.cover,
                      colorBlendMode: BlendMode.multiply,
                    )
                  : const SizedBox(),
            ),
          ),
          Positioned(
            top: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.brandDark,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                '${lesson.progress}/${lesson.totalItems}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            lesson.lessonPrefix.split(' ').first,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: AppColors.brandDark,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 0,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.grey.shade200),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              lesson.lessonPrefix.split(' ').length > 1
                                  ? lesson.lessonPrefix.split(' ')[1]
                                  : '',
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                                color: AppColors.brandDark,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        lesson.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 20,
                          color: AppColors.brandDark,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        lesson.description,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          color: AppColors.brandTextLight,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: lesson.locked ? null : onStart,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: lesson.locked
                          ? const Color(0xFFFFE4D6)
                          : AppColors.brandOrange,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: lesson.locked
                          ? null
                          : const [
                              BoxShadow(
                                color: Color(0x33FFB27D),
                                offset: Offset(0, 4),
                                blurRadius: 10,
                              ),
                            ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (lesson.locked) ...[
                          const Icon(
                            LucideIcons.lock,
                            size: 16,
                            color: Color(0xFFD97706),
                          ),
                          const SizedBox(width: 6),
                        ],
                        Text(
                          lesson.locked ? 'Unlock' : 'Start',
                          style: TextStyle(
                            color: lesson.locked
                                ? const Color(0xFFD97706)
                                : AppColors.brandDark,
                            fontWeight: FontWeight.w900,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
