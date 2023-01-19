import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'dart:io';

class Encryptdecrypt {
  static void test(String txt) async {
    // mac platform
    if (Platform.isMacOS) {
      const platform = MethodChannel('pwmanager/encdecrypt');
      try {
        int ret = await platform.invokeMethod('test', txt);
        if (ret != 0) {
          debugPrint("Save Failed.");
        } else {
          debugPrint("SUCCESS YEEEEEEEY");
        }
      } on PlatformException catch (e) {
        debugPrint("Failed: '${e.message}'.");
      }
    }
  }

  static void encrypt(String key, String password) async {
    // mac platform
    if (Platform.isMacOS) {
      const platform = MethodChannel('pwmanager/encdecrypt');
      try {
        int ret = await platform.invokeMethod('encrypt', [key, password]);
        if (ret != 0) {
          debugPrint("Save Failed.");
        } else {
          debugPrint("SUCCESS YEEEEEEEY");
        }
      } on PlatformException catch (e) {
        debugPrint("Failed: '${e.message}'.");
      }
    }
  }
}
