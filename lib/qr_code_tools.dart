import 'dart:async';

import 'package:flutter/services.dart';

class QrCodeToolsPlugin {
  static const MethodChannel _channel =
      const MethodChannel('qr_code_tools');

  static Future<String> from(String file) async {
    final String data = await _channel.invokeMethod('decoder', {'file': file});
    return data;
  }
}
