import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:app_ui/resources/books_generated.dart';

void main() {
  test('books_generated assets test', () {
    expect(File(BooksGenerated.camusBook).existsSync(), isTrue);
    expect(File(BooksGenerated.debrayBook).existsSync(), isTrue);
    expect(File(BooksGenerated.rubinBook).existsSync(), isTrue);
    expect(File(BooksGenerated.siddharthaBook).existsSync(), isTrue);
    expect(File(BooksGenerated.tessonBook).existsSync(), isTrue);
  });
}
