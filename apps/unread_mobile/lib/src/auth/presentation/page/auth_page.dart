import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:design_ui/design_ui.dart';
import '../../../../core/router/route_constants.dart';
import '../provider/auth_provider.dart';
import '../../domain/model/auth_state_model.dart';

class AuthPage extends ConsumerWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    // If already authenticated, navigate to home immediately
    if (authState.status == AuthStatus.authenticated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go(AppRoutes.home);
      });
    }

    // Listen to auth state changes and navigate accordingly
    ref.listen<AuthStateModel>(authProvider, (previous, next) {
      switch (next.status) {
        case AuthStatus.newUser:
          if (next.user != null) {
            context.go(AppRoutes.onboarding, extra: next.user!.toJson());
          }
          break;
        case AuthStatus.returningUser:
          if (next.user != null) {
            context.go(AppRoutes.welcomeBack, extra: next.user!.toJson());
          }
          break;
        case AuthStatus.authenticated:
          context.go(AppRoutes.home);
          break;
        case AuthStatus.error:
          _showErrorDialog(
              context, next.errorMessage ?? 'Authentication failed');
          break;
        default:
          break;
      }
    });

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(flex: 2),
                    const BookIconWidget(
                      size: 140,
                    ),
                    const SizedBox(height: 48),
                    const Text(
                      'Your sanctuary for\noriginal stories',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Share your stories, discover new worlds,\nconnect with fellow creators',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 16,
                        height: 1.4,
                      ),
                    ),
                    const Spacer(flex: 3),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                children: [
                  AuthButtonWidget(
                    provider: AuthProvider.apple,
                    isLoading: authState.status == AuthStatus.loading,
                    onPressed: authState.status == AuthStatus.loading
                        ? () {}
                        : () => _handleAppleAuth(ref),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text:
                            'By continuing you confirm that you\'ve read\nand accepted our ',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.6),
                          fontSize: 12,
                        ),
                        children: [
                          TextSpan(
                            text: 'Terms',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.8),
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          const TextSpan(text: ' and '),
                          TextSpan(
                            text: 'Privacy Policy',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.8),
                              decoration: TextDecoration.underline,
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
      ),
    );
  }

  void _handleAppleAuth(WidgetRef ref) {
    ref.read(authProvider.notifier).signInWithApple();
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => UnreadDialog(
        title: 'Authentication Error',
        content: message,
        actions: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
