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
    [self askForBeer];
}

- (void) askForBeer {
    NSUserNotification* note = [[NSUserNotification alloc] init];
    note.identifier = @"buyappgridbeer";
    
    note.title = @"AppGrid was made with ❤️ by Steven Degutis.";
    note.subtitle = @"It's open source and free and always will be.";
    note.informativeText = @"Finding it useful? Buy me a 🍺 via PayPal.";
    
    note.deliveryDate = [NSDate dateWithTimeIntervalSinceNow: 60 * 60 * 24];
    
    [NSUserNotificationCenter defaultUserNotificationCenter].delegate = self;
    [[NSUserNotificationCenter defaultUserNotificationCenter] scheduleNotification: note];
}

- (BOOL)userNotificationCenter:(NSUserNotificationCenter *)center shouldPresentNotification:(NSUserNotification *)notification {
    return YES;
}

- (void)userNotificationCenter:(NSUserNotificationCenter *)center didActivateNotification:(NSUserNotification *)notification {
    [center removeDeliveredNotification: notification];
    
    static NSString* DONATE_URL = @"https://www.paypal.com/cgi-bin/webscr?business=sbdegutis@gmail.com&cmd=_donations&item_name=AppGrid%20donation&no_shipping=1";
    [[NSWorkspace sharedWorkspace] openURL: [NSURL URLWithString: DONATE_URL]];
}

@end

int main(int argc, char *argv[]) {
    return NSApplicationMain(argc, (const char **)argv);
}
