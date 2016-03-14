//
//  XPAPIManager+GetMyComment.m
//  XPApp
//
//  Created by CaoShunQing on 16/1/8.
//  Copyright © 2016年 ShareMerge. All rights reserved.
//

#import "NSDictionary+XPAPIUserInfo.h"
#import "NSDictionary+XPAPIVerifyKey.h"
#import "NSString+XPAPIPath_GetMyComment.h"
#import "XPAPIManager+Analysis.h"
#import "XPAPIManager+GetMyComment.h"
#import "XPMyCommentListModel.h"
#import "XPTopicModel.h"

@implementation XPAPIManager (GetMyComment)

- (RACSignal *)getMyCommentsWithType:(NSString *)type pageSize:(NSInteger)pageSize lastCommentid:(NSString *)lastCommentId
{
    NSParameterAssert(type);
    NSMutableDictionary *dic = [@{@"type":type}
                                mutableCopy];
    if(lastCommentId.length > 0) {
        [dic setObject:lastCommentId forKey:@"last_comment_id"];
    }
    
    return [[[[[self rac_GET:[NSString api_my_comments] parameters:[[dic
                                                                     fillUserInfo]                        fillVerifyKeyInfo]] map:^id (id value) {
        return [self analysisRequest:value];
    }] flattenMap:^RACStream *(id value) {
        if([value isKindOfClass:[NSError class]]) {
            return [RACSignal error:value];
        }
        
        return [self rac_MappingForClass:[XPMyCommentListModel class] array:value[@"forum_comments"]];
    }] logError] replayLazily];
}

@end
