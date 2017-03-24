#import "ASCPromise+Defer.h"

@implementation ASCPromise (Defer)
- (ASCPromise *)defer:(NSTimeInterval)seconds {
    ASCPromise *promise = [[ASCPromise alloc] initWithBody:^(Resolved resolve, Rejector reject) {
        [self addResolveHandler:^(id value) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(seconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                resolve(value);
            });
        } rejectHandler:^(NSError *error) {
            reject(error);
        }];
    }];
    [promise runBody];
    [self runBody];
    return promise;
}
@end
