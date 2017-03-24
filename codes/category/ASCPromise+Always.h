#import "ASCPromise.h"

@interface ASCPromise (Always)
- (ASCPromise *)always:(void(^)())body;
@end
