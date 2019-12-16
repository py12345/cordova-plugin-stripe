#import "AppDelegate+CordovaStripe.h"
#import "CordovaStripe.h"
@import Stripe;

@implementation AppDelegate (CordovaStripe)
static NSString* const PLUGIN_NAME = @"CordovaStripe";
- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller didAuthorizePayment:(PKPayment *)payment completion:(void (^)(PKPaymentAuthorizationStatus))completion {
    CordovaStripe* pluginInstance = [self.viewController getCommandInstance:PLUGIN_NAME];
    if (pluginInstance != nil) {
        // Send token back to plugin
        [pluginInstance processPayment:controller didAuthorizePayment:payment completion:completion];
    } else {
        // Discard payment
        NSLog(@"Unable to get plugin instsnce, discarding payment.");
        completion(PKPaymentAuthorizationStatusFailure);
    }
}

- (void)paymentAuthorizationViewControllerDidFinish:(PKPaymentAuthorizationViewController *)controller {
    CordovaStripe* pluginInstance = [self.viewController getCommandInstance:PLUGIN_NAME];
    if (!pluginInstance.hasProcessedApplePayPayment) {
        CDVPluginResult *result;
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"User canceled ApplePay"];
        [pluginInstance.commandDelegate sendPluginResult:result callbackId:pluginInstance.applePayCDVCallbackId];
        pluginInstance.applePayCDVCallbackId = nil;
    }
    [self.viewController dismissViewControllerAnimated:YES completion:nil];
}

@end
