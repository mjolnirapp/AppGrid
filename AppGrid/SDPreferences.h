#import <Foundation/Foundation.h>

@interface SDPreferences : NSObject

+ (NSInteger) width;
+ (void) setWidth:(NSInteger)newWidth;

+ (BOOL) usesWindowMargins;
+ (void) setUsesWindowMargins:(BOOL)usesWindowMargins;

@end
