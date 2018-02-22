#import "SDGrid.h"

#import "SDAccessibility.h"
#import "SDPreferencesWindowController.h"
#import "MASShortcut+UserDefaults.h"
#import "SDWindow.h"
#import "SDPreferences.h"

@implementation SDGrid

+ (void) setup {
    [MASShortcut setAllowsAnyHotkeyWithOptionModifier:YES];
    
    [self bindDefaultsKey:MyAlignAllToGridShortcutKey action:^{ [self alignAllWindows]; }];
    [self bindDefaultsKey:MyAlignThisToGridShortcutKey action:^{ [self alignThisWindow]; }];
    
    [self bindDefaultsKey:MyMovePrevScreenShortcutKey action:^{ [self moveToNextScreen]; }];
    [self bindDefaultsKey:MyMoveNextScreenShortcutKey action:^{ [self moveToPreviousScreen]; }];
    
    [self bindDefaultsKey:MyMoveLeftShortcutKey action:^{ [self moveLeft]; }];
    [self bindDefaultsKey:MyMoveRightShortcutKey action:^{ [self moveRight]; }];
    
    [self bindDefaultsKey:MyGrowRightShortcutKey action:^{ [self growRight]; }];
    [self bindDefaultsKey:MyShrinkRightShortcutKey action:^{ [self shrinkRight]; }];
    
    [self bindDefaultsKey:MyIncreaseGridWidthShortcutKey action:^{ [self increaseGridWidth]; }];
    [self bindDefaultsKey:MyDecreaseGridWidthShortcutKey action:^{ [self decreaseGridWidth]; }];
    
    [self bindDefaultsKey:MyMaximizeShortcutKey action:^{ [self maximize]; }];
    
    [self bindDefaultsKey:MyFocusWindowLeftShortcutKey action:^{ [self focusWindowLeft]; }];
    [self bindDefaultsKey:MyFocusWindowRightShortcutKey action:^{ [self focusWindowRight]; }];
    [self bindDefaultsKey:MyFocusWindowUpShortcutKey action:^{ [self focusWindowUp]; }];
    [self bindDefaultsKey:MyFocusWindowDownShortcutKey action:^{ [self focusWindowDown]; }];
    
    [self bindDefaultsKey:MyShrinkToLowerRowShortcutKey action:^{ [self shrinkToLower]; }];
    [self bindDefaultsKey:MyShrinkToUpperRowShortcutKey action:^{ [self shrinkToUpper]; }];
    [self bindDefaultsKey:MyFillEntireColumnShortcutKey action:^{ [self fillEntireColumn]; }];
}

+ (void) bindDefaultsKey:(NSString*)key action:(dispatch_block_t)action {
    [MASShortcut registerGlobalShortcutWithUserDefaultsKey:key handler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([[SDPreferencesWindowController singleton] showAccessibilityWarningIfNeeded])
                return;
            
            action();
        });
    }];
}

#pragma mark -

NSPoint SDMidpoint(NSRect r) {
    return NSMakePoint(NSMidX(r), NSMidY(r));
}

+ (NSArray*) windowsInDirectionFn:(double(^)(double angle))whichDirectionFn
                shouldDisregardFn:(BOOL(^)(double deltaX, double deltaY))shouldDisregardFn
{
    SDWindow* thisWindow = [SDWindow focusedWindow];
    NSPoint startingPoint = SDMidpoint([thisWindow frame]);
    
    NSArray* otherWindows = [thisWindow otherWindowsOnSameScreen];
    NSMutableArray* closestOtherWindows = [NSMutableArray arrayWithCapacity:[otherWindows count]];
    
    for (SDWindow* win in otherWindows) {
        NSPoint otherPoint = SDMidpoint([win frame]);
        
        double deltaX = otherPoint.x - startingPoint.x;
        double deltaY = otherPoint.y - startingPoint.y;
        
        if (shouldDisregardFn(deltaX, deltaY))
            continue;
        
        double angle = atan2(deltaY, deltaX);
        double distance = hypot(deltaX, deltaY);
        
        double angleDifference = whichDirectionFn(angle);
        
        double score = distance / cos(angleDifference / 2.0);
        
        [closestOtherWindows addObject:@{
         @"score": @(score),
         @"win": win,
         }];
    }
    
    NSArray* sortedOtherWindows = [closestOtherWindows sortedArrayUsingComparator:^NSComparisonResult(NSDictionary* pair1, NSDictionary* pair2) {
        return [[pair1 objectForKey:@"score"] compare: [pair2 objectForKey:@"score"]];
    }];
    
    return sortedOtherWindows;
}

+ (void) focusFirstValidWindowIn:(NSArray*)closestWindows {
    for (SDWindow* win in [closestWindows valueForKeyPath:@"win"]) {
        if ([win focusWindow])
            break;
    }
}

+ (void) focusWindowLeft {
    NSArray* closestWindows = [self windowsInDirectionFn:^double(double angle) { return M_PI - fabs(angle); }
                                       shouldDisregardFn:^BOOL(double deltaX, double deltaY) { return (deltaX >= 0); }];
    
    [self focusFirstValidWindowIn:closestWindows];
}

+ (void) focusWindowRight {
    NSArray* closestWindows = [self windowsInDirectionFn:^double(double angle) { return 0.0 - angle; }
                                       shouldDisregardFn:^BOOL(double deltaX, double deltaY) { return (deltaX <= 0); }];
    
    [self focusFirstValidWindowIn:closestWindows];
}

+ (void) focusWindowUp {
    NSArray* closestWindows = [self windowsInDirectionFn:^double(double angle) { return -M_PI_2 - angle; }
                                       shouldDisregardFn:^BOOL(double deltaX, double deltaY) { return (deltaY >= 0); }];
    
    [self focusFirstValidWindowIn:closestWindows];
}

+ (void) focusWindowDown {
    NSArray* closestWindows = [self windowsInDirectionFn:^double(double angle) { return M_PI_2 - angle; }
                                       shouldDisregardFn:^BOOL(double deltaX, double deltaY) { return (deltaY <= 0); }];
    
    [self focusFirstValidWindowIn:closestWindows];
}

+ (void) maximize {
    [[SDWindow focusedWindow] maximize];
}

+ (void) increaseGridWidth {
    [SDPreferences setWidth:[SDPreferences width] + 1];
    [self alignAllWindows];
}

+ (void) decreaseGridWidth {
    [SDPreferences setWidth:MAX(2, [SDPreferences width] - 1)];
    [self alignAllWindows];
}

+ (void) alignAllWindows {
    for (SDWindow* win in [SDWindow visibleWindows]) {
        [win moveToGridProps:[win gridProps]];
    }
}

+ (void) alignThisWindow {
    SDWindow* win = [SDWindow focusedWindow];
    [win moveToGridProps:[win gridProps]];
}

+ (void) moveLeft {
    SDWindow* win = [SDWindow focusedWindow];
    CGRect r = [win gridProps];
    r.origin.x = MAX(r.origin.x - 1, 0);
    [win moveToGridProps:r];
}

+ (void) moveRight {
    SDWindow* win = [SDWindow focusedWindow];
    CGRect r = [win gridProps];
    r.origin.x = MIN(r.origin.x + 1, [SDPreferences width] - r.size.width);
    [win moveToGridProps:r];
}

+ (void) growRight {
    SDWindow* win = [SDWindow focusedWindow];
    CGRect r = [win gridProps];
    r.size.width = MIN(r.size.width + 1, [SDPreferences width] - r.origin.x);
    [win moveToGridProps:r];
}

+ (void) shrinkRight {
    SDWindow* win = [SDWindow focusedWindow];
    CGRect r = [win gridProps];
    r.size.width = MAX(r.size.width - 1, 1);
    [win moveToGridProps:r];
}

+ (void) moveToNextScreen {
    SDWindow* win = [SDWindow focusedWindow];
    [win moveToNextScreen];
}

+ (void) moveToPreviousScreen {
    SDWindow* win = [SDWindow focusedWindow];
    [win moveToPreviousScreen];
}

+ (void) shrinkToLower {
    SDWindow* win = [SDWindow focusedWindow];
    CGRect r = [win gridProps];
    r.origin.y = 1;
    r.size.height = 1;
    [win moveToGridProps:r];
}

+ (void) shrinkToUpper {
    SDWindow* win = [SDWindow focusedWindow];
    CGRect r = [win gridProps];
    r.origin.y = 0;
    r.size.height = 1;
    [win moveToGridProps:r];
}

+ (void) fillEntireColumn {
    SDWindow* win = [SDWindow focusedWindow];
    CGRect r = [win gridProps];
    r.origin.y = 0;
    r.size.height = 2;
    [win moveToGridProps:r];
}

@end
