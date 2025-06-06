import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../src/auth/presentation/page/auth_page.dart';
import '../../src/onboarding/presentation/page/onboarding_page.dart';
import '../../src/auth/presentation/page/welcome_back_page.dart';
import '../../src/landing/presentation/page/landing_page.dart';
import '../../src/home/presentation/page/home_page.dart';
import '../../src/collections/presentation/page/collection_detail_page.dart';
import 'route_constants.dart';

part 'app_router.g.dart';

/// Wrapper widget that adds swipe-back gesture detection
class SwipeBackWrapper extends StatefulWidget {
  final Widget child;
  final VoidCallback? onSwipeBack;

  const SwipeBackWrapper({
    super.key,
    required this.child,
    this.onSwipeBack,
  });

  @override
  State<SwipeBackWrapper> createState() => _SwipeBackWrapperState();
}

class _SwipeBackWrapperState extends State<SwipeBackWrapper>
    with TickerProviderStateMixin {
  late AnimationController _dragController;
  late Animation<Offset> _dragAnimation;
  double _dragAmount = 0.0;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _dragController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _dragAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(1.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _dragController,
      curve: Curves.easeInOutCubic,
    ));
  }

  @override
  void dispose() {
    _dragController.dispose();
    super.dispose();
  }

  void _handlePanStart(DragStartDetails details) {
    // Only allow swipe from left edge
    if (details.globalPosition.dx < 20) {
      _isDragging = true;
      _dragController.stop();
    }
  }

  void _handlePanUpdate(DragUpdateDetails details) {
    if (!_isDragging) return;

    final screenWidth = MediaQuery.of(context).size.width;
    _dragAmount = (details.globalPosition.dx / screenWidth).clamp(0.0, 1.0);
    _dragController.value = _dragAmount;
  }

  void _handlePanEnd(DragEndDetails details) {
    if (!_isDragging) return;

    _isDragging = false;

    // If dragged more than 30% or velocity is high enough, complete the swipe
    if (_dragAmount > 0.3 || details.velocity.pixelsPerSecond.dx > 800) {
      _dragController.forward().then((_) {
        widget.onSwipeBack?.call();
      });
    } else {
      // Otherwise, snap back
      _dragController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: _handlePanStart,
      onPanUpdate: _handlePanUpdate,
      onPanEnd: _handlePanEnd,
      child: AnimatedBuilder(
        animation: _dragAnimation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(
                _dragAnimation.value.dx * MediaQuery.of(context).size.width, 0),
            child: widget.child,
          );
        },
      ),
    );
  }
}

/// Custom page transition that slides horizontally for smooth navigation
Page<T> _buildPageWithSlideTransition<T extends Object?>(
  BuildContext context,
  GoRouterState state,
  Widget child, {
  bool isReverse = false,
  bool enableSwipeBack = true,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: enableSwipeBack
        ? SwipeBackWrapper(
            onSwipeBack: () {
              if (context.canPop()) {
                context.pop();
              }
            },
            child: child,
          )
        : child,
    transitionDuration: const Duration(milliseconds: 400),
    reverseTransitionDuration: const Duration(milliseconds: 400),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // Use a curved animation for smoother transitions
      final curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: Curves.easeInOutCubic,
      );

      final curvedSecondaryAnimation = CurvedAnimation(
        parent: secondaryAnimation,
        curve: Curves.easeInOutCubic,
      );

      // Slide from right to left for forward navigation
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const exitEnd = Offset(-1.0, 0.0);

      return SlideTransition(
        position: Tween<Offset>(
          begin: begin,
          end: end,
        ).animate(curvedAnimation),
        child: SlideTransition(
          position: Tween<Offset>(
            begin: Offset.zero,
            end: exitEnd,
          ).animate(curvedSecondaryAnimation),
          child: child,
        ),
      );
    },
  );
}

@riverpod
GoRouter appRouter(Ref ref) {
  return GoRouter(
    initialLocation: AppRoutes.landing,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: AppRoutes.landing,
        name: AppRoutes.landingName,
        pageBuilder: (context, state) => _buildPageWithSlideTransition(
          context,
          state,
          const LandingPage(),
          enableSwipeBack: false,
        ),
      ),
      GoRoute(
        path: AppRoutes.auth,
        name: AppRoutes.authName,
        pageBuilder: (context, state) => _buildPageWithSlideTransition(
          context,
          state,
          const AuthPage(),
          enableSwipeBack: true,
        ),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        name: AppRoutes.onboardingName,
        pageBuilder: (context, state) {
          final user = state.extra as Map<String, dynamic>?;
          if (user == null) {
            return _buildPageWithSlideTransition(
              context,
              state,
              const AuthPage(),
              enableSwipeBack: true,
            );
          }
          return _buildPageWithSlideTransition(
            context,
            state,
            OnboardingPage(user: user),
            enableSwipeBack: true,
          );
        },
      ),
      GoRoute(
        path: AppRoutes.welcomeBack,
        name: AppRoutes.welcomeBackName,
        pageBuilder: (context, state) {
          final user = state.extra as Map<String, dynamic>?;
          if (user == null) {
            return _buildPageWithSlideTransition(
              context,
              state,
              const AuthPage(),
              enableSwipeBack: true,
            );
          }
          return _buildPageWithSlideTransition(
            context,
            state,
            WelcomeBackPage(user: user),
            enableSwipeBack: true,
          );
        },
      ),
      GoRoute(
        path: AppRoutes.home,
        name: AppRoutes.homeName,
        pageBuilder: (context, state) => _buildPageWithSlideTransition(
          context,
          state,
          const HomePage(),
          enableSwipeBack: false, // Home page doesn't need swipe back
        ),
      ),
      GoRoute(
        path: AppRoutes.collection,
        name: AppRoutes.collectionName,
        pageBuilder: (context, state) {
          final collectionId = state.pathParameters['collectionId'];
          if (collectionId == null) {
            return _buildPageWithSlideTransition(
              context,
              state,
              const Scaffold(
                body: Center(
                  child: Text('Collection ID is required'),
                ),
              ),
              enableSwipeBack: true,
            );
          }
          return _buildPageWithSlideTransition(
            context,
            state,
            CollectionDetailPage(collectionId: collectionId),
            enableSwipeBack: true, // Enable swipe back for collection details
          );
        },
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
