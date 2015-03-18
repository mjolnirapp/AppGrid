#import <Cocoa/Cocoa.h>

@interface SDWindow : NSObject

+ (NSArray*) allWindows;
+ (NSArray*) visibleWindows;
+ (SDWindow*) focusedWindow;

- (CGRect) frame;
- (void) setFrame:(CGRect)frame;

- (CGRect) gridProps;
- (void) moveToGridProps:(CGRect)gridProps;

- (void) moveToNextScreen;
- (void) moveToPreviousScreen;

- (void) maximize;

- (BOOL) focusWindow;

- (NSArray*) otherWindowsOnSameScreen;

- (NSString *) title;

@end
