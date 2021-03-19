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
  final picker = ImagePicker();
  String _qrcodeFile = '';
  String _data = '';

  @override
  void initState() {
    super.initState();

    String filename = '1559788943.png';
    Stream.fromFuture(getTemporaryDirectory())
        .flatMap((tempDir) {
          File qrCodeFile = File('${tempDir.path}/$filename');
          bool exists = qrCodeFile.existsSync();
          if (exists) {
            return Stream.value(qrCodeFile);
          } else {
            return Stream.fromFuture(rootBundle.load("images/$filename"))
                .flatMap((bytes) => Stream.fromFuture(qrCodeFile.writeAsBytes(
                    bytes.buffer.asUint8List(
                        bytes.offsetInBytes, bytes.lengthInBytes))));
          }
        })
        .flatMap((file) =>
            Stream.fromFuture(QrCodeToolsPlugin.decodeFrom(file.path)))
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
              ElevatedButton(
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
    Stream.fromFuture(picker.getImage(source: ImageSource.gallery))
        .flatMap((file) {
      setState(() {
        _qrcodeFile = file.path;
      });
      return Stream.fromFuture(QrCodeToolsPlugin.decodeFrom(file.path));
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
