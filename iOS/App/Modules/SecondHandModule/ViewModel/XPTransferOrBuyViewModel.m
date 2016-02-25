//
//  XPTransferOrBuyViewModel.m
//  XPApp
//
//  Created by jy on 15/12/30.
//  Copyright 2015年 ShareMerge. All rights reserved.
//

#import "XPTransferOrBuyViewModel.h"
#import "XPAPIManager+SecondHand.h"

@interface XPTransferOrBuyViewModel ()

@property (nonatomic, strong, readwrite) RACCommand *postCommand;
@property (nonatomic,strong, readwrite) NSString *successMsg;

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
            self.successMsg = x;
        }];
        XPViewModelShortHand(_postCommand)
    }
    return _postCommand;
}

@end 
