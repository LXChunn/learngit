//
//  XPAPIManager+SecondHand.m
//  XPApp
//
//  Created by jy on 15/12/29.
//  Copyright 2015年 ShareMerge. All rights reserved.
//

#import "NSDictionary+XPAPIUserInfo.h"
#import "NSDictionary+XPAPIVerifyKey.h"
#import "NSString+XPAPIPath_SecondHand.h"
#import "XPAPIManager+Analysis.h"
#import "XPAPIManager+SecondHand.h"
#import "XPSecondHandCommentsModel.h"
#import "XPSecondHandDetailModel.h"
#import "XPSecondHandItemsListModel.h"
#import "XPSecondHandReplyModel.h"
#import <XPKit.h>

@implementation XPAPIManager (SecondHand)

- (RACSignal *)secondHandListWithType:(NSString *)type lastSecondHandItemId:(NSString *)lastSecondHandItemId
{
    NSMutableDictionary *dic = [@{@"type":type}
                                mutableCopy];
    if(lastSecondHandItemId.length > 0) {
        [dic setObject:lastSecondHandItemId forKey:@"last_secondhand_item_id"];
    }
    
    return [[[[[self rac_GET:[NSString api_secondhand_items_path] parameters:[[dic fillUserInfo] fillVerifyKeyInfo]] map:^id (id value) {
        return [self analysisRequest:value];
    }] flattenMap:^RACStream *(id value) {
        if([value isKindOfClass:[NSError class]]) {
            return [RACSignal error:value];
        }
        
        return [self rac_MappingForClass:[XPSecondHandItemsListModel class] array:value[@"secondhand_items"]];
    }] logError] replayLazily];
}

- (RACSignal *)postSecondHandWithTitle:(NSString *)title content:(NSString *)content picUrls:(NSArray *)picUrls price:(NSString *)price type:(NSString *)type mobile:(NSString *)mobile
{
    if(price.length < 1) {
        price = @"-1";
    }
    
    NSMutableDictionary *dic = [@{@"type":type,
                                  @"title":title,
                                  @"price":price}
                                mutableCopy];
    if(content.length > 0) {
        [dic setObject:content forKey:@"content"];
    }
    if(mobile.length > 0) {
        [dic setObject:mobile forKey:@"mobile"];
    }
    if(picUrls.count > 0) {
        [dic setObject:picUrls.arrayToJson forKey:@"pic_urls"];
    }
    
    return [[[[[self rac_POST:[NSString api_secondhand_item_create_path] parameters:[[dic fillUserInfo]fillVerifyKeyInfo]] map:^id (id value) {
        return [self analysisRequest:value];
    }] flattenMap:^RACStream *(id value) {
        if([value isKindOfClass:[NSError class]]) {
            return [RACSignal error:value];
        }
        return [RACSignal return:value];
    }] logError] replayLazily];
}

- (RACSignal *)secondHandDetailWithSecondhandItemId:(NSString *)secondhandItemId
{
    return [[[[[self rac_GET:[NSString api_secondhand_item_detail_path] parameters:[[@{@"secondhand_item_id":secondhandItemId}
                                                                                     fillUserInfo] fillVerifyKeyInfo]] map:^id (id value) {
        return [self analysisRequest:value];
    }] flattenMap:^RACStream *(id value) {
        if([value isKindOfClass:[NSError class]]) {
            return [RACSignal error:value];
        }
        
        return [self rac_MappingForClass:[XPSecondHandDetailModel class] dictionary:value];
    }] logError] replayLazily];
}

- (RACSignal *)collectionTopicOrSecondHandWithFavoriteId:(NSString *)favoriteId type:(CollectionType)type
{
    return [[[[[self rac_POST:[NSString api_collection_favorite_create_path] parameters:
                [[@{@"favorite_id":favoriteId, @"type":[@(type)stringValue]}
                  fillUserInfo] fillVerifyKeyInfo]] map:^id (id value) {
        return [self analysisRequest:value];
    }] flattenMap:^RACStream *(id value) {
        if([value isKindOfClass:[NSError class]]) {
            return [RACSignal error:value];
        }
        return [RACSignal return:@"success"];
    }] logError] replayLazily];
}

- (RACSignal *)cancelCollectionTopicOrSecondHandWithFavoriteId:(NSString *)favoriteId type:(CollectionType)type
{
    return [[[[[self rac_POST:[NSString api_collection_favorite_cancel_path] parameters:
                [[@{@"favorite_id":favoriteId, @"type":[@(type)stringValue]}
                  fillUserInfo] fillVerifyKeyInfo]] map:^id (id value) {
        return [self analysisRequest:value];
    }] flattenMap:^RACStream *(id value) {
        if([value isKindOfClass:[NSError class]]) {
            return [RACSignal error:value];
        }
        return [RACSignal return:@"success"];
    }] logError] replayLazily];
}

- (RACSignal *)secondHandCloseWithSecondhandItemId:(NSString *)secondhandItemId
{
    return [[[[[self rac_POST:[NSString api_secondhand_item_close_path] parameters:
                [[@{@"secondhand_item_id":secondhandItemId}
                  fillUserInfo] fillVerifyKeyInfo]] map:^id (id value) {
        return [self analysisRequest:value];
    }] flattenMap:^RACStream *(id value) {
        if([value isKindOfClass:[NSError class]]) {
            return [RACSignal error:value];
        }
        return [RACSignal return:@"success"];
    }] logError] replayLazily];
}

- (RACSignal *)secondHandCancelWithSecondhandItemId:(NSString *)secondhandItemId
{
    return [[[[[self rac_POST:[NSString api_secondhand_item_cancel_path] parameters:
                [[@{@"secondhand_item_id":secondhandItemId}
                  fillUserInfo] fillVerifyKeyInfo]] map:^id (id value) {
        return [self analysisRequest:value];
    }] flattenMap:^RACStream *(id value) {
        if([value isKindOfClass:[NSError class]]) {
            return [RACSignal error:value];
        }
        return [RACSignal return:@"success"];
    }] logError] replayLazily];
}

- (RACSignal *)updateSecondHandWithSecondhandItemId:(NSString *)secondhandItemId Title:(NSString *)title content:(NSString *)content picUrls:(NSArray *)picUrls price:(NSString *)price type:(NSString *)type mobile:(NSString *)mobile
{
    if(price.length < 1) {
        price = @"-1";
    }
    
    NSMutableDictionary *dic = [@{@"secondhand_item_id":secondhandItemId,
                                  @"type":type,
                                  @"title":title,
                                  @"price":price}
                                mutableCopy];
    if(content.length > 0) {
        [dic setObject:content forKey:@"content"];
    }
    if(mobile.length > 0) {
        [dic setObject:mobile forKey:@"mobile"];
    }
    if(picUrls.count > 0) {
        [dic setObject:picUrls.arrayToJson forKey:@"pic_urls"];
    }
    
    return [[[[[self rac_POST:[NSString api_secondhand_item_update_path] parameters:
                [[dic fillUserInfo] fillVerifyKeyInfo]] map:^id (id value) {
        return [self analysisRequest:value];
    }] flattenMap:^RACStream *(id value) {
        if([value isKindOfClass:[NSError class]]) {
            return [RACSignal error:value];
        }
        return [RACSignal return:value];
    }] logError] replayLazily];
}

- (RACSignal *)secondHandCommentListWithSecondhandItemId:(NSString *)secondhandItemId pageSize:(NSInteger)pageSize secondhandCommentId:(NSString *)secondhandCommentId
{
    NSMutableDictionary *dic = [@{@"secondhand_item_id":secondhandItemId}
                                mutableCopy];
    if(secondhandCommentId.length > 0) {
        [dic setValue:secondhandCommentId forKey:@"secondhand_comment_id"];
    }
    
    return [[[[[self rac_GET:[NSString api_secondhand_comments_path] parameters:[[dic fillUserInfo] fillVerifyKeyInfo]] map:^id (id value) {
        return [self analysisRequest:value];
    }] flattenMap:^RACStream *(id value) {
        if([value isKindOfClass:[NSError class]]) {
            return [RACSignal error:value];
        }
        
        return [self rac_MappingForClass:[XPSecondHandCommentsModel class] array:[value objectForKey:@"secondhand_comments"]];
    }] logError] replayLazily];
}

- (RACSignal *)secondHandCreateCommentWithSecondhandItemId:(NSString *)secondhandItemId content:(NSString *)content replyOf:(NSString *)replyOf
{
    NSMutableDictionary *dic = [@{@"secondhand_item_id":secondhandItemId,
                                  @"content":content}
                                mutableCopy];
    if(replyOf.length > 0) {
        [dic setValue:replyOf forKey:@"reply_of"];
    }
    
    return [[[[[self rac_POST:[NSString api_secondhand_comment_create_path] parameters:[[dic fillUserInfo] fillVerifyKeyInfo]] map:^id (id value) {
        return [self analysisRequest:value];
    }] flattenMap:^RACStream *(id value) {
        if([value isKindOfClass:[NSError class]]) {
            return [RACSignal error:value];
        }
        
        return [self rac_MappingForClass:[XPSecondHandCommentsModel class] dictionary:value];
    }] logError] replayLazily];
}

@end
