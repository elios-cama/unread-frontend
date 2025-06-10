import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:design_ui/design_ui.dart';
import 'package:common/common.dart';
import '../../../../core/router/route_constants.dart';
import '../../../auth/presentation/provider/auth_provider.dart';

class LandingPage extends ConsumerStatefulWidget {
  const LandingPage({super.key});

  @override
  ConsumerState<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends ConsumerState<LandingPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _handleAuthRedirection();
    });
  }

  Future<void> _handleAuthRedirection() async {
    try {
      // Check if user is already authenticated
      final authNotifier = ref.read(authProvider.notifier);
      final storedUser = await authNotifier.checkAndUpdateStoredAuth();

      if (!mounted) return;

      if (storedUser != null) {
        // User is authenticated, go directly to home
        context.go(AppRoutes.home);
      } else {
        // User is not authenticated, go to auth page
        context.go(AppRoutes.auth);
      }
    } catch (e) {
      // If there's an error checking auth, go to auth page
      if (mounted) {
        context.go(AppRoutes.auth);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const BookIconWidget(
                  size: 120,
                ),
                const SizedBox(height: 24),
                const Text(
                  'Unread',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Loading your stories...',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 32),
                const UnreadLoading(
                  size: 32,
                  color: LoadingColor.white,
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Text(
                'v${AppConfig.currentFlavor == AppFlavor.staging ? "1.0.0-staging" : "1.0.0"}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.5),
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
