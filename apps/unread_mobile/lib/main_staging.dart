import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:common/common.dart';
import 'app.dart';

void main() {
  AppConfig.setFlavor(AppFlavor.staging);

  runApp(const ProviderScope(child: UnreadApp()));
}
