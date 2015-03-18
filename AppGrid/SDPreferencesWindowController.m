#import "SDPreferencesWindowController.h"
#import "SDAccessibility.h"
#import "MASShortcutView+UserDefaults.h"
#import "SDOpenAtLogin.h"
#import "SDPreferences.h"

@interface SDPreferencesWindowController ()

@property (nonatomic, weak) IBOutlet MASShortcutView *alignAllToGridShortcutView;
@property (nonatomic, weak) IBOutlet MASShortcutView *alignThisToGridShortcutView;

@property (nonatomic, weak) IBOutlet MASShortcutView *moveNextScreenShortcutView;
@property (nonatomic, weak) IBOutlet MASShortcutView *movePrevScreenShortcutView;

@property (nonatomic, weak) IBOutlet MASShortcutView *moveLeftShortcutView;
@property (nonatomic, weak) IBOutlet MASShortcutView *moveRightShortcutView;

@property (nonatomic, weak) IBOutlet MASShortcutView *growRightShortcutView;
@property (nonatomic, weak) IBOutlet MASShortcutView *shrinkRightShortcutView;

@property (nonatomic, weak) IBOutlet MASShortcutView *increaseGridWidthShortcutView;
@property (nonatomic, weak) IBOutlet MASShortcutView *decreaseGridWidthShortcutView;

@property (nonatomic, weak) IBOutlet MASShortcutView *maximizeShortcutView;

@property (nonatomic, weak) IBOutlet MASShortcutView *shrinkToUpperRowShortcutView;
@property (nonatomic, weak) IBOutlet MASShortcutView *shrinkToLowerRowShortcutView;
@property (nonatomic, weak) IBOutlet MASShortcutView *fillEntireColumnShortcutView;

@property (nonatomic, weak) IBOutlet MASShortcutView *focusWindowLeftShortcutView;
@property (nonatomic, weak) IBOutlet MASShortcutView *focusWindowRightShortcutView;
@property (nonatomic, weak) IBOutlet MASShortcutView *focusWindowUpShortcutView;
@property (nonatomic, weak) IBOutlet MASShortcutView *focusWindowDownShortcutView;

@property IBOutlet NSButton* checkForUpdatesButton;
@property IBOutlet NSButton* openAtLoginButton;
@property IBOutlet NSButton* toggleMarginsButton;
@property (readonly) SDAccessibility* accessibility;

@end

@implementation SDPreferencesWindowController

@dynamic accessibility;

+ (instancetype) singleton {
    static id s;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s = [[self alloc] init];
    });
    return s;
}

- (IBAction) openAccessibility:(id)sender {
    [SDAccessibility openPanel];
}

- (IBAction) toggleUseWindowMargins:(id)sender {
    BOOL enabled = [sender state] == NSOnState;
    [SDPreferences setUsesWindowMargins: enabled];
}

- (IBAction) toggleOpenAtLogin:(id)sender {
    BOOL enabled = [sender state] == NSOnState;
    [SDOpenAtLogin setOpensAtLogin: enabled];
}

- (BOOL) showAccessibilityWarningIfNeeded {
    if (!self.accessibility.isEnabled) {
        [NSApp activateIgnoringOtherApps: YES];
        [self showWindow: nil];
    }
    
    return !self.accessibility.isEnabled;
}

- (SDAccessibility*) accessibility {
    return [SDAccessibility singleton];
}

- (NSString*) maybeEnableAccessibilityString {
    if (self.accessibility.isEnabled)
        return @"Accessibility is enabled. You're all set!";
    else
        return @"Enable Accessibility for AppGrid.";
}

- (NSImage*) isAccessibilityEnabledImage {
    if (self.accessibility.isEnabled)
        return [NSImage imageNamed:NSImageNameStatusAvailable];
    else
        return [NSImage imageNamed:NSImageNameStatusPartiallyAvailable];
}

+ (NSSet*) keyPathsForValuesAffectingMaybeEnableAccessibilityString {
    return [NSSet setWithArray:@[@"accessibility.isEnabled"]];
}

+ (NSSet*) keyPathsForValuesAffectingIsAccessibilityEnabledImage {
    return [NSSet setWithArray:@[@"accessibility.isEnabled"]];
}

- (NSString*) windowNibName {
    return @"PreferencesWindow";
}

- (void)windowDidLoad {
    [super windowDidLoad];
    
    self.alignAllToGridShortcutView.associatedUserDefaultsKey = MyAlignAllToGridShortcutKey;
    self.alignThisToGridShortcutView.associatedUserDefaultsKey = MyAlignThisToGridShortcutKey;
    
    self.moveNextScreenShortcutView.associatedUserDefaultsKey = MyMoveNextScreenShortcutKey;
    self.movePrevScreenShortcutView.associatedUserDefaultsKey = MyMovePrevScreenShortcutKey;
    
    self.moveLeftShortcutView.associatedUserDefaultsKey = MyMoveLeftShortcutKey;
    self.moveRightShortcutView.associatedUserDefaultsKey = MyMoveRightShortcutKey;
    
    self.growRightShortcutView.associatedUserDefaultsKey = MyGrowRightShortcutKey;
    self.shrinkRightShortcutView.associatedUserDefaultsKey = MyShrinkRightShortcutKey;
    
    self.increaseGridWidthShortcutView.associatedUserDefaultsKey = MyIncreaseGridWidthShortcutKey;
    self.decreaseGridWidthShortcutView.associatedUserDefaultsKey = MyDecreaseGridWidthShortcutKey;
    
    self.maximizeShortcutView.associatedUserDefaultsKey = MyMaximizeShortcutKey;
    
    self.focusWindowLeftShortcutView.associatedUserDefaultsKey = MyFocusWindowLeftShortcutKey;
    self.focusWindowRightShortcutView.associatedUserDefaultsKey = MyFocusWindowRightShortcutKey;
    self.focusWindowUpShortcutView.associatedUserDefaultsKey = MyFocusWindowUpShortcutKey;
    self.focusWindowDownShortcutView.associatedUserDefaultsKey = MyFocusWindowDownShortcutKey;
    
    self.shrinkToLowerRowShortcutView.associatedUserDefaultsKey = MyShrinkToLowerRowShortcutKey;
    self.shrinkToUpperRowShortcutView.associatedUserDefaultsKey = MyShrinkToUpperRowShortcutKey;
    self.fillEntireColumnShortcutView.associatedUserDefaultsKey = MyFillEntireColumnShortcutKey;
    
    [self.openAtLoginButton setState: [SDOpenAtLogin opensAtLogin] ? NSOnState : NSOffState];
    [self.toggleMarginsButton setState: [SDPreferences usesWindowMargins] ? NSOnState : NSOffState];
}

- (void) showWindow:(id)sender {
    if (![[self window] isVisible])
        [[self window] center];
    
    [super showWindow: sender];
}

- (void) resetKeysSheetDidEnd:(NSWindow *)sheet returnCode:(int)returnCode contextInfo:(void  *)contextInfo; {
    if (returnCode == NSAlertAlternateReturn) {
        NSDictionary* defaults = [NSDictionary dictionaryWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"defaults" withExtension:@"plist"]];
        for (NSString* key in defaults) {
            NSData* val = [defaults objectForKey:key];
            [[NSUserDefaults standardUserDefaults] setObject:val forKey:key];
        }
    }
}

- (IBAction) resetToDefaults:(id)sender {
    NSBeginAlertSheet(@"Really reset to the default keys?",
                      @"Do Nothing",
                      @"Reset Keys",
                      nil,
                      [sender window],
                      self,
                      @selector(resetKeysSheetDidEnd:returnCode:contextInfo:),
                      NULL,
                      NULL,
                      @"This will discard your custom AppGrid hot keys.");
}

@end
