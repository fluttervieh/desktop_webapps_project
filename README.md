# desktop_webapp

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## TODOs
- [ ] beispiel für platformspezifische designanpassungen 
- [x] jeder eintrag sollte folgende felder haben
    - [x] titel
    - [x] username
    - [x] password
    - [x] url
- [ ] alle credentials sollten aufgelistet werden können
- [x] eintrag hinzufügen
- [ ] eintrag bearbeiten
- [x] eintrag löschen
- [x] tags zu einträgen hinzufügen
- [ ] liste filtern
    - [x] über tags
    - [ ] über titel
- [ ] passwort verschlüsselt speichern
    - [x] idealerweise mit anderer programmiersprache (webasembly)
    - [x] entschlüsseln beim lesen (mit masterpasswort?)
    - [ ] integration in programm
- [x] Testing
    - [x] Unit Tests
    - [x] UI Tests
- [ ] Readme.md mit how to start the application


# How to start the application

## Production

For windows and Mac 2 executables are packed inside of the XY folder. They can be executed right away.

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

# Open TODO Points

- cleanup code (remove unused code(main.dart))
- remove android, ios and (web?)
- build windows and mac deployment (flutter build)
- Titel bearbeiten
- reformat code
- test on windows
- password class integrate
- is it really working on macos??

# Known issues

- Decrypt / Encrypt (there are some known issues but the goal (try to execute some code in a other language) should be reached)
    - the Decrypt function on macos has a bug but the details are currently unknown - it is handled by the local decryption implementation
    - the Encrypt / Decrypt on Windows is not finished implementing

