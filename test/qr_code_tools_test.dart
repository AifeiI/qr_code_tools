import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qr_code_tools/qr_code_tools.dart';

void main() {
  const MethodChannel channel = MethodChannel('qr_code_tools');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return 'This is TEST';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('from', () async {
    File qrCodeFile = File('../example/images/1559788943.png');
    expect(await QrCodeToolsPlugin.decodeFrom(qrCodeFile.path), 'This is TEST');
  });
}
