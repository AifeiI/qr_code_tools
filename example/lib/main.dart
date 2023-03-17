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
        appBar: AppBar(title: const Text('Plugin example app')),
        body: Column(
          children: <Widget>[
            _qrcodeFile.isEmpty
                ? Expanded(flex: 2, child: Image.asset('images/1559788943.png'))
                : Expanded(flex: 2, child: Image.file(File(_qrcodeFile))),
            Expanded(
              child: Column(
                children: [
                  ElevatedButton(
                    child: Text("Select file from gallery"),
                    onPressed: _getImageFromGallery,
                  ),
                  Padding(
                    padding: EdgeInsets.all(24),
                    child: Text('Qr Code data: $_data\n'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _getImageFromGallery() async {
    Stream.fromFuture(picker.pickImage(source: ImageSource.gallery))
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
