#import <Foundation/Foundation.h>
#import "ASCPromise.h"

@interface ASCContext : NSObject
+ (instancetype)shared;
- (ASCPromise *)async:(id(^)())body;
@end
