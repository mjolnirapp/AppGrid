#import "SDPreferences.h"

#define MyGridWidthDefaultsKey @"MyGridWidthDefaultsKey"
#define MyUseWindowMarginsDefaultsKey @"MyUseWindowMarginsDefaultsKey"
#define MyWindowMarginsDefaultKey @"MyWindowMarginsDefaultKey"

@implementation SDPreferences

+ (NSInteger) width {
    return [[NSUserDefaults standardUserDefaults] integerForKey:MyGridWidthDefaultsKey];
}

+ (void) setWidth:(NSInteger)newWidth {
    [[NSUserDefaults standardUserDefaults] setInteger:newWidth forKey:MyGridWidthDefaultsKey];
}

+ (BOOL) usesWindowMargins {
    return [[NSUserDefaults standardUserDefaults] boolForKey:MyUseWindowMarginsDefaultsKey];
}

+ (void) setUsesWindowMargins:(BOOL)usesWindowMargins {
    [[NSUserDefaults standardUserDefaults] setBool:usesWindowMargins forKey:MyUseWindowMarginsDefaultsKey];
}

+ (NSInteger) windowMargins {
    return [[NSUserDefaults standardUserDefaults] integerForKey:MyWindowMarginsDefaultKey];
}

+ (void) setWindowMargins:(NSInteger)newWindowMargins {
    [[NSUserDefaults standardUserDefaults] setInteger:newWindowMargins forKey:MyWindowMarginsDefaultKey];
}

@end
