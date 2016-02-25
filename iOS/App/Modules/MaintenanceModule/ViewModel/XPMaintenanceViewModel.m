//
//  XPMaintenanceViewModel.m
//  XPApp
//
//  Created by iiseeuu on 15/12/23.
//  Copyright © 2015年 ShareMerge. All rights reserved.
//

#import "XPAPIManager+Maintenance.h"
#import "XPMaintenanceViewModel.h"

@interface XPMaintenanceViewModel ()

@property (nonatomic, strong, readwrite) RACCommand *submitCommand;
@property (nonatomic, strong) RACSignal *validSignal;
@property (nonatomic, strong, readwrite) NSArray *orders;
@property (nonatomic, strong, readwrite) RACCommand *orderCommand;

@end

@implementation XPMaintenanceViewModel

- (instancetype)init
{
    if((self = [super init])) {
        self.type = nil;
        self.picUrls = nil;
        self.content = nil;
    }
    
    return self;
}

#pragma mark - Getter && Setter
- (RACSignal *)validSignal
{
    return [RACSignal combineLatest:@[RACObserve(self, type), RACObserve(self, content)] reduce:^id (NSString *type, NSString *content){
        return @(type && (content.length >= 10 && content.length <= 200));
    }];
}

- (RACCommand *)submitCommand
{
    if(!_submitCommand) {
        @weakify(self);
        _submitCommand = [[RACCommand alloc] initWithEnabled:self.validSignal signalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [self.apiManager maintenanceSubmitWithContent:self.content withType:self.type withPicUrls:self.picUrls];//传参
        }];
        [[[_submitCommand executionSignals] concat] subscribeNext:^(id x) {
            @strongify(self);
            self.submitFinished = YES;
        }];
        XPViewModelShortHand(_submitCommand)
    }
    
    return _submitCommand;
}

-(RACCommand *)orderCommand
{
    if(!_orderCommand) {
        @weakify(self);
        _orderCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [self.apiManager myMaintenance];
        }];
        [[_orderCommand.executionSignals concat] subscribeNext:^(id x) {
            @strongify(self);
            self.orders = x;
        }];
        XPViewModelShortHand(_orderCommand)
    }
    
    return _orderCommand;
}

@end
