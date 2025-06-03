import 'package:app_ui/resources/resources.dart';
import 'package:flutter/material.dart';
import 'unread_asset_widget.dart';

enum AuthProvider { google, apple }

class AuthButtonWidget extends StatelessWidget {
  const AuthButtonWidget({
    super.key,
    required this.provider,
    required this.onPressed,
    this.isLoading = false,
  });

  final AuthProvider provider;
  final VoidCallback onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 56,
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: ElevatedButton.icon(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2D2D2D),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        icon: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : _buildIcon(),
        label: Text(
          _getButtonText(),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    switch (provider) {
      case AuthProvider.google:
        return const UnreadAsset(
          path: IconsSvg.icGoogle,
          width: 24,
          height: 24,
        );
      case AuthProvider.apple:
        return const Icon(Icons.apple, size: 24, color: Colors.white);
    }
  }

  String _getButtonText() {
    switch (provider) {
      case AuthProvider.google:
        return 'Continue with Google';
      case AuthProvider.apple:
        return 'Continue with Apple';
    }
  }
}
