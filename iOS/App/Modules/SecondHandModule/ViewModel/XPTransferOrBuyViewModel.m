//
//  XPTransferOrBuyViewModel.m
//  XPApp
//
//  Created by jy on 15/12/30.
//  Copyright 2015年 ShareMerge. All rights reserved.
//

#import "XPAPIManager+SecondHand.h"
#import "XPTransferOrBuyViewModel.h"

@interface XPTransferOrBuyViewModel ()

@property (nonatomic, strong, readwrite) RACCommand *postCommand;
@property (nonatomic, strong, readwrite) RACCommand *updateCommand;
@property (nonatomic, strong, readwrite) NSString *successMessage;

@end

@implementation XPTransferOrBuyViewModel

- (RACCommand *)postCommand
{
    if(!_postCommand) {
        @weakify(self);
        _postCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [self.apiManager postSecondHandWithTitle:self.model.goodsTitle content:self.model.goodsDescriptions picUrls:self.model.pictures price:self.model.price type:self.model.type mobile:self.model.mobile];
        }];
        [[_postCommand.executionSignals concat] subscribeNext:^(id x) {
            @strongify(self);
            self.successMessage = x;
        }];
        XPViewModelShortHand(_postCommand)
    }
    
    return _postCommand;
}

- (RACCommand *)updateCommand
{
    if(!_updateCommand) {
        @weakify(self);
        _updateCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [self.apiManager updateSecondHandWithSecondhandItemId:self.secodnHandItemId Title:self.model.goodsTitle content:self.model.goodsDescriptions picUrls:self.model.pictures price:self.model.price type:self.model.type mobile:self.model.mobile];
        }];
        [[_updateCommand.executionSignals concat] subscribeNext:^(id x) {
            @strongify(self);
            self.successMessage = x;
        }];
        XPViewModelShortHand(_updateCommand)
    }
    
    return _updateCommand;
}

@end
