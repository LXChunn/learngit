//
//  NetworkLayer.m
//  XPApp
//
//  Created by xinpinghuang on 12/15/15.
//  Copyright © 2015 ShareMerge. All rights reserved.
//

#import "NSDictionary+XPAPISignature.h"
#import "NSDictionary+XPAPIVerifyKey.h"
#import "NSString+XPAPIPath.h"
#import <XCTest/XCTest.h>

@interface NetworkLayer : XCTestCase

@end

@implementation NetworkLayer

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testFillBaseAPI
{
    NSString *action = @"/v1/api/login";
    NSString *fullAction = [action fillBaseAPIPath];
    NSAssert([fullAction isEqualToString:@"http://112.4.10.20:9292/v1/api/login"], @"fillBaseAPIPath - 出错");
}

- (void)testFillBaseAPI2
{
    NSString *action = @"/v1/api/login";
    NSString *fullAction = [action fillBaseAPIPath2];
    NSAssert([fullAction isEqualToString:@"https://112.4.10.20:9292/v1/api/login"], @"fillBaseAPIPath - 出错");
}

- (void)testAPISignature
{
    //    NSDictionary *test = @{
    //                           @"user_id" : @"12",
    //                           @"timestamp" : @"1449908478"
    //                           };
    //    NSString *signature = [test signature];
    //    NSAssert([signature isEqualToString:@"ffdbad32f0ce6e277b9f4aba8323e438f40cd532"], @"testAPISignature - 参数签名失败");
}

- (void)testFilVerifyAPI
{
    //    NSDictionary *test = @{
    //                           @"nickname" : @"hellokitty",
    //                           @"gender" : @(1),
    //                           @"age" : @(23),
    //                           @"avatar_url" : @"http://www.xxx.com/avatar/83mdy26dadf.jpg"
    //                           };
    //    [test fillVerifyKeyInfo];
}

@end
