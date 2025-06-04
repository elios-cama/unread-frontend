import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:app_ui/resources/lottie_assets.dart';

void main() {
  test('lottie_assets assets test', () {
    expect(File(LottieAssets.loadingBlack).existsSync(), isTrue);
    expect(File(LottieAssets.loadingWhite).existsSync(), isTrue);
  });
}
