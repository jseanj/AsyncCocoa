#import "ASCPromise+Catch.h"

@implementation ASCPromise (Catch)
- (ASCPromise *)doCatch:(void(^)(NSError *))body {
    return [self doCatch:body on:dispatch_get_main_queue()];
}
- (ASCPromise *)doCatch:(void(^)(NSError *))body on:(dispatch_queue_t)queue {
    ASCPromise *promise = [[ASCPromise alloc] initWithBody:^(Resolved resolve, Rejector reject) {
        [self addResolveHandler:^(id value) {
            resolve(nil);
        } rejectHandler:^(NSError *error) {
            body(error);
            reject(error);
        }];
    }];
    [promise runBody];
    [self runBody];
    return promise;
}
@end
