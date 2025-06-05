#import <UIKit/UIKit.h>
#import <Cordova/CDV.h>

@interface ScreenRecordingGuard : CDVPlugin
- (void)checkAndHide:(CDVInvokedUrlCommand*)command;
@end

@implementation ScreenRecordingGuard

- (void)checkAndHide:(CDVInvokedUrlCommand*)command {
    BOOL isCaptured = NO;
    if (@available(iOS 11.0, *)) {
        isCaptured = [UIScreen mainScreen].isCaptured;
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;

        if (isCaptured) {
            // Check if blur view already exists
            if (![keyWindow viewWithTag:99999]) {
                // Create a blur effect
                UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
                UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:blur];
                blurView.frame = keyWindow.bounds;
                blurView.tag = 99999;
                blurView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
                [keyWindow addSubview:blurView];
            }
        } else {
            // Remove blur view if present
            UIView *existing = [keyWindow viewWithTag:99999];
            if (existing) {
                [existing removeFromSuperview];
            }
        }
    });

    CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:isCaptured];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

@end
