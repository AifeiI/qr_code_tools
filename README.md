# QR Code Tools

[![Build Status](https://travis-ci.org/AifeiI/qr_code_tools.svg?branch=master)](https://travis-ci.org/AifeiI/qr_code_tools#)

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
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_code_tools/qr_code_tools.dart';
import 'package:rxdart/rxdart.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _qrcodeFile = '';
  String _data = '';

  @override
  void initState() {
    super.initState();

    String filename = '1559788943.png';
    Observable.fromFuture(getTemporaryDirectory())
        .flatMap((tempDir) {
          File qrCodeFile = File('${tempDir.path}/$filename');
          bool exists = qrCodeFile.existsSync();
          if (exists) {
            return Observable.just(qrCodeFile);
          } else {
            return Observable.fromFuture(rootBundle.load("images/$filename"))
                .flatMap((bytes) => Observable.fromFuture(
                    qrCodeFile.writeAsBytes(bytes.buffer.asUint8List(
                        bytes.offsetInBytes, bytes.lengthInBytes))));
          }
        })
        .flatMap(
            (file) => Observable.fromFuture(QrCodeToolsPlugin.from(file.path)))
        .listen((data) {
          setState(() {
            _data = data;
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              _qrcodeFile.isEmpty
                  ? Image.asset(
                      'images/1559788943.png',
                    )
                  : Image.file(File(_qrcodeFile)),
              RaisedButton(
                child: Text("Select file"),
                onPressed: _getPhotoByGallery,
              ),
              Text('Qr Code data: $_data\n'),
            ],
          ),
        ),
      ),
    );
  }

  void _getPhotoByGallery() {
    Observable.fromFuture(ImagePicker.pickImage(source: ImageSource.gallery))
        .flatMap((file) {
      setState(() {
        _qrcodeFile = file.path;
      });
      return Observable.fromFuture(QrCodeToolsPlugin.from(file.path));
    }).listen((data) {
      setState(() {
        _data = data;
      });
    }).onError((error, stackTrace) {
      setState(() {
        _data = '';
      });
      print('${error.toString()}');
    });
  }
}
```

For a more elaborate usage example see [here](https://github.com/AifeiI/qr_code_tools/tree/master/example).