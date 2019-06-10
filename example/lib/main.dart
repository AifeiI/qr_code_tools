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
            (file) => Observable.fromFuture(QrCodeToolsPlugin.decodeFrom(file.path)))
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
      return Observable.fromFuture(QrCodeToolsPlugin.decodeFrom(file.path));
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
