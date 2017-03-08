// Copyright © 2017 DWANGO Co., Ltd.

#import <Foundation/Foundation.h>

@interface CBBRemoteExportUtility : NSObject
+ (NSDictionary<NSString*, NSString*>*)exportRemoteExportMethodTableFromClass:(Class)cls;
@end
