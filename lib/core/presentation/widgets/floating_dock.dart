import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../theme/app_theme.dart';

class FloatingDockWrapper extends StatelessWidget {
  final Widget child;
  final String currentRoute;

  const FloatingDockWrapper({
    super.key,
    required this.child,
    required this.currentRoute,
  });

  @override
  Widget build(BuildContext context) {
    if (![
      '/dashboard',
      '/lessons',
      '/settings',
      '/quiz',
    ].contains(currentRoute)) {
      return child;
    }

    return Scaffold(
      body: Stack(
        children: [
          child,
          Positioned(
            bottom: 24,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  // ignore: deprecated_member_use
                  color: AppColors.brandDark.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x33000000),
                      offset: Offset(0, 20),
                      blurRadius: 40,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _DockItem(
                      icon: LucideIcons.home,
                      route: '/dashboard',
                      currentRoute: currentRoute,
                    ),
                    const SizedBox(width: 8),
                    _DockItem(
                      icon: LucideIcons.bookMarked,
                      route: '/lessons',
                      currentRoute: currentRoute,
                    ),
                    const SizedBox(width: 8),
                    _DockItem(
                      icon: LucideIcons.hourglass,
                      route: '/quiz',
                      currentRoute: currentRoute,
                    ),
                    const SizedBox(width: 8),
                    _DockItem(
                      icon: LucideIcons.settings,
                      route: '/settings',
                      currentRoute: currentRoute,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DockItem extends StatelessWidget {
  final IconData icon;
  final String route;
  final String currentRoute;

  const _DockItem({
    required this.icon,
    required this.route,
    required this.currentRoute,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = currentRoute == route;

    return GestureDetector(
      onTap: () => context.go(route),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isActive ? AppColors.brandOrange : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
          icon,
          size: 24,
          // ignore: deprecated_member_use
          color: isActive ? AppColors.brandDark : Colors.white.withOpacity(0.6),
        ),
      ),
    );
  }
}
