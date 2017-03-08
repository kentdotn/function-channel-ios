// Copyright © 2017 DWANGO Co., Ltd.

#import "CBBRemoteExport.h"
#import "CBBRemoteExportUtility.h"
#import <objc/runtime.h>

@implementation CBBRemoteExportUtility

+ (NSDictionary<NSString*, NSString*>*)exportRemoteExportMethodTableFromClass:(Class)cls
{
    NSArray* protocols = [CBBRemoteExportUtility protocolsConformsToPortocol:@protocol(CBBRemoteExport) class:cls];
    NSArray* methods = [CBBRemoteExportUtility methodsConformsToProtocolNames:protocols];
    NSDictionary* result = [self remoteExportMethodTableFromMethodNames:methods];
    return result;
}

+ (NSDictionary<NSString*, NSString*>*)remoteExportMethodTableFromMethodNames:(NSArray*)methodNames
{
    NSMutableDictionary* result = [NSMutableDictionary dictionary];
    [methodNames enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL* _Nonnull stop) {
        NSRange range = [obj rangeOfString:@"__CBB_REMOTE_EXPORT_AS__"];
        if (range.location == NSNotFound) {
            NSString* keyMethodName = ^() {
                NSMutableArray<NSString*>* array = [[obj componentsSeparatedByString:@":"] mutableCopy];
                for (int i = 0; i < array.count; ++i) {
                    array[i] = i ? array[i].capitalizedString : array[i];
                }
                return [array componentsJoinedByString:@""];
            }();
            result[keyMethodName] = obj;
        } else {
            NSString* originalMethodName = [obj substringToIndex:range.location];
            NSString* aliasMethodName = [obj substringFromIndex:range.location + range.length];
            result[[aliasMethodName substringToIndex:aliasMethodName.length - 1]] = originalMethodName;
        }
    }];
    return result;
}

+ (NSArray<NSString*>*)methodsConformsToProtocolNames:(NSArray*)protocolNames
{
    NSMutableArray* result = [NSMutableArray array];
    for (NSString* protocolName in protocolNames) {
        Protocol* protocol = NSProtocolFromString(protocolName);
        unsigned int count = 0;
        struct objc_method_description* required_method_descriptions = protocol_copyMethodDescriptionList(protocol, YES, YES, &count);
        for (unsigned int i = 0; i < count; ++i) {
            [result addObject:NSStringFromSelector(required_method_descriptions[i].name)];
        }
        free(required_method_descriptions);
        count = 0;
        struct objc_method_description* optional_method_descriptions = protocol_copyMethodDescriptionList(protocol, NO, YES, &count);
        for (unsigned int i = 0; i < count; ++i) {
            [result addObject:NSStringFromSelector(optional_method_descriptions[i].name)];
        }
        free(optional_method_descriptions);
    }
    return result;
}

+ (NSArray<NSString*>*)protocolsConformsToPortocol:(Protocol*)protocol class:(Class)cls
{
    NSMutableArray* result = [NSMutableArray array];
    if ([cls conformsToProtocol:protocol]) {
        unsigned int count = 0;
        Protocol* __unsafe_unretained* adops = class_copyProtocolList(cls, &count);
        for (unsigned int i = 0; i < count; ++i) {
            if (protocol_conformsToProtocol(adops[i], protocol)) {
                [result addObject:[NSString stringWithFormat:@"%s", protocol_getName(adops[i])]];
            }
        }
        free(adops);
    }
    return result;
}

@end
