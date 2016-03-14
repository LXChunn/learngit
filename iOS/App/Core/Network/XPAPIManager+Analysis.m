//
//  XPAPIManager+Analysis.m
//  Huaban
//
//  Created by huangxinping on 4/21/15.
//  Copyright (c) 2015 iiseeuu.com. All rights reserved.
//

#import "XPAPIManager+Analysis.h"

@implementation XPAPIManager (Analysis)

- (id)analysisRequest:(id)value
{
    if(![value isKindOfClass:[NSDictionary class]]) {
        return value;
    }
    
    NSUInteger statusCode = [[(NSDictionary *)value objectForKey:@"status_code"] integerValue];
    if(kXPAPIErrorUnknown == statusCode) {
        return value[@"data"];
    }
    else if (kXPAPIErrorSuccessButNoUse == statusCode){
        return value[@"msg"];
    }
    
    return [NSError errorWithDomain:kXPAPIErrorDomain code:statusCode userInfo:@{NSLocalizedDescriptionKey:value[@"msg"]}];
}

@end
