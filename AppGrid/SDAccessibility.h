#import <Foundation/Foundation.h>

@interface SDAccessibility : NSObject

+ (void) openPanel;
+ (instancetype) singleton;

// yes, this is intentionally a @property, because we using bindings with it
@property BOOL isEnabled;

+ (void) setup;

@end
