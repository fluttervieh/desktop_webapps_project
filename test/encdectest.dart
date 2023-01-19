// Import the test package and Counter class
import 'package:flutter_test/flutter_test.dart';

import 'package:desktop_webapp/encryptdecrypt.dart';

void main() {
  test('Test enc dec', () {
    Encryptdecrypt.test("Hello");
  });

  test('Test encrypt', () {
    Encryptdecrypt.encrypt("Key", "Password");
  });

/*
  test('Test decrypt', () {
    Encryptdecrypt.decrypt("Key", "Password");
  });
*/
}
