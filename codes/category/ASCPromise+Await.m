#import "ASCPromise+Await.h"

@implementation ASCPromise (Await)
- (id)await {
    // 调用此方法必须在子线程上调用
    if ([NSThread isMainThread]) {
        return nil;
    }
    __block id result = nil;
    dispatch_semaphore_t signal = dispatch_semaphore_create(0);
    [self addResolveHandler:^(id value) {
        result = value;
        //        dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_semaphore_signal(signal);
        //        });
    } rejectHandler:^(NSError *error) {
        
    }];
    [self runBody];
    dispatch_semaphore_wait(signal, DISPATCH_TIME_FOREVER);
    return result;
}

@end
