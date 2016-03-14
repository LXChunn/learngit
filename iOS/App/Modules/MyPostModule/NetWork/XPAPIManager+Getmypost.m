//
//  XPAPIManager+Getmypost.m
//  XPApp
//
//  Created by CaoShunQing on 16/1/8.
//  Copyright © 2016年 ShareMerge. All rights reserved.
//

#import "NSDictionary+XPAPIUserInfo.h"
#import "NSDictionary+XPAPIVerifyKey.h"
#import "NSString+XPAPIPath_Getpost.h"
#import "XPAPIManager+Analysis.h"
#import "XPAPIManager+Getmypost.h"
#import "XPSecondHandItemsListModel.h"
#import "XPTopicModel.h"
#import "XPOtherForumModel.h"
#import "XPMyCarpoolModel.h"
#import <XPKit/XPKit.h>

@implementation XPAPIManager (Getmypost)

- (RACSignal *)getMyForumtopicsWithPageSize:(NSInteger)num lasttopicid:(NSString *)lasttopicId
{
    NSParameterAssert(num);
    NSMutableDictionary *dic = [@{@"page_size":@(20)}
                                mutableCopy];
    if(lasttopicId.length > 0) {
        [dic setObject:lasttopicId forKey:@"last_topic_id"];
    }
    
    NSString *path = [NSString api_my_forum_topics];
    return [[[[[self rac_GET:path parameters:[[dic fillUserInfo]                        fillVerifyKeyInfo]] map:^id (id value) {
        return [self analysisRequest:value];
    }] flattenMap:^RACStream *(id value) {
        if([value isKindOfClass:[NSError class]]) {
            return [RACSignal error:value];
        }
        
        return [self rac_MappingForClass:[XPTopicModel class] array:value[@"forum_topics"]];
    }] logError] replayLazily];
}

- (RACSignal *)getMyForumSecondHandtopicsWithPageSize:(NSInteger)num lastitemid:(NSString *)lastitemId
{
    //    NSParameterAssert(num);
    NSMutableDictionary *dic = [@{@"page_size":@(20)}
                                mutableCopy];
    if(lastitemId.length > 0) {
        [dic setObject:lastitemId forKey:@"last_item_id"];
    }
    
    NSString *path = [NSString api_my_secondhand_items];
    return [[[[[self rac_GET:path parameters:[[dic fillUserInfo]                        fillVerifyKeyInfo]] map:^id (id value) {
        return [self analysisRequest:value];
    }] flattenMap:^RACStream *(id value) {
        if([value isKindOfClass:[NSError class]]) {
            return [RACSignal error:value];
        }
        
        return [self rac_MappingForClass:[XPSecondHandItemsListModel class] array:value[@"secondhand_items"]];
    }] logError] replayLazily];
}

- (RACSignal *)getOtherForm:(NSString *)lastItemid
{
    NSMutableDictionary *dic = [@{} mutableCopy];
    if(lastItemid.length > 0) {
        [dic setObject:lastItemid forKey:@"last_item_id"];
    }
    
    NSString *path = [NSString api_my_other_post];
    return [[[[[self rac_GET:path parameters:[[dic fillUserInfo]                        fillVerifyKeyInfo]] map:^id (id value) {
        return [self analysisRequest:value];
    }] flattenMap:^RACStream *(id value) {
        if([value isKindOfClass:[NSError class]]) {
            return [RACSignal error:value];
        }
        
        return [self rac_MappingForClass:[XPOtherForumModel class] array:value[@"other_items"]];
    }] logError] replayLazily];
}

//- (RACSignal *)getMyCarpoolDetail:(NSString *)lastItemId
//{
//    NSMutableDictionary *dic = [@{} mutableCopy];
//    if(lastItemId.length > 0) {
//        [dic setObject:lastItemId forKey:@"carpooling_item_id"];
//    }
//    
//    NSString *path = [NSString api_my_carpooling];
//    return [[[[[self rac_GET:path parameters:[[dic fillUserInfo]                        fillVerifyKeyInfo]] map:^id (id value) {
//        return [self analysisRequest:value];
//    }] flattenMap:^RACStream *(id value) {
//        if([value isKindOfClass:[NSError class]]) {
//            return [RACSignal error:value];
//        }
//        
//        return [self rac_MappingForClass:[XPMyCarpoolModel class] array:value[@"other_items"]];
//    }] logError] replayLazily];
//}
@end
