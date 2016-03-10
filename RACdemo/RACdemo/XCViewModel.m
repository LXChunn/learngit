//
//  XCViewModel.m
//  RACdemo
//
//  Created by Mac OS on 16/3/10.
//  Copyright © 2016年 JASON. All rights reserved.
//

#import "XCViewModel.h"

@interface XCViewModel ()

@property (nonatomic,strong,readwrite)RACCommand* listCommand;
@property (nonatomic,strong,readwrite)NSArray* list;
@property NSString* xcStr;
@end
@implementation XCViewModel
-(RACCommand *)listCommand
{
    if (!_listCommand) {
        @weakify(self);
        _listCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            NSLog(@"到达了。。。");
            return RACObserve(self, xcStr);
        }];
        [[_listCommand.executionSignals concat]subscribeNext:^(id x) {
            @strongify(self);
            self.list = x;
            
            NSLog(@"%@",x);
        }];
    }
    return _listCommand;
    
}

@end
