import Flutter
import UIKit

public class SwiftQrCodeToolsPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "qr_code_tools", binaryMessenger: registrar.messenger())
    let instance = SwiftQrCodeToolsPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    if (call.method == "decoder") {
        guard let args = call.arguments else {
            result("")
            return;
        };
        let filePath: String = (args as! [String: Any])["file"] as! String;
        let qrCOdeData = messageFromQRCodeImage(path: filePath);
        result(qrCOdeData);
    } else {
        result("");
    }
  }

  public func messageFromQRCodeImage(path: String) -> String? {

      let image: UIImage? = UIImage.init(contentsOfFile: path);
      if (image == nil) {
          return nil;
      }

      let ciContext: CIContext = CIContext.init();
      let ciDetector: CIDetector? = CIDetector.init(ofType: CIDetectorTypeQRCode, context: ciContext, options: [CIDetectorAccuracy:CIDetectorAccuracyHigh]);
      let ciImage: CIImage? = CIImage.init(image: image!);
      let ciFeature: [CIFeature]? = ciDetector?.features(in: ciImage!);

      if (ciFeature?.count == 0) {
          return nil;
      }

      for feature in ciFeature! {
          if (feature is CIQRCodeFeature) {
              return (feature as! CIQRCodeFeature).messageString;
          }
      }

      return nil;

  }
}
