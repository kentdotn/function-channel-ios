// Copyright © 2017 DWANGO Co., Ltd.

#import "CBBAsyncResult.h"
#import "CBBRemoteExport.h"
#import <CBBDataChannel/CBBDataChannel.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString* const CBBFunctionChannelErrorDomain;

typedef NS_ENUM(NSUInteger, CBBFunctionChannelErrorType) {
    CBBFunctionChannelErrorTypeUnspecified,
    CBBFunctionChannelErrorTypeObjectNotBound,
    CBBFunctionChannelErrorTypeMethodNotExist
};

typedef void (^CBBFunctionChannelCallback)(NSError* _Nullable error, id _Nullable result);

@interface CBBFunctionChannel : NSObject
@property (readonly) BOOL destroyed;
- (instancetype)init UNAVAILABLE_ATTRIBUTE;
- (instancetype)initWithDataChannel:(CBBDataChannel*)dataChannel NS_DESIGNATED_INITIALIZER;
- (void)invokeWithInstanceId:(NSString*)instanceId
                      method:(NSString*)methodName;
- (void)invokeWithInstanceId:(NSString*)instanceId
                      method:(NSString*)methodName
                   arguments:(nullable NSArray*)arguments;
- (void)invokeWithInstanceId:(NSString*)instanceId
                      method:(NSString*)methodName
                   arguments:(nullable NSArray*)arguments
                    callback:(nullable CBBFunctionChannelCallback)callback;
- (void)invokeWithInstanceId:(NSString*)instanceId
                      method:(NSString*)methodName
                   arguments:(nullable NSArray*)arguments
                     timeout:(NSTimeInterval)timeout
                    callback:(nullable CBBFunctionChannelCallback)callback;
- (void)bindWithInstanceId:(NSString*)instanceId instance:(id)instance;
- (void)unbindWithInstanceId:(NSString*)instanceId;
- (void)destroy;
@end

NS_ASSUME_NONNULL_END
