import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:app_ui/resources/icons.dart';

void main() {
  test('icons assets test', () {
    expect(File(Icons.icGoogle).existsSync(), isTrue);
  });
}
