//
//  XPAPIManager+HousekeepingNews.h
//  XPApp
//
//  Created by jy on 16/2/22.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import "XPAPIManager.h"

@interface XPAPIManager (HousekeepingNews)

- (RACSignal *)housekeepingListWithLastItemId:(NSString *)lastItemId;

- (RACSignal *)createHousekeepingWithTitle:(NSString *)title content:(NSString *)content picUrls:(NSArray *)picUrls mobile:(NSString *)mobile;

- (RACSignal *)updateHousekeepingWithTitle:(NSString *)title content:(NSString *)content picUrls:(NSArray *)picUrls mobile:(NSString *)mobile housekeepingItemId:(NSString *)housekeepingItemId;

- (RACSignal *)deleteHousekeepingWithHousekeepingItemId:(NSString *)housekeepingItemId;

- (RACSignal *)detailOfHousekeepingWithHousekeepingItemId:(NSString *)housekeepingItemId;

- (RACSignal *)housekeepingCommentsWithHousekeepingItemId:(NSString *)housekeepingItemId housekeepingCommentId:(NSString *)housekeepingCommentId;

- (RACSignal *)reolyFroumCommentWithHousekeepingItemId:(NSString *)housekeepingItemId content:(NSString *)content replyOf:(NSString *)replyOf;

@end
