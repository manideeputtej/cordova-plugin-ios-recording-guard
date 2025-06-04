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

    if (isCaptured) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
            UIView *blocker = [[UIView alloc] initWithFrame:keyWindow.bounds];
            blocker.backgroundColor = [UIColor blackColor];
            blocker.tag = 99999;
            blocker.alpha = 1.0;
            [keyWindow addSubview:blocker];
        });
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
            UIView *blocker = [keyWindow viewWithTag:99999];
            if (blocker != nil) {
                [blocker removeFromSuperview];
            }
        });
    }

    CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:isCaptured];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

@end