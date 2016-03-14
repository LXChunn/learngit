//
//  XPAPIManager+HousekeepingNews.m
//  XPApp
//
//  Created by jy on 16/2/22.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import "XPAPIManager+Analysis.h"
#import "XPAPIManager+HousekeepingNews.h"
#import "NSString+XPAPIPath_HousekeepingNews.h"
#import "NSDictionary+XPAPIUserInfo.h"
#import "NSDictionary+XPAPIVerifyKey.h"
#import "XPHousekeepingListModel.h"
#import <XPKit.h>
#import "XPHousekeepingDetailModel.h"
#import "XPSecondHandCommentsModel.h"

@implementation XPAPIManager (HousekeepingNews)

// Oops, it's example! so you can remove this function.
- (RACSignal *)housekeepingListWithLastItemId:(NSString *)lastItemId{
    NSMutableDictionary * dic = [@{} mutableCopy];
    if (lastItemId.length > 0) {
        [dic setObject:lastItemId forKey:@"last_housekeeping_item_id"];
    }
    return [[[[[self rac_GET:[NSString api_housekeepings_list_path] parameters:[[dic fillUserInfo] fillVerifyKeyInfo]] map:^id (id value) {
        return [self analysisRequest:value];
    }] flattenMap:^RACStream *(id value) {
        if([value isKindOfClass:[NSError class]]) {
            return [RACSignal error:value];
        }
        return [self rac_MappingForClass:[XPHousekeepingListModel class] array:value[@"housekeepings"]];
    }] logError] replayLazily];
}

- (RACSignal *)createHousekeepingWithTitle:(NSString *)title content:(NSString *)content picUrls:(NSArray *)picUrls mobile:(NSString *)mobile{
    NSMutableDictionary * dic = [@{@"title":title,
                                   @"content":content} mutableCopy];
    if (mobile.length > 0) {
        [dic setObject:mobile forKey:@"mobile"];
    }
    if(picUrls.count > 0) {
        [dic setObject:picUrls.arrayToJson forKey:@"pic_urls"];
    }
    return [[[[[self rac_POST:[NSString api_housekeepings_create_path] parameters:
                [[dic fillUserInfo] fillVerifyKeyInfo]] map:^id (id value) {
        return [self analysisRequest:value];
    }] flattenMap:^RACStream *(id value) {
        if([value isKindOfClass:[NSError class]]) {
            return [RACSignal error:value];
        }
        return [RACSignal return:value];
    }] logError] replayLazily];
}

- (RACSignal *)updateHousekeepingWithTitle:(NSString *)title content:(NSString *)content picUrls:(NSArray *)picUrls mobile:(NSString *)mobile housekeepingItemId:(NSString *)housekeepingItemId{
    NSMutableDictionary * dic = [@{@"title":title,
                                   @"content":content,
                                   @"housekeeping_item_id":housekeepingItemId} mutableCopy];
    if (mobile.length > 0) {
        [dic setObject:mobile forKey:@"mobile"];
    }
    if(picUrls.count > 0) {
        [dic setObject:picUrls.arrayToJson forKey:@"pic_urls"];
    }
    return [[[[[self rac_POST:[NSString api_housekeepings_update_path] parameters:
                [[dic fillUserInfo] fillVerifyKeyInfo]] map:^id (id value) {
        return [self analysisRequest:value];
    }] flattenMap:^RACStream *(id value) {
        if([value isKindOfClass:[NSError class]]) {
            return [RACSignal error:value];
        }
        return [RACSignal return:value];
    }] logError] replayLazily];
}

- (RACSignal *)deleteHousekeepingWithHousekeepingItemId:(NSString *)housekeepingItemId{
    return [[[[[self rac_POST:[NSString api_housekeepings_delete_path] parameters:
                [[@{@"housekeeping_item_id":housekeepingItemId} fillUserInfo] fillVerifyKeyInfo]] map:^id (id value) {
        return [self analysisRequest:value];
    }] flattenMap:^RACStream *(id value) {
        if([value isKindOfClass:[NSError class]]) {
            return [RACSignal error:value];
        }
        return [RACSignal return:value];
    }] logError] replayLazily];
}

- (RACSignal *)detailOfHousekeepingWithHousekeepingItemId:(NSString *)housekeepingItemId{
    return [[[[[self rac_GET:[NSString api_housekeepings_detail_path] parameters:[[@{@"housekeeping_item_id":housekeepingItemId} fillUserInfo] fillVerifyKeyInfo]] map:^id (id value) {
        return [self analysisRequest:value];
    }] flattenMap:^RACStream *(id value) {
        if([value isKindOfClass:[NSError class]]) {
            return [RACSignal error:value];
        }
        return [self rac_MappingForClass:[XPHousekeepingDetailModel class] dictionary:value];
    }] logError] replayLazily];
}

- (RACSignal *)housekeepingCommentsWithHousekeepingItemId:(NSString *)housekeepingItemId housekeepingCommentId:(NSString *)housekeepingCommentId{
    NSMutableDictionary *dic = [@{@"housekeeping_item_id":housekeepingItemId}
                                mutableCopy];
    if(housekeepingCommentId.length > 0) {
        [dic setValue:housekeepingCommentId forKey:@"housekeeping_comment_id"];
    }
    
    return [[[[[self rac_GET:[NSString api_housekeepings_comments_path] parameters:[[dic fillUserInfo] fillVerifyKeyInfo]] map:^id (id value) {
        return [self analysisRequest:value];
    }] flattenMap:^RACStream *(id value) {
        if([value isKindOfClass:[NSError class]]) {
            return [RACSignal error:value];
        }
        return [self rac_MappingForClass:[XPSecondHandCommentsModel class] array:[value objectForKey:@"housekeeping_comments"]];
    }] logError] replayLazily];
}

- (RACSignal *)reolyFroumCommentWithHousekeepingItemId:(NSString *)housekeepingItemId content:(NSString *)content replyOf:(NSString *)replyOf{
    NSMutableDictionary *dic = [@{@"housekeeping_item_id":housekeepingItemId,
                                  @"content":content}
                                mutableCopy];
    if(replyOf.length > 0) {
        [dic setValue:replyOf forKey:@"reply_of"];
    }
    return [[[[[self rac_POST:[NSString api_housekeepings_comment_create_path] parameters:[[dic fillUserInfo] fillVerifyKeyInfo]] map:^id (id value) {
        return [self analysisRequest:value];
    }] flattenMap:^RACStream *(id value) {
        if([value isKindOfClass:[NSError class]]) {
            return [RACSignal error:value];
        }
        return [self rac_MappingForClass:[XPSecondHandCommentsModel class] dictionary:value];
    }] logError] replayLazily];
}

@end 
