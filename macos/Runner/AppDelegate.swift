import Cocoa
import FlutterMacOS
import RNCryptor

@NSApplicationMain
class AppDelegate: FlutterAppDelegate {
    
    override func applicationDidFinishLaunching(_ notification: Notification) {
        let controller : FlutterViewController = mainFlutterWindow?.contentViewController as! FlutterViewController
        let channel = FlutterMethodChannel.init(name: "pwmanager/encdecrypt", binaryMessenger: controller.engine.binaryMessenger)
        
        channel.setMethodCallHandler({
            (_ call: FlutterMethodCall, _ result: FlutterResult) -> Void in
            if ("encrypt" == call.method) {
                let arguments = call.arguments
                // TODO try catch
                let input = arguments as! [String]
                self.encrypt(result: result, key: input[0], password: input[1])
            }
            else if ("decrypt" == call.method) {
                let arguments = call.arguments
                // TODO try catch
                let input = arguments as! [String]
                self.decrypt(result: result, key: input[0], password: input[1])
            }
        });
    }
    
    override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }

    // https://github.com/RNCryptor/RNCryptor
    
    private func encrypt(result: FlutterResult, key: String, password: String) {
        let data = password.data(using: .utf8)!
        let encryptedData = RNCryptor.encrypt(data: data, withPassword: key)
        print(encryptedData)
        let encryptedString = encryptedData.base64EncodedString()
        result(encryptedString);
    }
    
    private func decrypt(result: FlutterResult, key: String, password: String) {
        let data = Data(base64Encoded: password) ?? Data()
        do {
            let decryptedData = try RNCryptor.decrypt(data: data, withPassword: key)
            let decryptedString = String(bytes: decryptedData, encoding: .utf8)
            result(decryptedString)
        } catch {
            print(error)
            result("0");
        }
    }
}