#import "ASCPromise.h"

@interface ASCPromise (Then)
- (ASCPromise *)then:(void(^)(id))body;
- (ASCPromise *)map:(id(^)(id))body;
- (ASCPromise *)flatMap:(ASCPromise*(^)(id))body;
@end
