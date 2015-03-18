#import "SDPreferences.h"

#define MyGridWidthDefaultsKey @"MyGridWidthDefaultsKey"
#define MyUseWindowMarginsDefaultsKey @"MyUseWindowMarginsDefaultsKey"

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

@end
