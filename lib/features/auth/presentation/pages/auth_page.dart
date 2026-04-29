import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/presentation/widgets/core_widgets.dart';
import '../state/auth_provider.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleAuth() async {
    FocusScope.of(context).unfocus();
    final authProvider = context.read<AuthProvider>();
    authProvider.clearError();
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (isLogin) {
      await authProvider.signIn(email, password);
    } else {
      await authProvider.signUp(email, password);
    }

    if (mounted) {
      final state = authProvider.state;
      if (state.isSuccess) {
        context.go('/dashboard');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthProvider>().state;

    return Scaffold(
      backgroundColor: AppColors.bgGray,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height - 80,
            ),
            child: Column(
              children: [
                const SizedBox(height: 24),
                // Logo
                Transform.rotate(
                  angle: 3 * 3.14159 / 180, // rotate-3
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.brandYellow,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 15,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        LucideIcons.user,
                        size: 40,
                        color: AppColors.brandDark,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  isLogin ? 'Welcome Back!' : 'Create Account',
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    color: AppColors.brandDark,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  isLogin
                      ? 'Sign in to continue your adventure.'
                      : 'Create an account to start your journey.',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.brandTextLight,
                  ),
                ),
                const SizedBox(height: 40),

                if (authState.error != null)
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.red.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      authState.error!.message.replaceFirst(
                        RegExp(r'\[.*\]\s*'),
                        '',
                      ), // Clean firebase errors if they leak
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.red.shade700,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),

                // Email Input
                DribbbleCard(
                  padding: EdgeInsets.zero,
                  child: TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.brandDark,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Email Address',
                      hintStyle: TextStyle(color: AppColors.brandTextLight),
                      prefixIcon: Icon(
                        LucideIcons.mail,
                        color: AppColors.brandTextLight,
                        size: 20,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Password Input
                DribbbleCard(
                  padding: EdgeInsets.zero,
                  child: TextField(
                    controller: _passwordController,
                    obscureText: true,
                    onSubmitted: (_) =>
                        authState.isLoading ? null : _handleAuth(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.brandDark,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Password',
                      hintStyle: TextStyle(color: AppColors.brandTextLight),
                      prefixIcon: Icon(
                        LucideIcons.lock,
                        color: AppColors.brandTextLight,
                        size: 20,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Sign In/Up Button
                GestureDetector(
                  onTap: authState.isLoading ? null : _handleAuth,
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
                    child: authState.isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 3,
                            ),
                          )
                        : Text(
                            isLogin ? 'Sign In' : 'Sign Up',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 40),

                Row(
                  children: [
                    Expanded(
                      child: Container(height: 1, color: Colors.grey.shade200),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        isLogin ? 'OR SIGN IN WITH' : 'OR SIGN UP WITH',
                        style: TextStyle(
                          color: AppColors.brandTextLight,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(height: 1, color: Colors.grey.shade200),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Google Button
                GestureDetector(
                  onTap: () {
                    // Not fully wired here for brevity
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey.shade100),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x0D000000),
                          offset: Offset(0, 4),
                          blurRadius: 15,
                        ),
                      ],
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          LucideIcons.chrome,
                          color: Colors.blue,
                        ), // Mapped Chrome -> Google
                        SizedBox(width: 12),
                        Text(
                          'Google',
                          style: TextStyle(
                            color: AppColors.brandDark,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      isLogin
                          ? "Don't have an account? "
                          : "Already have an account? ",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: AppColors.brandText,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        context.read<AuthProvider>().clearError();
                        _passwordController.clear();
                        setState(() => isLogin = !isLogin);
                      },
                      child: Text(
                        isLogin ? "Sign Up" : "Sign In",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: AppColors.brandPurple,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
