import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:design_ui/design_ui.dart';
import 'package:common/common.dart';
import '../../../../core/router/route_constants.dart';

class AuthPage extends ConsumerWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                    onPressed: () => _handleAppleAuth(context, ref),
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

  void _handleAppleAuth(BuildContext context, WidgetRef ref) {
    // TODO: Implement Apple authentication
    debugPrint('Apple authentication triggered');
    _simulateReturningUser(context);
  }

  void _simulateReturningUser(BuildContext context) {
    final mockUser = UserProfile(
      id: '123e4567-e89b-12d3-a456-426614174000',
      username: 'elliotalderson',
      avatarUrl: 'https://example.com/avatar.jpg',
      isActive: true,
      createdAt: '2024-01-01T12:00:00Z',
      updatedAt: DateTime.now().toIso8601String(),
      lastLogin: DateTime.now().toIso8601String(),
      hasGoogle: true,
      hasApple: false,
    );

    context.go(AppRoutes.welcomeBack, extra: mockUser.toJson());
  }
}
