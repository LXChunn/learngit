//
//  XPHappyLifeViewModel.m
//  XPApp
//
//  Created by jy on 16/1/13.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import "XPHappyLifeViewModel.h"


@interface XPHappyLifeViewModel ()

@property (nonatomic,strong,readwrite) RACCommand *webCommand;
@property (nonatomic,strong,readwrite) NSString *webUrl;
@end

@implementation XPHappyLifeViewModel

- (instancetype)init {
	if (self = [super init]) {

	}
	return self;
}

- (RACCommand *)webCommand
{
    if(!_webCommand) {
        @weakify(self);
        _webCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [self.apiManager happyLifeWithDate:self.date time:self.time billType:self.billType cityCode:self.cityCode];
        }];
        [[_webCommand.executionSignals concat] subscribeNext:^(NSString * x) {
            @strongify(self);
            self.webUrl = x;
        }];
        XPViewModelShortHand(_webCommand)
    }
    
    return _webCommand;
}

@end 
