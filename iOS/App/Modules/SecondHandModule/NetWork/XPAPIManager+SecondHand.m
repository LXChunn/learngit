//
//  XPAPIManager+SecondHand.m
//  XPApp
//
//  Created by jy on 15/12/29.
//  Copyright 2015年 ShareMerge. All rights reserved.
//

#import "XPAPIManager+SecondHand.h"
#import "NSString+XPAPIPath_SecondHand.h"
#import "NSDictionary+XPAPIUserInfo.h"
#import "XPAPIManager+Analysis.h"
#import "XPSecondHandItemsListModel.h"
#import "NSDictionary+XPAPIVerifyKey.h"
#import "XPSecondHandDetailModel.h"

@implementation XPAPIManager (SecondHand)

- (RACSignal *)secondHandListWithType:(NSString *)type lastSecondHandItemId:(NSString *)lastSecondHandItemId
{
    NSMutableDictionary * dic = [@{@"type":type} mutableCopy];
    if (lastSecondHandItemId.length > 0)
    {
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
    if (price.length < 1)
    {
        price = @"-1";
    }
    NSMutableDictionary * dic = [@{@"type":type,
                                   @"title":title,
                                   @"price":price} mutableCopy];
    if (content.length > 0)
    {
        [dic setObject:content forKey:@"content"];
    }
    if (mobile.length > 0)
    {
        [dic setObject:mobile forKey:@"mobile"];
    }
    if (picUrls.count > 0)
    {
        [dic setObject:picUrls forKey:@"pic_urls"];
    }
    return [[[[[self rac_POST:[NSString api_secondhand_item_create_path] parameters:
                [[dic fillUserInfo] fillVerifyKeyInfo]] map:^id (id value) {
        return [self analysisRequest:value];
    }] flattenMap:^RACStream *(id value) {
        if([value isKindOfClass:[NSError class]]) {
            NSError * error = value;
            if (error.code == 100)
            {
                return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                    [subscriber sendNext:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
                    return nil;
                }];
            }
            return [RACSignal error:value];
        }
        return nil;
    }] logError] replayLazily];
}

- (RACSignal *)secondHandDetailWithSecondhandItemId:(NSString *)secondhandItemId
{
    return [[[[[self rac_GET:[NSString api_secondhand_item_detail_path] parameters:[[@{@"secondhand_item_id":secondhandItemId} fillUserInfo] fillVerifyKeyInfo]] map:^id (id value) {
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
    return [[[[[self rac_POST:[NSString api_collection_favorite_create] parameters:
                [[@{@"favorite_id":favoriteId,@"type":[@(type) stringValue]} fillUserInfo] fillVerifyKeyInfo]] map:^id (id value) {
        return [self analysisRequest:value];
    }] flattenMap:^RACStream *(id value) {
        if([value isKindOfClass:[NSError class]]) {
            return [RACSignal error:value];
        }
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendNext:@"success"];
            return nil;
        }];
    }] logError] replayLazily];
}

- (RACSignal *)secondHandCloseWithSecondhandItemId:(NSString *)secondhandItemId
{
    return [[[[[self rac_POST:[NSString api_secondhand_item_close_path] parameters:
                [[@{@"secondhand_item_id":secondhandItemId} fillUserInfo] fillVerifyKeyInfo]] map:^id (id value) {
        return [self analysisRequest:value];
    }] flattenMap:^RACStream *(id value) {
        if([value isKindOfClass:[NSError class]]) {
            return [RACSignal error:value];
        }
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendNext:@"success"];
            return nil;
        }];
    }] logError] replayLazily];
}

- (RACSignal *)secondHandCancelWithSecondhandItemId:(NSString *)secondhandItemId
{
    return [[[[[self rac_POST:[NSString api_secondhand_item_cancel_path] parameters:
                [[@{@"secondhand_item_id":secondhandItemId} fillUserInfo] fillVerifyKeyInfo]] map:^id (id value) {
        return [self analysisRequest:value];
    }] flattenMap:^RACStream *(id value) {
        if([value isKindOfClass:[NSError class]]) {
            return [RACSignal error:value];
        }
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendNext:@"success"];
            return nil;
        }];
    }] logError] replayLazily];
}

@end
