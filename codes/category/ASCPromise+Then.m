#import "ASCPromise+Then.h"

@implementation ASCPromise (Then)
- (ASCPromise *)then:(void(^)(id))body {
    return [self then:body on:dispatch_get_main_queue()];
}

- (ASCPromise *)map:(id(^)(id))body {
    return [self map:body on:dispatch_get_main_queue()];
}

- (ASCPromise *)flatMap:(ASCPromise*(^)(id))body {
    return [self flatMap:body on:dispatch_get_main_queue()];
}

- (ASCPromise *)flatMap:(ASCPromise*(^)(id))body on:(dispatch_queue_t)queue {
    ASCPromise *promise = [[ASCPromise alloc] initWithBody:^(Resolved resolve, Rejector reject) {
        [self addResolveHandler:^(id value) {
            ASCPromise *nextPromise = body(value);
            [nextPromise addResolveHandler:^(id value) {
                resolve(value);
            } rejectHandler:^(NSError *error) {
                reject(error);
            }];
            [nextPromise runBody];
        } rejectHandler:^(NSError *error) {
            reject(error);
        }];
    }];
    [promise runBody];
    [self runBody];
    return promise;
}

- (ASCPromise *)map:(id(^)(id))body on:(dispatch_queue_t)queue {
    ASCPromise *promise = [[ASCPromise alloc] initWithBody:^(Resolved resolve, Rejector reject) {
        [self addResolveHandler:^(id value) {
            resolve(body(value));
        } rejectHandler:^(NSError *error) {
            reject(error);
        }];
    }];
    [promise runBody];
    [self runBody];
    return promise;
}

- (ASCPromise *)then:(void(^)(id))body on:(dispatch_queue_t)queue {
    ASCPromise *promise = [[ASCPromise alloc] initWithBody:^(Resolved resolve, Rejector reject) {
        [self addResolveHandler:^(id value) {
            body(value);
            resolve(value);
        } rejectHandler:^(NSError *error) {
            reject(error);
        }];
    }];
    [promise runBody];
    [self runBody];
    
    return promise;
}
@end
