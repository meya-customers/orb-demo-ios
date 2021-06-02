# Orb Demo for iOS

This app demonstrates how to integrate and launch the Orb SDK in an Android native app.

## Getting started

### Install Xcode
Follow the Xcode installation instructions for your development mac:

- [macOS](https://developer.apple.com/xcode/)

### Install CocoaPods
Follow the installation instructions for your development mac:

- [macOS](https://guides.cocoapods.org/using/using-cocoapods.html)


### Install Flutter
Follow the Flutter installation instructions for your development environment:

- [Windows](https://flutter.dev/docs/get-started/install/windows)
- [macOS](https://flutter.dev/docs/get-started/install/macos)
- [Linux](https://flutter.dev/docs/get-started/install/linux)
- [ChromeOs](https://flutter.dev/docs/get-started/install/chromeos)

Check your Flutter installation:

```shell
which flutter
flutter doctor
```

### Clone the Orb SDK repo

Clone the [Orb SDK repo](https://github.com/meya-ai/orb-sdk) into the directory containing this repo 
such that the `orb-sdk` repo and this `orb-demo-android` repos are siblings in a parent directory:

```
parent/
  |-- orb-sdk/
  |-- orb-demo-ios/
```

### Setup the Orb SDK

Run the following commands:

```shell
cd orb-sdk/orb_sdk/
flutter pub get
cd ../../orb-demo-ios
pod install
```

**Note**, you will need to run these commands every time a change occurs in `orb-sdk` repo e.g.
you checkout a different sdk version, or you made some manual changes.


### Build and run the Orb Demo

- Open Xcode
- Select `Open a project or file`
- Navigate to your `orb-demo-ios` directory
- Select the `OrbDemo.xcworkspace` workspace

Once Xcode has opened the OrbDemo workspace do the following:
- Select `iPhone 11` as the active scheme (this is just to the right of the Play/Stop buttons)
- Build the project `Cmd+B`
- Click the Play button

