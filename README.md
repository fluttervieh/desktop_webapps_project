# PW Manager

A Fluttter Desktop PW Manager

Supportet Plattforms
- Windows
- Macos (10.13+)
- Web

by
- Richard Lorenz
- Stefan Beller

**in the Lecture Desktop Web Applications**

# How to start the application

To start the application Production and Development mode are available.

Note: the master password ist **test**

## Production

For windows and Mac (arm64) 2 executables are packed inside of the productionApplications folder. They can be executed right away.

## Development

For running the Application in development mode follow the following steps.

### Install Tools

Make sure Flutter and Dart is installed.

We recommend working with Visual Studio Code and the Flutter and Dart extensions.
### Install Packages

In the root directory of the Project run the following command: 

    flutter pub get

to install all required packages


### Run the Application

To run the application 
    - select the Target Device in the lower left corner in VS Code.
    - in the main.dart file above the void main method click on run

### Run the Tests

To run the tests 
    - select the Target Device in the lower left corner in VS Code.
    - in the test directory select a test and above the void main method click on run

## TODOs
- [x] beispiel für platformspezifische designanpassungen 
- [x] jeder eintrag sollte folgende felder haben
    - [x] titel
    - [x] username
    - [x] password
    - [x] url
- [x] alle credentials sollten aufgelistet werden können
- [x] eintrag hinzufügen
- [x] eintrag bearbeiten
- [x] eintrag löschen
- [x] tags zu einträgen hinzufügen
- [x] liste filtern
    - [x] über tags
    - [x] über titel
- [x] passwort verschlüsselt speichern
    - [x] idealerweise mit anderer programmiersprache (webasembly)
    - [x] entschlüsseln beim lesen (mit masterpasswort?)
    - [x] integration in programm
- [x] Testing
    - [x] Unit Tests
    - [x] UI Tests
- [x] Readme.md mit how to start the application

# Known issues

- Decrypt / Encrypt (there are some known issues but the goal (try to execute some code in a other language) should be reached)
    - the Encrypt / Decrypt on Windows was startet to implement but not finished and is therefore not delivered
        - it works with the dart encode / decode implementation
    - in the filter field tags or text can be filtered
    - password can not be edited at the moment
    - we also had some problems with third party code using web assembly - this is documented in a seperate word document

# Solutions

Some known issues are partially or not implemented. How to implement them is described in the following part.
## Improvement of Search function

Filtering and searching for entries: The current state of the application allows to search for entries OR filter them by their given tags.

We just have to type in the alias or the url of an entry and hit the search button. However, if we want to display all entries again, we have to clear the text input field and hit the search button on the right again.
For the filtering feature we just have to click on the filter categories below the search bar. Here we can select multiple filters. Due to human failure from the devs it is currently not possible to combine to search and filter function, so we either can use the one or the other.

## How to Implement Plattform channels on Windows

On windows at the moment the Plattform channels are not implemented.

### This is due to the following Reasons
- RNCryptor Library is in alpha stage and not usable at the moment
- C++ had some bugs we are not able to fix in time

### How would we have implemented this?

1. We would need to add the Windows platform to also use the platform channels.
2. The flutter_window.cpp file needs to be edited in the following way

Add Imports

    #include <flutter/event_channel.h>
    #include <flutter/event_sink.h>
    #include <flutter/event_stream_handler_functions.h>
    #include <flutter/method_channel.h>
    #include <flutter/standard_method_codec.h>
    #include <windows.h>

    #include <memory>


Add code to accept the encode and decode calls

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

            if (call.method_name() == "encrypt") {

            // how to retrive args

            // encrypt password

            result->Success("SomeWindowsEncryptedPassword");

            } else if (call.method_name() == "decrypt") {

            // decrypt password

            result->Success("SomeWindowsDecryptedPassword");

            } else {
            result->NotImplemented();
            }
        });