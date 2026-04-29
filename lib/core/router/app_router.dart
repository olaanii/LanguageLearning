import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../screens/splash_screen.dart';
import '../../features/auth/presentation/pages/auth_page.dart';
import '../../features/dashboard/presentation/presentation.dart';
import '../../features/lessons/presentation/presentation.dart';
import '../../features/flashcards/presentation/presentation.dart';
import '../../features/quiz/presentation/presentation.dart';
import '../presentation/widgets/floating_dock.dart';
import '../theme/app_theme.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
    GoRoute(path: '/auth', builder: (context, state) => const AuthPage()),
    GoRoute(
      path: '/flashcards',
      builder: (context, state) => const FlashcardsPage(),
    ),
    GoRoute(path: '/quiz', builder: (context, state) => const QuizPage()),
    ShellRoute(
      builder: (context, state, child) {
        String activeTab = '/dashboard';
        if (state.uri.toString().startsWith('/dashboard')) {
          activeTab = '/dashboard';
        } else if (state.uri.toString().startsWith('/lessons')) {
          activeTab = '/lessons';
        } else if (state.uri.toString().startsWith('/leaderboard')) {
          activeTab = '/leaderboard';
        } else if (state.uri.toString().startsWith('/profile')) {
          activeTab = '/profile';
        }
        return FloatingDockWrapper(currentRoute: activeTab, child: child);
      },
      routes: [
        GoRoute(
          path: '/dashboard',
          builder: (context, state) => const DashboardPage(),
        ),
        GoRoute(
          path: '/lessons',
          builder: (context, state) => const LessonsPage(),
        ),
        GoRoute(
          path: '/leaderboard',
          builder: (context, state) => const _PlaceholderScreen(
            title: 'Leaderboard',
            icon: Icons.emoji_events,
          ),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) =>
              const _PlaceholderScreen(title: 'Profile', icon: Icons.person),
        ),
      ],
    ),
  ],
);

class _PlaceholderScreen extends StatelessWidget {
  final String title;
  final IconData icon;

  const _PlaceholderScreen({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgGray,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 64,
              color: AppColors.brandPurple.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              "$title Screen",
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.brandDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
