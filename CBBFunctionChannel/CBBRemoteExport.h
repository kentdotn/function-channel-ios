// Copyright © 2017 DWANGO Co., Ltd.

#import <Foundation/Foundation.h>

@protocol CBBRemoteExport <NSObject>
@end

#define CBBRemoteExportAs(PropertyName, Selector)                   \
    @optional                                                       \
    Selector __CBB_REMOTE_EXPORT_AS__##PropertyName : (id)argument; \
    @required                                                       \
    Selector
