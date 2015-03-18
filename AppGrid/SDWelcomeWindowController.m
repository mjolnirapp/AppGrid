#import "SDWelcomeWindowController.h"

#define SDInstructionsWindowFirstTimePastKey @"SDInstructionsWindowFirstTimePassed" // never change this line, ever.

@implementation SDWelcomeWindowController

- (NSString*) windowNibName {
    return @"WelcomeWindow";
}

+ (SDWelcomeWindowController*) sharedWelcomeWindowController {
    static SDWelcomeWindowController* sharedWelcomeWindowController;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedWelcomeWindowController = [[SDWelcomeWindowController alloc] init];
    });
    return sharedWelcomeWindowController;
}

+ (void) showInstructionsWindowFirstTimeOnly {
    BOOL firstTimePast = [[NSUserDefaults standardUserDefaults] boolForKey:SDInstructionsWindowFirstTimePastKey];
    
    if (!firstTimePast) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:SDInstructionsWindowFirstTimePastKey];
        [self showInstructionsWindow];
    }
}

+ (void) showInstructionsWindow {
	[NSApp activateIgnoringOtherApps:YES];
	[[[self sharedWelcomeWindowController] window] center];
	[[self sharedWelcomeWindowController] showWindow:self];
}

- (NSString*) appName {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
}

- (void) windowDidLoad {
    [super windowDidLoad];
    [[self window] setContentBorderThickness:34.0 forEdge:NSMinYEdge];
}

@end




@interface SDWelcomeWindowRoundedImageView : NSImageView
@end

@implementation SDWelcomeWindowRoundedImageView

- (void) drawRect:(NSRect)dirtyRect {
    float r = 7.0;
    float r2 = r - 0.9;
    
    NSRect bounds = [self bounds];
    NSRect imageClipBounds = NSInsetRect(bounds, 1.0, 1.0);
    
    NSBezierPath *borderFillPath = [NSBezierPath bezierPathWithRoundedRect:bounds xRadius:r yRadius:r];
    NSBezierPath *imageClipPath = [NSBezierPath bezierPathWithRoundedRect:imageClipBounds xRadius:r2 yRadius:r2];
    
    // draw border
    [[NSColor colorWithCalibratedWhite:0.20 alpha:0.60] setFill];
    [borderFillPath fill];
    
    // clip
    [imageClipPath addClip];
    
    // draw image
    [super drawRect:dirtyRect];
}

@end
