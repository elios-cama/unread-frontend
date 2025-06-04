import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:design_ui/design_ui.dart';
import '../../../../core/router/route_constants.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          'Unread',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => _showSignOutDialog(context),
            icon: const Icon(Icons.logout, color: Colors.white),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(flex: 2),
              const BookIconWidget(
                size: 120,
                useBlueBook: true,
              ),
              const SizedBox(height: 32),
              const Text(
                'Welcome to Unread!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Your ebook sanctuary is ready.\nStart sharing and discovering amazing stories.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 16,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 48),
              UnreadButton(
                text: 'Upload a Book',
                onPressed: () => _uploadBook(),
                backgroundColor: Colors.transparent,
                textColor: Colors.white,
                borderColor: Colors.white,
                borderWidth: 1,
              ),
              const Spacer(flex: 3),
            ],
          ),
        ),
      ),
    );
  }

  void _exploreBooks() {
    // TODO: Navigate to book discovery
  }

  void _uploadBook() {
    // TODO: Navigate to book upload
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => UnreadDialog(
        title: 'Sign Out',
        content: 'Are you sure you want to sign out?',
        actions: [
          UnreadDialogAction(
            text: 'Cancel',
            onPressed: () => Navigator.of(context).pop(),
          ),
          UnreadDialogAction(
            text: 'Sign Out',
            onPressed: () {
              Navigator.of(context).pop();
              context.go(AppRoutes.landing);
            },
            isDestructive: true,
            fontWeight: FontWeight.w600,
          ),
        ],
      ),
    );
  }
}
