import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:app_ui/resources/books.dart';

void main() {
  test('books assets test', () {
    expect(File(Books.bookBlack).existsSync(), isTrue);
    expect(File(Books.bookBlue).existsSync(), isTrue);
    expect(File(Books.bookGreen).existsSync(), isTrue);
    expect(File(Books.bookGrey).existsSync(), isTrue);
    expect(File(Books.bookNavy).existsSync(), isTrue);
    expect(File(Books.bookRed).existsSync(), isTrue);
    expect(File(Books.bookWhite).existsSync(), isTrue);
  });
}
