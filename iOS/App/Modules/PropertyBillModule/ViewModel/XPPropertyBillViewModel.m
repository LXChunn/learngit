//
//  XPJFZDViewModel.m
//  XPApp
//
//  Created by Mac OS on 15/12/20.
//  Copyright © 2015年 ShareMerge. All rights reserved.
//

#import "XPAPIManager+PropertyBill.h"
#import "XPPropertyBillViewModel.h"

@interface XPPropertyBillViewModel ()

@property (nonatomic, strong, readwrite) RACCommand *listCommand;
@property (nonatomic, strong, readwrite) NSArray *list;

@end

@implementation XPPropertyBillViewModel

- (RACCommand *)listCommand
{
    if(!_listCommand) {
        @weakify(self);
        _listCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [self.apiManager propertyBillList];
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
