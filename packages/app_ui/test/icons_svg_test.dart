import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:app_ui/resources/icons_svg.dart';

void main() {
  test('icons_svg assets test', () {
    expect(File(IconsSvg.icGoogle).existsSync(), isTrue);
  });
}
