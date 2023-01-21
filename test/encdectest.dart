// This test tests the functionality to encrypt and decrypt passwords

// Import the test package and encrypt decrypt class
import 'package:flutter_test/flutter_test.dart';
import 'package:desktop_webapp/encryptdecrypt.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Test enc dec', () {
    Encryptdecrypt.test("Hello");
  });

  test('Test encrypt - decrypt', () async {
    String pwd = "MyPassword";

    String enc = await Encryptdecrypt.encrypt("Key", pwd);
    String res = await Encryptdecrypt.decrypt("Key", enc);

    expect(res, equals(pwd));
  });

  test('Test encrypt - decrypt with wrong key', () async {
    String pwd = "MyPassword";

    String enc = await Encryptdecrypt.encrypt("Key", pwd);
    String res = await Encryptdecrypt.decrypt("WrongKey", enc);

    expect(res, isNot(equals(pwd)));
  });
}
