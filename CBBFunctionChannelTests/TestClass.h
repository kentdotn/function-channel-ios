// Copyright © 2017 DWANGO Co., Ltd.

#import "CBBAsyncResult.h"
#import "CBBRemoteExport.h"
#import <Foundation/Foundation.h>

@protocol TestClassExport <CBBRemoteExport>
- (void)countUp;
- (void)countDown;
- (NSInteger)getCount;
- (NSString*)getCountAsString;
- (BOOL)isZero;
- (float)getCountAsFloat;
- (double)getCountAsDouble;
- (int)getCountAsInt;
- (short)getCountAsShort;
- (char)getCountAsChar;
- (unsigned int)getCountAsUInt;
- (unsigned short)getCountAsUShort;
- (unsigned char)getCountAsUChar;
- (NSInteger)addNumber:(id)a:(id)b;
- (NSString*)addString:(NSString*)a:(NSString*)b;
- (NSString*)addWithString1:(NSString*)str1 string2:(NSString*)str2 string3:(NSString*)str3;
- (CBBAsyncResult*)addStringAsyncSuccessWithA:(NSString*)a b:(NSString*)b;
- (CBBAsyncResult*)addStringAsyncErrorWithA:(NSString*)a b:(NSString*)b;
@end

@interface TestClass : NSObject <TestClassExport>
@property (readwrite) NSInteger count;
@end
