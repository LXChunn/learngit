//
//  XPAPIManager+Announcement.m
//  XPApp
//
//  Created by iiseeuu on 15/12/18.
//  Copyright © 2015年 ShareMerge. All rights reserved.
//

#import "XPAPIManager+PropertyBill.h"

#import "NSDictionary+XPAPIUserInfo.h"
#import "NSDictionary+XPAPIVerifyKey.h"
#import "XPAPIManager+Analysis.h"
#import "NSString+XPAPI_PropertyBill.h"
#import "XPPropertyBillModel.h"

@implementation XPAPIManager (PropertyBill)

- (RACSignal *)propertyBillList
{
    return [[[[[self rac_GET:[NSString api_propertybill_path] parameters:[[@{} fillUserInfo] fillVerifyKeyInfo]] map:^id (id value) {
        return [self analysisRequest:value];
    }] flattenMap:^RACStream *(id value) {
        if([value isKindOfClass:[NSError class]]) {
            return [RACSignal error:value];
        }
        
        return [self rac_MappingForClass:[XPPropertyBillModel class] array:value[@"property_bills"]];
    }] logError] replayLazily];
}

@end
