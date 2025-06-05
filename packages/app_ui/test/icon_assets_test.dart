import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:app_ui/resources/icon_assets.dart';

void main() {
  test('icon_assets assets test', () {
    expect(File(IconAssets.icApple).existsSync(), isTrue);
    expect(File(IconAssets.icGoogle).existsSync(), isTrue);
  });
}
