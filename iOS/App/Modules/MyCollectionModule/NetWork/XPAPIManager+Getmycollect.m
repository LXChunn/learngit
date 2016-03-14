//
//  XPAPIManager+Getmycollect.m
//  XPApp
//
//  Created by CaoShunQing on 16/1/8.
//  Copyright © 2016年 ShareMerge. All rights reserved.
//

#import "NSDictionary+XPAPIUserInfo.h"
#import "NSDictionary+XPAPIVerifyKey.h"
#import "NSString+XPMyCollectionPath.h"
#import "XPAPIManager+Analysis.h"
#import "XPAPIManager+Getmycollect.h"
#import "XPSecondHandItemsListModel.h"
#import "XPTopicModel.h"
#import "XPOtherFavoriateModel.h"
#import <XPKit.h>

@implementation XPAPIManager (Getmycollect)

- (RACSignal *)getMyFavoriteWithType:(NSString *)type pagerSize:(NSInteger)pagesize lastItemId:(NSString *)lid
{
    NSParameterAssert(type);
    NSParameterAssert(pagesize);
    NSMutableDictionary *parameters = [@{@"type":type}
                                       mutableCopy];
    if(lid.length > 0) {
        [parameters setObject:lid forKey:@"last_item_id"];
    }
    
    return [[[[[self rac_GET:[NSString api_my_favorites] parameters:[[parameters
                                                                      fillUserInfo]                        fillVerifyKeyInfo]] map:^id (id value) {
        return [self analysisRequest:value];
    }] flattenMap:^RACStream *(id value) {
        if([value isKindOfClass:[NSError class]]) {
            return [RACSignal error:value];
        }
        if([type isEqualToString:@"1"]) {
            return [self rac_MappingForClass:[XPTopicModel class] array:value[@"forum_topics"]];
        } else if([type isEqualToString:@"2"]){
            return [self rac_MappingForClass:[XPSecondHandItemsListModel class] array:value[@"secondhand_items"]];
        }else{
            return [self rac_MappingForClass:[XPOtherFavoriateModel class] array:value[@"favorite_items"]];
        }
    }] logError] replayLazily];
}

@end
