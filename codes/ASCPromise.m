#import "ASCPromise.h"

@interface ASCPromise ()
@property (nonatomic, strong) dispatch_queue_t queue;
@property (nonatomic, strong) NSMutableArray<ASCObserver*> *observers;
@property (nonatomic, assign, readwrite) ASCState state;
@property (nonatomic, copy) Body body;
@property (nonatomic, strong) id value;
@property (nonatomic, strong) NSError *error;
@property (nonatomic, assign) BOOL bodyCalled;
@end

@implementation ASCPromise
- (instancetype)initWithValue:(id)value {
    if (self = [super init]) {
        _state = ASCStateResolved;
        _bodyCalled = YES;
        _queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
        _observers = [NSMutableArray new];
    }
    return self;
}
- (instancetype)initWithError:(NSError *)error {
    if (self = [super init]) {
        _state = ASCStateRejected;
        _bodyCalled = YES;
        _queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
        _observers = [NSMutableArray new];
    }
    return self;
}
- (instancetype)initWithBody:(Body)body {
    return [self initWithBody:body on:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)];
}

- (instancetype)initWithBody:(Body)body on:(dispatch_queue_t)queue {
    if (self = [super init]) {
        _state = ASCStatePending;
        _bodyCalled = NO;
        _queue = queue;
        _body = body;
        _observers = [NSMutableArray new];
    }
    return self;
}

- (void)setState:(ASCState)state {
    _state = state;
    for (ASCObserver *observer in self.observers) {
        if (state == ASCStateResolved && [observer isKindOfClass:[ASCResolveObserver class]]) {
            [(ASCResolveObserver*)observer call:self.value];
        }
        if (state == ASCStateRejected && [observer isKindOfClass:[ASCRejectObserver class]]) {
            [(ASCRejectObserver*)observer call:self.error];
        }
    }
}

- (void)addResolveHandler:(ResolveHandler)resolveHandler rejectHandler:(RejectHandler)rejectHandler {
    [self addResolveHandler:resolveHandler rejectHandler:rejectHandler on:dispatch_get_main_queue()];
}

- (void)addResolveHandler:(ResolveHandler)resolveHandler rejectHandler:(RejectHandler)rejectHandler on:(dispatch_queue_t)queue {
    ASCResolveObserver *resolveObserver = [[ASCResolveObserver alloc] initHandler:resolveHandler on:queue];
    ASCRejectObserver *rejectObserver = [[ASCRejectObserver alloc] initHandler:rejectHandler on:queue];
    [self addObservers:@[resolveObserver, rejectObserver]];
}

- (void)addObservers:(NSArray *)observers {
    [self.observers addObjectsFromArray:observers];
    if (self.state == ASCStatePending) {
        return;
    }
    for (ASCObserver *observer in self.observers) {
        if (self.state == ASCStateResolved && [observer isKindOfClass:[ASCResolveObserver class]]) {
            [(ASCResolveObserver*)observer call:self.value];
        }
        if (self.state == ASCStateRejected && [observer isKindOfClass:[ASCRejectObserver class]]) {
            [(ASCRejectObserver*)observer call:self.error];
        }
    }
}

- (void)runBody {
    if (self.state != ASCStatePending || self.bodyCalled) {
        return;
    }
    self.bodyCalled = YES;
    dispatch_async(self.queue, ^{
        self.body(^(id value) {
            self.value = value;
            self.state = ASCStateResolved;
        }, ^(NSError *error) {
            self.error = error;
            self.state = ASCStateRejected;
        });
    });
}
@end

