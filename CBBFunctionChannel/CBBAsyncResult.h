// Copyright © 2017 DWANGO Co., Ltd.

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^CBBAsyncCompletionHandler)(id result);
typedef void (^CBBAsyncResultHandler)(void (^done)(id result));

@interface CBBAsyncResult : NSObject
- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)create:(CBBAsyncResultHandler)handler;
- (CBBAsyncResult* (^)(CBBAsyncCompletionHandler))onComplete;
- (void)execute;
@end

NS_ASSUME_NONNULL_END
