#import "SDAccessibility.h"

extern Boolean AXIsProcessTrustedWithOptions(CFDictionaryRef options) __attribute__((weak_import));
extern CFStringRef kAXTrustedCheckOptionPrompt __attribute__((weak_import));

@implementation SDAccessibility

+ (void) setup {
    [[NSDistributedNotificationCenter defaultCenter] addObserver:[self singleton]
                                                        selector:@selector(accessibilityChanged:)
                                                            name:@"com.apple.accessibility.api"
                                                          object:nil];
    [[self singleton] recache];
}

- (void) recache {
    self.isEnabled = [SDAccessibility isEnabled];
}

+ (BOOL) isEnabled {
    if (AXIsProcessTrustedWithOptions != NULL)
        return AXIsProcessTrustedWithOptions(NULL);
    else
        return AXAPIEnabled();
}

+ (void) openPanel {
    if (AXIsProcessTrustedWithOptions != NULL) {
        AXIsProcessTrustedWithOptions((__bridge CFDictionaryRef)@{(__bridge id)kAXTrustedCheckOptionPrompt: @YES});
    }
    else {
        static NSString* script = @"tell application \"System Preferences\"\nactivate\nset current pane to pane \"com.apple.preference.universalaccess\"\nend tell";
        [[[NSAppleScript alloc] initWithSource:script] executeAndReturnError:nil];
    }
}

+ (instancetype) singleton {
    static id s;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s = [[self alloc] init];
    });
    return s;
}

- (void) accessibilityChanged:(NSNotification*)note {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self recache];
    });
}

@end
