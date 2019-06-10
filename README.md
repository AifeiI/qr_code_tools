# QR Code Tools

[![Build Status](https://travis-ci.org/AifeiI/qr_code_tools.svg?branch=master)](https://travis-ci.org/AifeiI/qr_code_tools)
[![pub package](https://img.shields.io/pub/v/qr_code_tools.svg)](https://travis-ci.org/AifeiI/qr_code_tools)

The Flutter plugin for iOS and Android to decoding QR codes.

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
