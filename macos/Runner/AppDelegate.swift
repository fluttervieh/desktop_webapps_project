import Cocoa
import FlutterMacOS

@NSApplicationMain
class AppDelegate: FlutterAppDelegate {

  override func applicationDidFinishLaunching(_ notification: Notification) {
    let controller : FlutterViewController = mainFlutterWindow?.contentViewController as! FlutterViewController
    let channel = FlutterMethodChannel.init(name: "pwmanager/encdecrypt", binaryMessenger: controller.engine.binaryMessenger)
    channel.setMethodCallHandler({
      (_ call: FlutterMethodCall, _ result: FlutterResult) -> Void in
      if ("test" == call.method) {
        let arguments = call.arguments
        if arguments is String {
          let input = arguments as! String
          self.test(result: result, input: input)
        }
      } else if ("encrypt" == call.method) {
        let arguments = call.arguments
        print("arguments")
        print(type(of: arguments))

        if arguments is String {
          let input = arguments as! String
          self.encrypt(result: result, key: input, password: input)
        }
      }
    });
  }

  override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    return true
  }
  
  // https://github.com/tangs/idiom_lv_maker/blob/c50636c1de8a1cb437be60bde46a7b4fbb9859aa/macos/Runner/AppDelegate.swift
  private func test(result: FlutterResult, input: String) {
    result(1);
  }

  private func encrypt(result: FlutterResult, key: String, password: String) {
    result(1);
  }

}

