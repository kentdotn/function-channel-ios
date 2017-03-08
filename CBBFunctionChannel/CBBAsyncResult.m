// Copyright © 2017 DWANGO Co., Ltd.

#import "CBBAsyncResult.h"

NS_ASSUME_NONNULL_BEGIN

@interface CBBAsyncResult ()
@property (nonatomic, copy) CBBAsyncCompletionHandler completionHandler;
@property (nonatomic, copy) CBBAsyncResultHandler resultHandler;
@property (readwrite) dispatch_queue_t queue;
@end

@implementation CBBAsyncResult

+ (instancetype)create:(CBBAsyncResultHandler)handler
{
    return [[CBBAsyncResult alloc] initWithHandler:handler
                                             queue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
}

+ (instancetype)create:(CBBAsyncResultHandler)handler
                 queue:(dispatch_queue_t)queue
{
    return [[CBBAsyncResult alloc] initWithHandler:handler
                                             queue:queue];
}

- (CBBAsyncResult* (^)(CBBAsyncCompletionHandler))onComplete
{
    return ^(CBBAsyncCompletionHandler handler) {
        _completionHandler = handler;
        return self;
    };
}

#pragma mark - Private

- (instancetype)initWithHandler:(CBBAsyncResultHandler)handler
                          queue:(dispatch_queue_t)queue
{
    if (self = [super init]) {
        _resultHandler = handler;
        _queue = queue;
    }
    return self;
}

- (void)execute
{
    dispatch_async(_queue, ^{
        _resultHandler(^(id result) {
            _completionHandler(result);
        });
    });
}

@end

NS_ASSUME_NONNULL_END
