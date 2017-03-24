#import "ASCContext.h"

@interface ASCContext ()
@property (nonatomic, strong) dispatch_queue_t queue;
@end

@implementation ASCContext

+ (instancetype)shared {
    static ASCContext *context;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        context = [[ASCContext alloc] init];
    });
    return context;
}

- (instancetype)init {
    if (self = [super init]) {
        _queue = dispatch_queue_create("context.queue", DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}


- (ASCPromise *)async:(id(^)())body {
    ASCPromise *promise = [[ASCPromise alloc] initWithBody:^(Resolved resolve, Rejector reject) {
        dispatch_async(self.queue, ^{
            resolve(body());
        });
    }];
    return promise;
}
@end
