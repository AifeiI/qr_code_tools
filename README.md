# Custom QR Code Tools fork

Fork of the Flutter dependency `qr_code_tools` for the FOX Live Valve/Transfer Neo mobile application.

This fork was created to address an issue with version `0.1.0` of the `qr_code_tools` package.

The change implemented into this branch was adding a `namespace` value of `com.aifeii.qrcode.tools` to `android/build.gradle` as it is now required to run dependencies, which the release version is lacking. 

Please leave this repo public so we can access it for our mobile app 😊

To learn more about this plugin and check on releases that should fix this issue check out their pub.dev [![page](https://pub.dev/packages/qr_code_tools)](https://travis-ci.org/AifeiI/qr_code_tools)


## Installation

First, add `qr_code_tools` as a [dependency in your pubspec.yaml file](https://flutter.io/using-packages/).

### iOS

Add one rows to the `ios/Runner/Info.plist`:

* one with the key `Privacy - Photo Library Usage Description` and a usage description.

Or in text format add the key:

```xml
<key>NSPhotoLibraryUsageDescription</key>
<string>Can I use the photo library please?</string>
```

### Android

Nothing to do

## Example

```dart
import 'package:qr_code_tools/qr_code_tools.dart';

String _data;

/// decode from local file
Future decode(String file) async {
  String data = await QrCodeToolsPlugin.decodeFrom(file);
  setState(() {
    _data = data;
  });
}
```

For a more elaborate usage example see [here](https://github.com/AifeiI/qr_code_tools/tree/master/example).
