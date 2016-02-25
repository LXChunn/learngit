//
//  XPAPIManager+CreatePost.m
//  XPApp
//
//  Created by iiseeuu on 15/12/30.
//  Copyright © 2015年 ShareMerge. All rights reserved.
//

#import "XPAPIManager+CreatePost.h"
#import "NSDictionary+XPAPIUserInfo.h"
#import "NSDictionary+XPAPIVerifyKey.h"
#import "NSString+XPAPIPath_CreatePost.h"
#import "XPAPIManager+Analysis.h"
#import "XPDetailPostModel.h"

@implementation XPAPIManager (CreatePost)

- (RACSignal *)createPostWithTitle:(NSString *)title withType:(NSString *)type withContent:(NSString *)content withStartdate:(NSString *)startdate withPicUrls:(NSArray *)picUrls
{
    NSParameterAssert(content);
    NSParameterAssert(type);
    NSParameterAssert(title);
    NSParameterAssert(startdate);
    NSMutableDictionary *parameters = [@{
                                         @"content":content,
                                         @"type":type,
                                         @"content":title,
                                         @"type":startdate
                                         }
                                       mutableCopy];
    if(picUrls) {
        [parameters setObject:picUrls forKey:@"pic_urls"];
    }
    return [[[[[self rac_POST:[NSString api_createpost_path] parameters:[[parameters fillUserInfo]                      fillVerifyKeyInfo]] map:^id (id value) {
        return [self analysisRequest:value];
    }] flattenMap:^RACStream *(id value) {
        if([value isKindOfClass:[NSError class]]) {
            return [RACSignal error:value];
        }

        return [RACSignal return :value];
    }] logError] replayLazily];
}


- (RACSignal *)detailPostWithForumtopicid:(NSString *)forumtopicId
{
    return [[[[[self rac_GET:[NSString api_detailpost_path] parameters:[[ @{@"forum_topic_id" : forumtopicId}
                                                                            fillUserInfo]                        fillVerifyKeyInfo]] map:^id (id value) {
        return [self analysisRequest:value];
    }] flattenMap:^RACStream *(id value) {
        if([value isKindOfClass:[NSError class]]) {
            return [RACSignal error:value];
        }
        return [self rac_MappingForClass:[XPDetailPostModel class] dictionary:value];
        
    }] logError] replayLazily];
}






@end
