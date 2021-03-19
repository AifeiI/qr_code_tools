#import "QrCodeToolsPlugin.h"
#if __has_include(<qr_code_tools/qr_code_tools-Swift.h>)
#import <qr_code_tools/qr_code_tools-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "qr_code_tools-Swift.h"
#endif

@implementation QrCodeToolsPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftQrCodeToolsPlugin registerWithRegistrar:registrar];
}
@end
