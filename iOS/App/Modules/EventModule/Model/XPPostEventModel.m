//
//  XPPostEventModel.m
//  XPApp
//
//  Created by jy on 16/1/4.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import "XPPostEventModel.h"

@interface XPPostEventModel ()

@end

@implementation XPPostEventModel

- (instancetype)init
{
    if(self = [super init]) {
        _title = @"";
        _content = @"";
        _beginDate = @"";
        _endDate = @"";
    }
    
    return self;
}

@end
