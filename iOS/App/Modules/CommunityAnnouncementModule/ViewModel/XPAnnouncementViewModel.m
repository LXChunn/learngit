//
//  XPAnnouncementViewModel.m
//  XPApp
//
//  Created by iiseeuu on 15/12/21.
//  Copyright © 2015年 ShareMerge. All rights reserved.
//

#import "XPAPIManager+Announcement.h"
#import "XPAnnouncementModel.h"
#import "XPAnnouncementViewModel.h"

@interface XPAnnouncementViewModel ()

@property (nonatomic, strong, readwrite) RACCommand *listCommand;
@property (nonatomic, strong, readwrite) RACCommand *listMoreCommand;
@property (nonatomic, strong, readwrite) NSArray *list;
@property (nonatomic, strong, readwrite) NSString *communityId;
@property (nonatomic, assign, readwrite) BOOL isNoMoreDate;

@end

@implementation XPAnnouncementViewModel
- (instancetype)init
{
    if(self = [super init]) {
        self.isNoMoreDate = NO;
    }
    return self;
}

- (RACCommand *)listCommand
{
    if(!_listCommand) {
        @weakify(self);
        _listCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [self.apiManager announcementListWithCommunityannouncementId:nil];
        }];
        [[_listCommand.executionSignals concat] subscribeNext:^(NSArray *x) {
            @strongify(self);
            if ([x count]) {
                XPAnnouncementModel *model = [x lastObject];
                self.communityId = model.communityAnnouncementId;
            }
            self.list = x;
            if (x.count < 20) {
                self.isNoMoreDate = YES;
            }
        }];
        XPViewModelShortHand(_listCommand)
    }
    return _listCommand;
}

- (RACCommand *)listMoreCommand
{
    if(!_listMoreCommand) {
        @weakify(self);
        _listMoreCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [self.apiManager announcementListWithCommunityannouncementId:self.communityId];
        }];
        [[_listMoreCommand.executionSignals concat] subscribeNext:^(NSArray *x) {
            @strongify(self);
            if ([x count]) {
                XPAnnouncementModel *model = [x lastObject];
                self.communityId = model.communityAnnouncementId;
            }
            if (self.list) {
                self.list = [self.list arrayByAddingObjectsFromArray:x];
            } else {
                self.list = x;
            }
            if (x.count < 20) {
                self.isNoMoreDate = YES;
            }
        }];
        XPViewModelShortHand(_listMoreCommand)
    }
    
    return _listMoreCommand;
}

@end
