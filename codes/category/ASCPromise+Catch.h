#import "ASCPromise.h"

@interface ASCPromise (Catch)
- (ASCPromise *)doCatch:(void(^)(NSError *))body;
@end
