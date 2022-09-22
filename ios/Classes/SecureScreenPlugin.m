#import "SecureScreenPlugin.h"
#if __has_include(<secure_screen/secure_screen-Swift.h>)
#import <secure_screen/secure_screen-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "secure_screen-Swift.h"
#endif

@implementation SecureScreenPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftSecureScreenPlugin registerWithRegistrar:registrar];
}
@end
