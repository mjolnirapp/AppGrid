#import "MASShortcut.h"

@interface MASShortcut (Monitoring)

+ (id)addGlobalHotkeyMonitorWithShortcut:(MASShortcut *)shortcut handler:(void (^)(void))handler;
+ (void)removeGlobalHotkeyMonitor:(id)monitor;

@end
