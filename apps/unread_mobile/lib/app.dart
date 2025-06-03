import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_ui/app_ui.dart';
import 'package:common/common.dart';
import 'src/auth/presentation/page/auth_page.dart';
import 'src/auth/presentation/page/welcome_back_page.dart';
import 'src/onboarding/presentation/page/onboarding_page.dart';

class UnreadApp extends ConsumerWidget {
  const UnreadApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppConfig.appName,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const AuthFlowPage(),
    );
  }
}

class AuthFlowPage extends ConsumerStatefulWidget {
  const AuthFlowPage({super.key});

  @override
  ConsumerState<AuthFlowPage> createState() => _AuthFlowPageState();
}

class _AuthFlowPageState extends ConsumerState<AuthFlowPage> {
  UserProfile? _mockUser;
  bool _isNewUser = false;

  @override
  Widget build(BuildContext context) {
    // Mock auth flow for development
    if (_mockUser == null) {
      return AuthPage(onAuthSuccess: _simulateAuth);
    }

    if (_isNewUser) {
      return OnboardingPage(user: _mockUser!);
    }

    return WelcomeBackPage(user: _mockUser!);
  }

  void _simulateAuth({required bool isNewUser}) {
    setState(() {
      _mockUser = UserProfile(
        id: '123e4567-e89b-12d3-a456-426614174000',
        username: isNewUser ? 'newuser123' : 'elliotalderson',
        avatarUrl: isNewUser ? null : 'https://example.com/avatar.jpg',
        isActive: true,
        createdAt: isNewUser
            ? DateTime.now().toIso8601String()
            : '2024-01-01T12:00:00Z',
        updatedAt: DateTime.now().toIso8601String(),
        lastLogin: DateTime.now().toIso8601String(),
        hasGoogle: true,
        hasApple: false,
      );
      _isNewUser = isNewUser;
    });
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppConfig.appName), centerTitle: true),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.book, size: 100, color: Colors.deepPurple),
            const SizedBox(height: 20),
            Text(
              'Welcome to ${AppConfig.appName}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Your ebook sharing platform',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            Text(
              'Environment: ${AppConfig.currentFlavor.name}',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 5),
            Text(
              'API: ${AppConfig.apiBaseUrl}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
