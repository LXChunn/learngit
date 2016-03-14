//
//  XPMyCollectionViewModel.m
//  XPApp
//
//  Created by CaoShunQing on 16/1/8.
//  Copyright © 2016年 ShareMerge. All rights reserved.
//

#import "XPAPIManager+Getmycollect.h"
#import "XPMyCollectionViewModel.h"
#import "XPSecondHandItemsListModel.h"
#import "XPTopicModel.h"
#import "XPOtherFavoriateModel.h"

@interface XPMyCollectionViewModel ()

@property (nonatomic, strong, readwrite) RACCommand *myfavoritesCommand;
@property (nonatomic, strong, readwrite) RACCommand *morefavoritesCommand;
@property (nonatomic, strong, readwrite) NSMutableArray *myCollectArray;
@property (nonatomic, assign, readwrite) BOOL isNoMoreDate;

@end

@implementation XPMyCollectionViewModel

- (instancetype)init
{
    if(self = [super init]) {
        self.lastId = nil;
        self.pageSize = 20;
        self.isNoMoreDate = NO;
    }
    return self;
}

- (RACCommand *)myfavoritesCommand
{
    if(!_myfavoritesCommand) {
        @weakify(self);
        _myfavoritesCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [self.apiManager getMyFavoriteWithType:self.type pagerSize:self.pageSize lastItemId:nil];
        }];
        [[[_myfavoritesCommand executionSignals] concat] subscribeNext:^(NSArray *x) {
            @strongify(self);
            if(x.count > 0) {
                if ([self.type isEqualToString:@"1"]) {
                    XPTopicModel *model = [x lastObject];
                    self.lastId = model.forumTopicId;
                    self.myCollectArray = x;
                }
                else if ([self.type isEqualToString:@"2"]) {
                    XPSecondHandItemsListModel *model = [x lastObject];
                    self.lastId = model.secondhandItemId;
                    self.myCollectArray = x;
                }else{ 
                    XPOtherFavoriateModel *model = [x lastObject];
                    self.lastId = model.favoriteItemId;
                    self.myCollectArray = x;
                }
            }
            self.myCollectArray = x;
            if (x.count < 20) {
                self.isNoMoreDate = YES;
            }
        }];
        XPViewModelShortHand(_myfavoritesCommand)
    }
    return _myfavoritesCommand;
}

- (RACCommand *)morefavoritesCommand
{
    if(!_morefavoritesCommand) {
        @weakify(self);
        _morefavoritesCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [self.apiManager getMyFavoriteWithType:self.type pagerSize:self.pageSize lastItemId:self.lastId];
        }];
        [[[_morefavoritesCommand executionSignals] concat] subscribeNext:^(NSArray *x) {
            @strongify(self);
            if ([self.type isEqualToString:@"1"]) {
                if(x.count > 0) {
                    XPTopicModel *model = [x lastObject];
                    self.lastId = model.forumTopicId;
                }
                if (self.myCollectArray) {
                    self.myCollectArray = [self.myCollectArray arrayByAddingObjectsFromArray:x];
                }else{
                    self.myCollectArray = x;
                }
            }else
            {
                if(x.count > 0) {
                    XPSecondHandItemsListModel *model = [x lastObject];
                    self.lastId = model.secondhandItemId;
                }
                if (self.myCollectArray) {
                    self.myCollectArray = [self.myCollectArray arrayByAddingObjectsFromArray:x];
                }else{
                    self.myCollectArray = x;
                }
                if (x.count < 20) {
                    self.isNoMoreDate = YES;
                }
            }
        }];
        XPViewModelShortHand(_morefavoritesCommand)
    }
    
    return _morefavoritesCommand;
}

//- (RACCommand *)myOtherFavoritesCommand
//{
//    if(!_myOtherFavoritesCommand) {
//        @weakify(self);
//        _myOtherFavoritesCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
//            @strongify(self);
//            return [self.apiManager getMyOtherFavorite:nil];
//        }];
//        [[[_myOtherFavoritesCommand executionSignals] concat] subscribeNext:^(NSArray *x) {
//            @strongify(self);
//            if(x.count > 0) {
//                    XPOtherFavoriateModel *model = [x lastObject];
//                    self.lastId = model.lastid;
//                    self.myCollectArray = x;
//            }
//            self.myCollectArray = x;
//            if (x.count < 20) {
//                self.isNoMoreDate = YES;
//            }
//        }];
//        XPViewModelShortHand(_myOtherFavoritesCommand)
//    }
//    return _myOtherFavoritesCommand;
//}
//
//- (RACCommand *)moreOtheFavoriatesCommand
//{
//    if (!_moreOtheFavoriatesCommand) {
//        @weakify(self);
//        _moreOtheFavoriatesCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
//            @strongify(self);
//            return [self.apiManager getMyOtherFavorite:self.lastId];
//        }];
//        [[[_moreOtheFavoriatesCommand executionSignals] concat]subscribeNext:^(NSArray *x) {
//            @strongify(self);
//            if (x.count>0) {
//                XPOtherFavoriateModel *model = [x lastObject];
//                self.lastId = model.lastid;
//                self.myCollectArray = x;
//            }
//            self.myCollectArray = x;
//            if (x.count<20) {
//                self.isNoMoreDate = YES;
//            }
//        }];
//    }
//    return _moreOtheFavoriatesCommand;
//}
@end
