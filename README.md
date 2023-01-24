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

- build windows and mac deployment (flutter build)
- test on windows
- password class integrate
- encrypt password only once (issue with lag in application)
- edit dialog - make password editable

Not to do
- add own category

# Known issues

- Decrypt / Encrypt (there are some known issues but the goal (try to execute some code in a other language) should be reached)
    - the Encrypt / Decrypt on Windows was startet to implement but not finished and is therefore not delivered
        - it works with the dart encode / decode implementation
    - in the filter field tags or text can be filtered
    - password can not be edited at the moment
