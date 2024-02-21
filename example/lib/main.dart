import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_code_tools/qr_code_tools.dart';

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
    getTemporaryDirectory()
        .then((dir) => File('${dir.path}/$filename'))
        .then((file) => file.existsSync()
            ? Future.value(file)
            : rootBundle
                .load("images/$filename")
                .then((bytes) => file.writeAsBytes(bytes.buffer.asUint8List())))
        .then((file) {
          setState(() {
            _qrcodeFile = file.path;
          });
          return file;
        })
        .then((file) => decodeQR(file.path))
        .then((data) {
          setState(() => _data = 'Decode is failed');
        })
        .catchError((e) {
          setState(() {
            _data = 'Failed to load this file';
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
    picker
        .pickImage(source: ImageSource.gallery)
        .then((xfile) => xfile?.path)
        .then((path) {
      if (path != null) {
        setState(() {
          _qrcodeFile = path;
        });
        decodeQR(path).then((data) => setState(() => _data = data ?? 'Decode is failed'));
      } else {
        setState(() {
          _data = 'Failed to load this file';
        });
      }
    });
  }

  Future<String?> decodeQR(String filePath) {
    return QrCodeToolsPlugin.decodeFrom(filePath);
  }
}
