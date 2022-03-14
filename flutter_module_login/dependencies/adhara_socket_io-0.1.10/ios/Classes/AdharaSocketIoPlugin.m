#import "AdharaSocketIoPlugin.h"
#import <adhara_socket_io/adhara_socket_io-Swift.h>

@implementation AdharaSocketIoPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftAdharaSocketIoPlugin registerWithRegistrar:registrar];
}
@end
