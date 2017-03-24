#import <Foundation/Foundation.h>
#import "ASCObserver.h"

typedef NS_ENUM(NSUInteger, ASCState) {
    ASCStatePending = 0,
    ASCStateResolved = 1,
    ASCStateRejected = 2
};

typedef void(^Resolved)(id);
typedef void(^Rejector)(NSError*);
typedef void(^Body)(Resolved resolve, Rejector reject);

@interface ASCPromise : NSObject
@property (nonatomic, assign, readonly) ASCState state;
- (instancetype)initWithValue:(id)value;
- (instancetype)initWithError:(NSError *)error;
- (instancetype)initWithBody:(Body)body;

- (void)addResolveHandler:(ResolveHandler)resolveHandler rejectHandler:(RejectHandler)rejectHandler;
- (void)runBody;
@end
