//
//  XPAnnouncementViewModel.m
//  XPApp
//
//  Created by iiseeuu on 15/12/21.
//  Copyright © 2015年 ShareMerge. All rights reserved.
//

#import "XPAPIManager+Announcement.h"
#import "XPAnnouncementViewModel.h"

@interface XPAnnouncementViewModel ()

@property (nonatomic, strong, readwrite) RACCommand *listCommand;
@property (nonatomic, strong, readwrite) NSArray *list;

@end

@implementation XPAnnouncementViewModel

- (RACCommand *)listCommand
{
    if(!_listCommand) {
        @weakify(self);
        _listCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [self.apiManager announcementList];
        }];
        [[_listCommand.executionSignals concat] subscribeNext:^(id x) {
            @strongify(self);
            self.list = x;
        }];
        XPViewModelShortHand(_listCommand)
    }
    
    return _listCommand;
}

@end
