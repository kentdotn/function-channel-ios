// Copyright © 2017 DWANGO Co., Ltd.

#import "TestClass.h"
#import <XCTest/XCTest.h>

@implementation TestClass

- (void)countUp
{
    NSLog(@"countUp");
    _count++;
}

- (void)countDown
{
    NSLog(@"countDown");
    _count--;
}

- (NSInteger)getCount
{
    NSLog(@"getCount: %ld", _count);
    return _count;
}

- (NSString*)getCountAsString
{
    NSLog(@"getCountAsString: \"count=%ld\"", _count);
    return [[NSString alloc] initWithFormat:@"count=%ld", _count];
}

- (float)getCountAsFloat
{
    NSLog(@"getCountAsFloat: %f", (float)_count);
    return (float)_count;
}

- (double)getCountAsDouble
{
    NSLog(@"getCountAsDouble: %f", (double)_count);
    return (double)_count;
}

- (int)getCountAsInt
{
    NSLog(@"getCountAsInt: %d", (int)_count);
    return (int)_count;
}

- (short)getCountAsShort
{
    NSLog(@"getCount: %d", (short)_count);
    return (short)_count;
}

- (char)getCountAsChar
{
    NSLog(@"getCount: %c", (char)_count);
    return (char)_count;
}

- (unsigned int)getCountAsUInt
{
    NSLog(@"getCountAsInt: %d", (int)_count);
    return (unsigned int)_count;
}

- (unsigned short)getCountAsUShort
{
    NSLog(@"getCount: %d", (short)_count);
    return (unsigned short)_count;
}

- (unsigned char)getCountAsUChar
{
    NSLog(@"getCount: %c", (char)_count);
    return (unsigned char)_count;
}

- (BOOL)isZero
{
    NSLog(@"isZero: %@", @(_count == 0));
    return _count == 0;
}

- (NSInteger)addNumber:(id)a:(id)b
{
    NSLog(@"addNumber: %@ + %@", a, b);
    return [a integerValue] + [b integerValue];
}

- (NSString*)addString:(NSString*)a:(NSString*)b
{
    return [[NSString alloc] initWithFormat:@"%@ wo %@", a, b];
}

- (void)protectMethod
{
    NSLog(@"protectedMethod execute!");
}

- (NSString*)addWithString1:(NSString*)str1 string2:(NSString*)str2 string3:(NSString*)str3
{
    return [[NSString alloc] initWithFormat:@"%@:%@:%@", str1, str2, str3];
}

- (CBBAsyncResult*)addStringAsyncSuccessWithA:(NSString*)a b:(NSString*)b
{
    return [CBBAsyncResult create:^(void (^_Nonnull done)(id _Nonnull)) {
        dispatch_async(dispatch_get_main_queue(), ^() {
            NSString* result = [[NSString alloc] initWithFormat:@"%@/%@", a, b];
            usleep(500 * 1000); // 500ms後に結果を返す
            NSLog(@"addStringAsyncSuccessWithAB will done");
            done(result);
        });
    }];
}

- (CBBAsyncResult*)addStringAsyncErrorWithA:(NSString*)a b:(NSString*)b
{
    return [CBBAsyncResult create:^(void (^_Nonnull done)(id _Nonnull)) {
        dispatch_async(dispatch_get_main_queue(), ^() {
            usleep(500 * 1000); // 500ms後に結果を返す
            NSLog(@"addStringAsyncErrorWithAB will done");
            done([[NSError alloc] init]);
        });
    }];
}

@end

@implementation SubTestClass

- (BOOL)subExport
{
    return YES;
}

@end
