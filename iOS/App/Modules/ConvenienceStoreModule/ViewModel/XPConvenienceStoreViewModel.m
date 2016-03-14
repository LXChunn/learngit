//
//  XPConvenienceStoreViewModel.m
//  XPApp
//
//  Created by iiseeuu on 16/1/15.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import "XPConvenienceStoreViewModel.h"
#import "XPAPIManager+ConvenienceStore.h"
#import "XPConvenienceStoreModel.h"

@interface XPConvenienceStoreViewModel ()

@property (nonatomic, strong, readwrite) NSArray *list;
@property (nonatomic, strong, readwrite) RACCommand *reloadCommand;
@property (nonatomic, strong, readwrite) RACCommand *moreCommand;
@property (nonatomic, strong, readwrite) NSString *lastConvenienceStoreItemId;
@property (nonatomic, assign, readwrite) BOOL isNoMoreDate;

@end

@implementation XPConvenienceStoreViewModel

- (instancetype)init
{
    if(self = [super init]) {
        self.isNoMoreDate = NO;
    }
    return self;
}

- (RACCommand *)reloadCommand
{
    if(!_reloadCommand) {
        @weakify(self);
        _reloadCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [self.apiManager convenienceStoreListWithLastItemId:nil];
        }];
        [[_reloadCommand.executionSignals concat] subscribeNext:^(NSArray *x) {
            @strongify(self);
            if ([x count]) {
                XPConvenienceStoreModel *model = [x lastObject];
                self.lastConvenienceStoreItemId = model.cvsItemId;
            }
            self.list = x;
            if (x.count < 20) {
                self.isNoMoreDate = YES;
            }
        }];
        XPViewModelShortHand(_reloadCommand)
    }
    return _reloadCommand;
}

- (RACCommand *)moreCommand
{
    if(!_moreCommand) {
        @weakify(self);
        _moreCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [self.apiManager convenienceStoreListWithLastItemId:self.lastConvenienceStoreItemId];
        }];
        [[_moreCommand.executionSignals concat] subscribeNext:^(NSArray *x) {
            @strongify(self);
            if ([x count]) {
                XPConvenienceStoreModel *model = [x lastObject];
                self.lastConvenienceStoreItemId = model.cvsItemId;
            }
            if (self.list) {
                self.list = [self.list arrayByAddingObjectsFromArray:x];
            }else{
                self.list = x;
            }
            if (x.count < 20) {
                self.isNoMoreDate = YES;
            }
        }];
        XPViewModelShortHand(_moreCommand)
    }
    
    return _moreCommand;
}






@end 
