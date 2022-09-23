#import "ProtectedScreenPlugin.h"
#if __has_include(<protected_screen/protected_screen-Swift.h>)
#import <protected_screen/protected_screen-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "protected_screen-Swift.h"
#endif

@implementation ProtectedScreenPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftProtectedScreenPlugin registerWithRegistrar:registrar];
}
@end
