#import <Cocoa/Cocoa.h>
#import "MASShortcutView.h"

#define MyAlignAllToGridShortcutKey @"MyAlignAllToGridShortcutKey"
#define MyAlignThisToGridShortcutKey @"MyAlignThisToGridShortcutKey"

#define MyMoveNextScreenShortcutKey @"MyMoveNextScreenShortcutKey"
#define MyMovePrevScreenShortcutKey @"MyMovePrevScreenShortcutKey"

#define MyMoveLeftShortcutKey @"MyMoveLeftShortcutKey"
#define MyMoveRightShortcutKey @"MyMoveRightShortcutKey"

#define MyGrowRightShortcutKey @"MyGrowRightShortcutKey"
#define MyShrinkRightShortcutKey @"MyShrinkRightShortcutKey"

#define MyIncreaseGridWidthShortcutKey @"MyIncreaseGridWidthShortcutKey"
#define MyDecreaseGridWidthShortcutKey @"MyDecreaseGridWidthShortcutKey"

#define MyMaximizeShortcutKey @"MyMaximizeShortcutKey"

#define MyFocusWindowLeftShortcutKey @"MyFocusWindowLeftShortcutKey"
#define MyFocusWindowRightShortcutKey @"MyFocusWindowRightShortcutKey"
#define MyFocusWindowUpShortcutKey @"MyFocusWindowUpShortcutKey"
#define MyFocusWindowDownShortcutKey @"MyFocusWindowDownShortcutKey"

#define MyShrinkToUpperRowShortcutKey @"MyShrinkToUpperRowShortcutKey"
#define MyShrinkToLowerRowShortcutKey @"MyShrinkToLowerRowShortcutKey"
#define MyFillEntireColumnShortcutKey @"MyFillEntireColumnShortcutKey"

@interface SDPreferencesWindowController : NSWindowController

+ (instancetype) singleton;

- (BOOL) showAccessibilityWarningIfNeeded;

@end
