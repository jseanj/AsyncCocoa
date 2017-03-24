#import <Foundation/Foundation.h>

typedef void(^ResolveHandler)(id);
typedef void(^RejectHandler)(NSError*);

@interface ASCObserver : NSObject
@end

@interface ASCResolveObserver : ASCObserver
- (instancetype)initHandler:(ResolveHandler)handler on:(dispatch_queue_t)queue;
- (void)call:(id)value;
@end

@interface ASCRejectObserver : ASCObserver
- (instancetype)initHandler:(RejectHandler)handler on:(dispatch_queue_t)queue;
- (void)call:(NSError*)error;
@end
