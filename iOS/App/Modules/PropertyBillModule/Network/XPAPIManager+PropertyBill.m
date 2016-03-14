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
#import "NSString+XPAPI_PropertyBill.h"
#import "XPAPIManager+Analysis.h"
#import "XPPropertyBillModel.h"

@implementation XPAPIManager (PropertyBill)

- (RACSignal *)propertyBillListWithStatus:(NSString *)status lastBillId:(NSString *)lastBillId{
    NSMutableDictionary *dic = [@{@"status":status}
                                mutableCopy];
    if(lastBillId.length > 0) {
        [dic setObject:lastBillId forKey:@"bill_id"];
    }
    return [[[[[self rac_GET:[NSString api_propertybill_path] parameters:[[dic fillUserInfo] fillVerifyKeyInfo]] map:^id (id value) {
        return [self analysisRequest:value];
    }] flattenMap:^RACStream *(id value) {
        if([value isKindOfClass:[NSError class]]) {
            return [RACSignal error:value];
        }
        return [self rac_MappingForClass:[XPPropertyBillModel class] array:value[@"property_bills"]];
    }] logError] replayLazily];
}

- (RACSignal *)propertyBillPaymentUrlBillId:(NSString *)billId{
    NSMutableDictionary *dic = [@{@"bill_id":billId}
                                mutableCopy];
    return [[[[[self rac_GET:[NSString api_billpayment_url_path] parameters:[[dic fillUserInfo] fillVerifyKeyInfo]] map:^id (id value) {
        return [self analysisRequest:value];
    }] flattenMap:^RACStream *(id value) {
        if([value isKindOfClass:[NSError class]]) {
            return [RACSignal error:value];
        }
        return [RACSignal return:value];
    }] logError] replayLazily];
}

- (RACSignal *)propertyBillPaymentResultWithBillId:(NSString *)billId{
    NSMutableDictionary *dic = [@{@"bill_id":billId}
                                mutableCopy];
    return [[[[[self rac_GET:[NSString api_billpayment_path] parameters:[[dic fillUserInfo] fillVerifyKeyInfo]] map:^id (id value) {
        return [self analysisRequest:value];
    }] flattenMap:^RACStream *(id value) {
        if([value isKindOfClass:[NSError class]]) {
            return [RACSignal error:value];
        }
        return [RACSignal return:value];
    }] logError] replayLazily];

}



@end
