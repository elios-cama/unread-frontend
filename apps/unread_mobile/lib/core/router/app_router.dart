import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../src/auth/presentation/page/auth_page.dart';
import '../../src/onboarding/presentation/page/onboarding_page.dart';
import '../../src/auth/presentation/page/welcome_back_page.dart';
import '../../src/landing/presentation/page/landing_page.dart';
import '../../src/home/presentation/page/home_page.dart';
import 'route_constants.dart';

part 'app_router.g.dart';

@riverpod
GoRouter appRouter(AppRouterRef ref) {
  return GoRouter(
    initialLocation: AppRoutes.landing,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: AppRoutes.landing,
        name: AppRoutes.landingName,
        builder: (context, state) => const LandingPage(),
      ),
      GoRoute(
        path: AppRoutes.auth,
        name: AppRoutes.authName,
        builder: (context, state) => const AuthPage(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        name: AppRoutes.onboardingName,
        builder: (context, state) {
          final user = state.extra as Map<String, dynamic>?;
          if (user == null) {
            return const AuthPage();
          }
          return OnboardingPage(user: user);
        },
      ),
      GoRoute(
        path: AppRoutes.welcomeBack,
        name: AppRoutes.welcomeBackName,
        builder: (context, state) {
          final user = state.extra as Map<String, dynamic>?;
          if (user == null) {
            return const AuthPage();
          }
          return WelcomeBackPage(user: user);
        },
      ),
      GoRoute(
        path: AppRoutes.home,
        name: AppRoutes.homeName,
        builder: (context, state) => const HomePage(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Page not found: ${state.uri}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.landing),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
}
