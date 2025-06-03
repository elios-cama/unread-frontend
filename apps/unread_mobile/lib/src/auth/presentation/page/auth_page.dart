import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:design_ui/design_ui.dart';

class AuthPage extends ConsumerWidget {
  const AuthPage({super.key, this.onAuthSuccess});

  final Function({required bool isNewUser})? onAuthSuccess;

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
                      primaryColor: Color(0xFF6366F1),
                      secondaryColor: Color(0xFF8B5CF6),
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
                    onPressed: () => _handleAppleAuth(ref),
                  ),
                  AuthButtonWidget(
                    provider: AuthProvider.google,
                    onPressed: () => _handleGoogleAuth(ref),
                  ),
                  const SizedBox(height: 16),
                  // Development buttons for testing
                  if (onAuthSuccess != null) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => onAuthSuccess!(isNewUser: true),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white,
                                side: const BorderSide(color: Colors.white),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text('Mock New User'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => onAuthSuccess!(isNewUser: false),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white,
                                side: const BorderSide(color: Colors.white),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text('Mock Returning'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
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
    // TODO: Implement Apple authentication
    debugPrint('Apple authentication triggered');
    onAuthSuccess?.call(isNewUser: false);
  }

  void _handleGoogleAuth(WidgetRef ref) {
    // TODO: Implement Google authentication
    debugPrint('Google authentication triggered');
    onAuthSuccess?.call(isNewUser: true);
  }
}
