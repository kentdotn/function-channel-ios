// Copyright © 2017 DWANGO Co., Ltd.

#import "CBBFunctionChannel.h"
#import "TestClass.h"
#import <CBBDataBus/CBBMemoryQueueDataBus.h>
#import <XCTest/XCTest.h>

@interface CBBFunctionChannelTests : XCTestCase
@property (atomic) CBBFunctionChannel* funcChA;
@property (atomic) CBBFunctionChannel* funcChB;
@property (atomic) NSInteger counter;
@end

@implementation CBBFunctionChannelTests

- (void)setUp
{
    [super setUp];
    CBBMemoryQueue* mqA = [[CBBMemoryQueue alloc] init];
    CBBMemoryQueue* mqB = [[CBBMemoryQueue alloc] init];
    CBBDataBus* dataBusA = [[CBBMemoryQueueDataBus alloc] initWithSender:mqA receiver:mqB];
    CBBDataBus* dataBusB = [[CBBMemoryQueueDataBus alloc] initWithSender:mqB receiver:mqA];
    CBBDataChannel* dataChA = [[CBBDataChannel alloc] initWithDataBus:dataBusA];
    CBBDataChannel* dataChB = [[CBBDataChannel alloc] initWithDataBus:dataBusB];
    _funcChA = [[CBBFunctionChannel alloc] initWithDataChannel:dataChA];
    _funcChB = [[CBBFunctionChannel alloc] initWithDataChannel:dataChB];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testFunctionChannel
{
    TestClass* testA = [[TestClass alloc] init];
    TestClass* testB = [[TestClass alloc] init];
    [_funcChA bindWithInstanceId:@"ins:A" instance:testA];
    [_funcChB bindWithInstanceId:@"ins:B" instance:testB];

    NSLog(@"[正常系] 引数+戻り値が無いメソッド実行");
    [_funcChA invokeWithInstanceId:@"ins:B"
                            method:@"countUp"
                         arguments:nil
                          callback:^(NSError* _Nullable error, id _Nullable result) {
                              NSLog(@"error: %@, result: %@", error, result);
                              XCTAssertNil(error);
                              XCTAssertEqual(result, [NSNull null]);
                          }];
    XCTAssertEqual(0, testA.count);
    XCTAssertEqual(1, testB.count);

    NSLog(@"[正常系] 引数+戻り値が無いメソッドを連続実行");
    [_funcChB invokeWithInstanceId:@"ins:A" method:@"countUp" arguments:nil callback:nil];
    [_funcChB invokeWithInstanceId:@"ins:A"
                            method:@"countUp"
                         arguments:nil
                          callback:^(NSError* _Nullable error, id _Nullable result) {
                              XCTAssertNil(error);
                              XCTAssertEqual(result, [NSNull null]);
                          }];
    XCTAssertEqual(2, testA.count);
    XCTAssertEqual(1, testB.count);

    NSLog(@"[正常系] 戻り値だけ有るメソッド実行 (NSInteger型)");
    [_funcChA invokeWithInstanceId:@"ins:B"
                            method:@"getCount"
                         arguments:nil
                          callback:^(NSError* _Nullable error, id _Nullable result) {
                              XCTAssertNil(error);
                              XCTAssertEqual([result integerValue], 1);
                              [testA countDown]; // ここを通過したこのと検証のため A をカウントダウンしておく
                          }];
    XCTAssertEqual(testA.count, 1);
    XCTAssertEqual(testB.count, 1);
    [testA countDown];

    NSLog(@"[正常系] 戻り値だけ有るメソッド実行 (NSString*型)");
    [_funcChA invokeWithInstanceId:@"ins:B"
                            method:@"getCountAsString"
                         arguments:nil
                          callback:^(NSError* _Nullable error, id _Nullable result) {
                              XCTAssertNil(error);
                              NSString* resultString = result;
                              XCTAssertTrue([resultString isEqualToString:@"count=1"]);
                              [testA countDown]; // ここを通過したこのと検証のため A をカウントダウンしておく
                          }];
    XCTAssertEqual(testA.count, -1);
    XCTAssertEqual(testB.count, 1);
    [testB countDown]; // B を 0 にしておく

    NSLog(@"[正常系] 戻り値だけ有るメソッド実行 (BOOL型: expects YES)");
    [_funcChA invokeWithInstanceId:@"ins:B"
                            method:@"isZero"
                         arguments:nil
                          callback:^(NSError* _Nullable error, id _Nullable result) {
                              XCTAssertNil(error);
                              XCTAssertTrue([result boolValue]);
                              [testA countDown]; // ここを通過したこのと検証のため A をカウントダウンしておく
                          }];
    XCTAssertEqual(testA.count, -2);
    XCTAssertEqual(testB.count, 0);

    NSLog(@"[正常系] 戻り値だけ有るメソッド実行 (BOOL型: expects NO)");
    [_funcChB invokeWithInstanceId:@"ins:A"
                            method:@"isZero"
                         arguments:nil
                          callback:^(NSError* _Nullable error, id _Nullable result) {
                              XCTAssertNil(error);
                              XCTAssertFalse([result boolValue]);
                              [testA countDown]; // ここを通過したこのと検証のため A をカウントダウンしておく
                          }];
    XCTAssertEqual(testA.count, -3);
    XCTAssertEqual(testB.count, 0);

    NSLog(@"[正常系] 戻り値だけ有るメソッド実行 (flaot型)");
    [_funcChB invokeWithInstanceId:@"ins:A"
                            method:@"getCountAsFloat"
                         arguments:nil
                          callback:^(NSError* _Nullable error, id _Nullable result) {
                              XCTAssertNil(error);
                              XCTAssertEqual([result floatValue], -3.0f);
                              [testA countDown]; // ここを通過したこのと検証のため A をカウントダウンしておく
                          }];
    XCTAssertEqual(testA.count, -4);
    XCTAssertEqual(testB.count, 0);

    NSLog(@"[正常系] 戻り値だけ有るメソッド実行 (double型)");
    [_funcChB invokeWithInstanceId:@"ins:A"
                            method:@"getCountAsDouble"
                         arguments:nil
                          callback:^(NSError* _Nullable error, id _Nullable result) {
                              XCTAssertNil(error);
                              XCTAssertEqual([result doubleValue], -4.0);
                              [testA countDown]; // ここを通過したこのと検証のため A をカウントダウンしておく
                          }];
    XCTAssertEqual(testA.count, -5);
    XCTAssertEqual(testB.count, 0);

    NSLog(@"[正常系] 戻り値だけ有るメソッド実行 (int型)");
    [_funcChB invokeWithInstanceId:@"ins:A"
                            method:@"getCountAsInt"
                         arguments:nil
                          callback:^(NSError* _Nullable error, id _Nullable result) {
                              XCTAssertNil(error);
                              XCTAssertEqual([result intValue], -5);
                              [testA countDown]; // ここを通過したこのと検証のため A をカウントダウンしておく
                          }];
    XCTAssertEqual(testA.count, -6);
    XCTAssertEqual(testB.count, 0);

    NSLog(@"[正常系] 戻り値だけ有るメソッド実行 (short型)");
    [_funcChB invokeWithInstanceId:@"ins:A"
                            method:@"getCountAsShort"
                         arguments:nil
                          callback:^(NSError* _Nullable error, id _Nullable result) {
                              XCTAssertNil(error);
                              XCTAssertEqual([result shortValue], -6);
                              [testA countDown]; // ここを通過したこのと検証のため A をカウントダウンしておく
                          }];
    XCTAssertEqual(testA.count, -7);
    XCTAssertEqual(testB.count, 0);

    NSLog(@"[正常系] 戻り値だけ有るメソッド実行 (char型)");
    [_funcChB invokeWithInstanceId:@"ins:A"
                            method:@"getCountAsChar"
                         arguments:nil
                          callback:^(NSError* _Nullable error, id _Nullable result) {
                              XCTAssertNil(error);
                              XCTAssertEqual([result charValue], -7);
                              [testA countDown]; // ここを通過したこのと検証のため A をカウントダウンしておく
                          }];
    XCTAssertEqual(testA.count, -8);
    XCTAssertEqual(testB.count, 0);

    NSLog(@"[正常系] 戻り値だけ有るメソッド実行 (unsigned int型)");
    [_funcChB invokeWithInstanceId:@"ins:A"
                            method:@"getCountAsUInt"
                         arguments:nil
                          callback:^(NSError* _Nullable error, id _Nullable result) {
                              XCTAssertNil(error);
                              XCTAssertEqual([result unsignedIntValue], (unsigned int)-8);
                              [testA countDown]; // ここを通過したこのと検証のため A をカウントダウンしておく
                          }];
    XCTAssertEqual(testA.count, -9);
    XCTAssertEqual(testB.count, 0);

    NSLog(@"[正常系] 戻り値だけ有るメソッド実行 (unsigned short型)");
    [_funcChB invokeWithInstanceId:@"ins:A"
                            method:@"getCountAsUShort"
                         arguments:nil
                          callback:^(NSError* _Nullable error, id _Nullable result) {
                              XCTAssertNil(error);
                              XCTAssertEqual([result unsignedShortValue], (unsigned short)-9);
                              [testA countDown]; // ここを通過したこのと検証のため A をカウントダウンしておく
                          }];
    XCTAssertEqual(testA.count, -10);
    XCTAssertEqual(testB.count, 0);

    NSLog(@"[正常系] 戻り値だけ有るメソッド実行 (unsigned char型)");
    [_funcChB invokeWithInstanceId:@"ins:A"
                            method:@"getCountAsUChar"
                         arguments:nil
                          callback:^(NSError* _Nullable error, id _Nullable result) {
                              XCTAssertNil(error);
                              XCTAssertEqual([result unsignedCharValue], (unsigned char)-10);
                              [testA countDown]; // ここを通過したこのと検証のため A をカウントダウンしておく
                          }];
    XCTAssertEqual(testA.count, -11);
    XCTAssertEqual(testB.count, 0);

    NSLog(@"[正常系] 引数+戻り値ありのメソッド実行 (数値型)");
    [_funcChB invokeWithInstanceId:@"ins:A"
                            method:@"addNumber"
                         arguments:@[ @(2525), @(4649) ]
                          callback:^(NSError* _Nullable error, id _Nullable result) {
                              XCTAssertNil(error);
                              XCTAssertEqual([result integerValue], 7174);
                              [testA countDown]; // ここを通過したこのと検証のため A をカウントダウンしておく
                          }];
    XCTAssertEqual(testA.count, -12);
    XCTAssertEqual(testB.count, 0);

    NSLog(@"[正常系] 引数+戻り値ありのメソッド実行 (NSString*型)");
    [_funcChB invokeWithInstanceId:@"ins:A"
                            method:@"addString"
                         arguments:@[ @(2525), @(4649) ]
                          callback:^(NSError* _Nullable error, id _Nullable result) {
                              XCTAssertNil(error);
                              NSString* resultString = result;
                              XCTAssertTrue([resultString isEqualToString:@"2525 wo 4649"]);
                              [testA countDown]; // ここを通過したこのと検証のため A をカウントダウンしておく
                          }];
    XCTAssertEqual(testA.count, -13);
    XCTAssertEqual(testB.count, 0);

    NSLog(@"[異常系] exportしていないが存在するメソッドを呼び出す");
    [_funcChB invokeWithInstanceId:@"ins:A"
                            method:@"protectMethod"
                         arguments:@[ @(2525), @(4649) ]
                          callback:^(NSError* _Nullable error, id _Nullable result) {
                              XCTAssertNotNil(error);
                              [testA countDown]; // ここを通過したこのと検証のため A をカウントダウンしておく
                          }];
    XCTAssertEqual(testA.count, -14);
    XCTAssertEqual(testB.count, 0);

    NSLog(@"[異常系] 存在しないメソッドを呼び出す");
    [_funcChB invokeWithInstanceId:@"ins:A"
                            method:@"notExitMethod"
                         arguments:@[ @(2525), @(4649) ]
                          callback:^(NSError* _Nullable error, id _Nullable result) {
                              XCTAssertNotNil(error);
                              [testA countDown]; // ここを通過したこのと検証のため A をカウントダウンしておく
                          }];
    XCTAssertEqual(testA.count, -15);
    XCTAssertEqual(testB.count, 0);

    NSLog(@"[異常系] 存在しないインスタンスIDを指定");
    [_funcChB invokeWithInstanceId:@"ins:C"
                            method:@"addString"
                         arguments:@[ @(2525), @(4649) ]
                          callback:^(NSError* _Nullable error, id _Nullable result) {
                              XCTAssertNotNil(error);
                              [testA countDown]; // ここを通過したこのと検証のため A をカウントダウンしておく
                          }];
    XCTAssertEqual(testA.count, -16);
    XCTAssertEqual(testB.count, 0);

    NSLog(@"[正常系] 第2引数(以降)にキーワードを付与したメソッドを実装する場合");
    [_funcChB invokeWithInstanceId:@"ins:A"
                            method:@"addWithString1String2String3"
                         arguments:@[ @(2525), @(4649), @"ne" ]
                          callback:^(NSError* _Nullable error, id _Nullable result) {
                              XCTAssertNil(error);
                              NSString* resultString = result;
                              XCTAssertTrue([resultString isEqualToString:@"2525:4649:ne"]);
                              [testA countDown]; // ここを通過したこのと検証のため A をカウントダウンしておく
                          }];
    XCTAssertEqual(testA.count, -17);
    XCTAssertEqual(testB.count, 0);

    NSLog(@"[正常系] 非同期メソッドを実行");
    XCTestExpectation* async1Expect = [self expectationWithDescription:@"Waiting for aysnc1"];
    [_funcChB invokeWithInstanceId:@"ins:A"
                            method:@"addStringAsyncSuccessWithAB"
                         arguments:@[ @(2525), @(4649) ]
                          callback:^(NSError* _Nullable error, id _Nullable result) {
                              XCTAssertNil(error);
                              NSString* resultString = result;
                              XCTAssertTrue([resultString isEqualToString:@"2525/4649"]);
                              [testA countDown]; // ここを通過したこのと検証のため A をカウントダウンしておく
                              [async1Expect fulfill];
                          }];
    XCTAssertEqual(testA.count, -17); // 実行直後は値が変わっていない
    [self waitForExpectationsWithTimeout:1
                                 handler:^(NSError* error) {
                                     XCTAssertEqual(testA.count, -18);
                                 }];
}

@end
