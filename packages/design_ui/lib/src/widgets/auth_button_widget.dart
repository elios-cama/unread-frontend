import 'package:app_ui/resources/resources.dart';
import 'package:flutter/material.dart';
import 'unread_asset_widget.dart';
import 'unread_icon_button_widget.dart';

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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: UnreadIconButton(
        text: _getButtonText(),
        icon: _buildIcon(),
        onPressed: onPressed,
        isLoading: isLoading,
        backgroundColor: const Color(0xFF2D2D2D),
        textColor: Colors.white,
      ),
    );
  }

  Widget _buildIcon() {
    switch (provider) {
      case AuthProvider.google:
        return const UnreadAsset(
          path: IconAssets.icGoogle,
          width: 24,
          height: 24,
        );
      case AuthProvider.apple:
        return const UnreadAsset(
          path: IconAssets.icApple,
          width: 24,
          height: 24,
          colorFilter: ColorFilter.mode(
            Colors.white,
            BlendMode.srcIn,
          ),
        );
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
