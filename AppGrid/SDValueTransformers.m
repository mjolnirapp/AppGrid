#import <Foundation/Foundation.h>

@interface SDStringNotEmptyValueTransformer : NSValueTransformer
@end
@implementation SDStringNotEmptyValueTransformer
+ (Class)transformedValueClass { return [NSString class]; }
+ (BOOL)allowsReverseTransformation { return NO; }
- (id)transformedValue:(NSString*)value {
    return @([[value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] > 0);
}
@end
