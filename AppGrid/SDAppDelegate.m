#import "SDAppDelegate.h"
#import "SDWelcomeWindowController.h"
#import "SDPreferencesWindowController.h"
#import "SDAccessibility.h"
#import "SDGrid.h"

@interface SDAppDelegate ()

@property NSStatusItem* statusItem;
@property IBOutlet NSMenu* statusBarMenu;

@end

@implementation SDAppDelegate

- (void) loadStatusItem {
    NSImage* statusItemImage = [NSImage imageNamed:@"statusitem"];
    [statusItemImage setTemplate:YES];
    
    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSSquareStatusItemLength];
    [self.statusItem setImage:statusItemImage];
    [self.statusItem setHighlightMode:YES];
    [self.statusItem setMenu:self.statusBarMenu];
}

- (void) awakeFromNib {
    [self loadStatusItem];
}

- (IBAction) reallyShowAboutPanel:(id)sender {
    [NSApp activateIgnoringOtherApps:YES];
    [NSApp orderFrontStandardAboutPanel:sender];
}

- (IBAction) showHotKeysWindow:(id)sender {
    [NSApp activateIgnoringOtherApps:YES];
    [[SDPreferencesWindowController singleton] showWindow: sender];
}

- (void) setupDefaults {
    NSMutableDictionary* defaults = [[NSDictionary dictionaryWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"defaults" withExtension:@"plist"]] mutableCopy];
    [[NSUserDefaults standardUserDefaults] registerDefaults: defaults];
}

- (void) applicationDidFinishLaunching:(NSNotification *)aNotification {
    [self setupDefaults];
    [SDAccessibility setup];
    [SDGrid setup];
    [[SDPreferencesWindowController singleton] showAccessibilityWarningIfNeeded];
    [SDWelcomeWindowController showInstructionsWindowFirstTimeOnly];
}

@end

int main(int argc, char *argv[]) {
    return NSApplicationMain(argc, (const char **)argv);
}
