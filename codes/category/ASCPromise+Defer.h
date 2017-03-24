#import "ASCPromise.h"

@interface ASCPromise (Defer)
- (ASCPromise *)defer:(NSTimeInterval)seconds;
@end
