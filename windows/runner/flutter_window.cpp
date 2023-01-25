#include "flutter_window.h"
#include <flutter/event_channel.h>
#include <flutter/event_sink.h>
#include <flutter/event_stream_handler_functions.h>
#include <flutter/method_channel.h>
#include <flutter/standard_method_codec.h>
#include <windows.h>

#include <memory>

#include <optional>

#include "flutter/generated_plugin_registrant.h"


// custom functions for flutter start
// static int GetBatteryLevel() {
//   SYSTEM_POWER_STATUS status;
//   if (GetSystemPowerStatus(&status) == 0 || status.BatteryLifePercent == 255) {
//     return -1;
//   }
//   return status.BatteryLifePercent;
// }

// custom functions for flutter end

FlutterWindow::FlutterWindow(const flutter::DartProject& project)
    : project_(project) {}

FlutterWindow::~FlutterWindow() {}

bool FlutterWindow::OnCreate() {
  if (!Win32Window::OnCreate()) {
    return false;
  }

  RECT frame = GetClientArea();

  // The size here must match the window dimensions to avoid unnecessary surface
  // creation / destruction in the startup path.
  flutter_controller_ = std::make_unique<flutter::FlutterViewController>(
      frame.right - frame.left, frame.bottom - frame.top, project_);
  // Ensure that basic setup of the controller was successful.
  if (!flutter_controller_->engine() || !flutter_controller_->view()) {
    return false;
  }
  RegisterPlugins(flutter_controller_->engine());

  // platform specific code starts here

  flutter::MethodChannel<> channel(
      flutter_controller_->engine()->messenger(), "pwmanager/encdecrypt",
      &flutter::StandardMethodCodec::GetInstance());
  channel.SetMethodCallHandler(
      [](const flutter::MethodCall<>& call,
         std::unique_ptr<flutter::MethodResult<>> result) {


           const flutter::EncodableMap *argsList = std::get_if<flutter::EncodableMap>(call.arguments()); 
               //we will get values in pairs ie., first::"a" second::10.
               //we get the second part
               auto key_it = (argsList->find(flutter::EncodableValue("key")))->second;    
               auto password_it = (argsList->find(flutter::EncodableValue("password")))->second; 
               // Just converting it to int
               std::string key = std::to_string(key_it); // static_cast<string>(std::get<string>((key_it)));
               std::string password = std::to_string(password_it); // static_cast<string>(std::get<string>((password_it)));
               
               /*
               flutter::EncodableValue res ; // final result variable
                 res = flutter::EncodableValue("Sum is: " + c);
                // send positive result
                 (*resPointer)->Success(res);
               */
               
        if (call.method_name() == "encrypt") {

          // how to retrive args

          result->Success("SomeWindowsEncryptedPassword");


          // int battery_level = GetBatteryLevel();
          // if (battery_level != -1) {
          //   result->Success(battery_level);
          // } else {
          //   result->Error("UNAVAILABLE", "Battery level not available.");
          // }

        } else if (call.method_name() == "decrypt") {

          result->Success("SomeWindowsDecryptedPassword");

        } else {
          result->NotImplemented();
        }
      });

  // platform specific code ends here

  SetChildContent(flutter_controller_->view()->GetNativeWindow());
  return true;
}

void FlutterWindow::OnDestroy() {
  if (flutter_controller_) {
    flutter_controller_ = nullptr;
  }

  Win32Window::OnDestroy();
}

LRESULT
FlutterWindow::MessageHandler(HWND hwnd, UINT const message,
                              WPARAM const wparam,
                              LPARAM const lparam) noexcept {
  // Give Flutter, including plugins, an opportunity to handle window messages.
  if (flutter_controller_) {
    std::optional<LRESULT> result =
        flutter_controller_->HandleTopLevelWindowProc(hwnd, message, wparam,
                                                      lparam);
    if (result) {
      return *result;
    }
  }

  switch (message) {
    case WM_FONTCHANGE:
      flutter_controller_->engine()->ReloadSystemFonts();
      break;
  }

  return Win32Window::MessageHandler(hwnd, message, wparam, lparam);
}