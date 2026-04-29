import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../features/auth/presentation/state/auth_provider.dart';
import '../core/theme/app_theme.dart';
import '../features/auth/domain/entities/user_entity.dart';

class MobileContainer extends StatelessWidget {
  final Widget child;
  const MobileContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 430),
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        color: Colors.white,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFF5F7FA), Color(0xFFE2EBF5)],
        ),
      ),
      child: child,
    );
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user =
        Provider.of<AuthProvider>(context).user ??
        const UserEntity(
          id: 'temp',
          email: '',
          name: 'Learner',
          avatar: 'https://api.dicebear.com/7.x/avataaars/svg?seed=Felix',
          progress: 0,
          level: 1,
          score: 0,
        );

    return Scaffold(
      backgroundColor: AppColors.bgGray,
      body: SafeArea(
        child: MobileContainer(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(
                    24.0,
                  ).copyWith(bottom: 120), // Padding for dock
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 3,
                                  ),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 4,
                                    ),
                                  ],
                                  image: DecorationImage(
                                    image: NetworkImage(user.avatar),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Hello, ${user.name}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: AppColors.brandDark,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      const Icon(
                                        LucideIcons.bookOpen,
                                        size: 12,
                                        color: AppColors.brandTextLight,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Progress ${user.progress}%',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.brandTextLight,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () => context.go('/notifications'),
                            child: Container(
                              width: 48,
                              height: 48,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0x08000000),
                                    offset: Offset(0, 2),
                                    blurRadius: 10,
                                  ),
                                ],
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  const Icon(
                                    LucideIcons.bell,
                                    size: 22,
                                    color: AppColors.brandDark,
                                  ),
                                  Positioned(
                                    top: 12,
                                    right: 12,
                                    child: Container(
                                      width: 12,
                                      height: 12,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFF4747),
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),

                      // Level Card (Purple)
                      Container(
                        width: double.infinity,
                        height: 160,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: AppColors.brandLightPurple,
                          borderRadius: BorderRadius.circular(32),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x338B5CF6),
                              offset: Offset(0, 10),
                              blurRadius: 0,
                            ),
                            BoxShadow(
                              color: Color(0x1A000000),
                              offset: Offset(0, 20),
                              blurRadius: 25,
                              spreadRadius: -5,
                            ),
                          ],
                        ),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Level ${user.level}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'This is you first step to greatness!',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 16),

                                // Progress Bar
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  height: 14,
                                  decoration: BoxDecoration(
                                    // ignore: deprecated_member_use
                                    color: Colors.white.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Stack(
                                    children: [
                                      Container(
                                        width:
                                            (user.progress / 100) *
                                            (MediaQuery.of(context).size.width *
                                                0.5),
                                        decoration: BoxDecoration(
                                          color: AppColors.brandYellow,
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Positioned(
                              right: -10,
                              top: 20,
                              child: Transform.rotate(
                                angle: 6 * 3.14159 / 180,
                                child: const Icon(
                                  LucideIcons.trophy,
                                  size: 80,
                                  color: AppColors.brandYellow,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Categories Row
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _CategoryIcon(
                              icon: LucideIcons.book,
                              label: 'Lessons',
                              bg: AppColors.brandPalePurple,
                              color: AppColors.brandPurple,
                              onTap: () => context.go('/lessons'),
                            ),
                            const SizedBox(width: 8),
                            _CategoryIcon(
                              icon: LucideIcons.gamepad2,
                              label: 'Games',
                              bg: const Color(0xFFE0E7FF),
                              color: const Color(0xFF4F46E5),
                              onTap: () => context.go('/quiz'),
                            ),
                            const SizedBox(width: 8),
                            _CategoryIcon(
                              icon: LucideIcons.bookOpen,
                              label: 'Stories',
                              bg: const Color(0xFFFCE7F3),
                              color: const Color(0xFFDB2777),
                              onTap: () {},
                            ),
                            const SizedBox(width: 8),
                            _CategoryIcon(
                              icon: LucideIcons.users,
                              label: 'Activities',
                              bg: const Color(0xFFEEE0FF),
                              color: const Color(0xFF7E22CE),
                              onTap: () {},
                            ),
                            const SizedBox(width: 8),
                            _CategoryIcon(
                              icon: LucideIcons.compass,
                              label: 'Discover',
                              bg: const Color(0xFFFFEDD5),
                              color: const Color(0xFFEA580C),
                              onTap: () {},
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Large Lesson Card
                      GestureDetector(
                        onTap: () => context.go('/lessons'),
                        child: Container(
                          height: 180,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F0FE),
                            borderRadius: BorderRadius.circular(32),
                          ),
                          child: Stack(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      // ignore: deprecated_member_use
                                      color: Colors.white.withOpacity(0.8),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          LucideIcons.bookMarked,
                                          size: 16,
                                          color: AppColors.brandPurple,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          'Lessons',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            color: AppColors.brandDark,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 32),
                                  const SizedBox(
                                    width: 140,
                                    child: Text(
                                      'Fun learning lessons that help kids grow smarter daily.',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.brandText,
                                        height: 1.3,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: const BoxDecoration(
                                    color: AppColors.brandDark,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    LucideIcons.arrowRight,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Large Games Card
                      GestureDetector(
                        onTap: () => context.go('/quiz'),
                        child: Container(
                          height: 150,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3E8FF),
                            borderRadius: BorderRadius.circular(32),
                          ),
                          child: Stack(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  // ignore: deprecated_member_use
                                  color: Colors.white.withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      LucideIcons.gamepad2,
                                      size: 16,
                                      color: Color(0xFF9333EA),
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Games',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: AppColors.brandDark,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: const BoxDecoration(
                                    color: AppColors.brandDark,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    LucideIcons.arrowRight,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Floating Dock Bottom Nav Spacer (will be added via wrapper)
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color bg;
  final Color color;
  final VoidCallback onTap;

  const _CategoryIcon({
    required this.icon,
    required this.label,
    required this.bg,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 32),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: AppColors.brandText,
            ),
          ),
        ],
      ),
    );
  }
}
