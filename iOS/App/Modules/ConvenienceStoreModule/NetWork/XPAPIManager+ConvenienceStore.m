//
//  XPAPIManager+ConvenienceStore.m
//  XPApp
//
//  Created by iiseeuu on 16/1/15.
//  Copyright © 2016年 ShareMerge. All rights reserved.
//

#import "XPAPIManager+ConvenienceStore.h"
#import "XPConvenienceStoreModel.h"
#import "NSString+XPAPI_ConvenienceStore.h"
#import "NSDictionary+XPAPIUserInfo.h"
#import "NSDictionary+XPAPIVerifyKey.h"
#import "XPAPIManager+Analysis.h"

@implementation XPAPIManager (ConvenienceStore)

- (RACSignal *)convenienceStoreListWithLastItemId:(NSString *)lastItemId
{
    NSDictionary *dic = [@{}
                         mutableCopy];
    if(lastItemId.length > 0) {
        
        [dic setValue:lastItemId forKey:@"cvs_item_id"];
    }
    return [[[[[self rac_GET:[NSString api_conveniencestore_path] parameters:[[dic
                                                                           fillUserInfo] fillVerifyKeyInfo]] map:^id (id value) {
        return [self analysisRequest:value];
    }] flattenMap:^RACStream *(id value) {
        if([value isKindOfClass:[NSError class]]) {
            return [RACSignal error:value];
        }
        return [self rac_MappingForClass:[XPConvenienceStoreModel class] array:value[@"cvs_items"]];
        
    }] logError] replayLazily];
    
}

@end
