#import "QrCodeToolsPlugin.h"
#import <qr_code_tools/qr_code_tools-Swift.h>

@implementation QrCodeToolsPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftQrCodeToolsPlugin registerWithRegistrar:registrar];
}
@end
