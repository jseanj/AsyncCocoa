#import "ASCObserver.h"

@implementation ASCObserver
@end

@interface ASCResolveObserver ()
@property (nonatomic, copy) ResolveHandler handler;
@property (nonatomic, strong) dispatch_queue_t queue;
@end

@implementation ASCResolveObserver

- (instancetype)initHandler:(ResolveHandler)handler on:(dispatch_queue_t)queue {
    if (self = [super init]) {
        _handler = handler;
        _queue = queue ? queue : dispatch_get_main_queue();
    }
    return self;
}

- (void)call:(id)value {
    dispatch_async(self.queue, ^{
        self.handler(value);
    });
}
@end

@interface ASCRejectObserver ()
@property (nonatomic, copy) RejectHandler handler;
@property (nonatomic, strong) dispatch_queue_t queue;
@end

@implementation ASCRejectObserver
- (instancetype)initHandler:(RejectHandler)handler on:(dispatch_queue_t)queue {
    if (self = [super init]) {
        _handler = handler;
        _queue = queue ? queue : dispatch_get_main_queue();
    }
    return self;
}
- (void)call:(NSError*)error {
    dispatch_async(self.queue, ^{
        self.handler(error);
    });
}
@end
