import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:rncryptor/rncryptor.dart';

import 'dart:io';

class Encryptdecrypt {
  static Future<String> encrypt(String key, String password) async {
    // mac platform
    if (Platform.isMacOS) {
      const platform = MethodChannel('pwmanager/encdecrypt');
      try {
        String ret = await platform.invokeMethod('encrypt', [key, password]);
        debugPrint(ret);
        if (ret == "0") {
          debugPrint("Encryption Failed!");
          return encryptLocal(key, password);
        } else {
          debugPrint("ENCRYPT SUCCESS");
          return ret;
        }
      } on PlatformException catch (e) {
        debugPrint("Failed: '${e.message}'.");
        return encryptLocal(key, password);
      }
    } else {
      return encryptLocal(key, password);
    }
  }

  static Future<String> decrypt(String key, String encryptedPassword) async {
    // mac platform
    if (Platform.isMacOS) {
      const platform = MethodChannel('pwmanager/encdecrypt');
      try {
        String ret = await platform.invokeMethod('decrypt', [key, encryptedPassword]);
        debugPrint(ret);
        if (ret == "0") {
          debugPrint("Decrypting Failed.");
          return decryptLocal(key, encryptedPassword);
        } else {
          debugPrint("DECRYPT SUCCESS");
          return ret;
        }
      } on PlatformException catch (e) {
        debugPrint("Failed: '${e.message}'.");
        return decryptLocal(key, encryptedPassword);
      }
    } else {
      return decryptLocal(key, encryptedPassword);
    }
  }

  static String encryptLocal(String key, String password) {
    debugPrint("LOCAL encrypt IS USED");
    return RNCryptor.encrypt(key, password);
  }

  static String decryptLocal(String key, String encryptedPassword) {
    debugPrint("LOCAL decrypt IS USED");
    String? ret = RNCryptor.decrypt(key, encryptedPassword);
    return ret ?? "NO PWD";
  }
}
