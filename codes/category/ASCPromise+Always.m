#import "ASCPromise+Always.h"

@implementation ASCPromise (Always)
- (ASCPromise *)always:(void(^)())body {
    return [self always:body on:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)];
}

- (ASCPromise *)always:(void(^)())body on:(dispatch_queue_t)queue {
    ASCPromise *promise = [[ASCPromise alloc] initWithBody:^(Resolved resolve, Rejector reject) {
        [self addResolveHandler:^(id value) {
            body();
            resolve(value);
        } rejectHandler:^(NSError *error) {
            body();
            reject(error);
        }];
    }];
    [promise runBody];
    [self runBody];
    return promise;
}
@end
