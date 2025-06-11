import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:common/common.dart';
import 'package:authentication/authentication.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize app with production flavor and authentication services
  await AppAuthInitializer.initialize(flavor: AppFlavor.production);

  runApp(const ProviderScope(child: UnreadApp()));
}
