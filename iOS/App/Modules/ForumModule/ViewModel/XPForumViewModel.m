//
//  XPForumViewModel.m
//  XPApp
//
//  Created by jy on 15/12/28.
//  Copyright 2015年 ShareMerge. All rights reserved.
//

#import "XPForumViewModel.h"

@interface XPForumViewModel ()
@property (nonatomic, strong, readwrite) NSArray *titleArray;
@property (nonatomic, strong, readwrite) NSArray *imageArray;

@end

@implementation XPForumViewModel

- (instancetype)init
{
    if(self = [super init]) {
        _titleArray = @[@"二手市场", @"悦生活", @"优惠活动",@"楼盘",@"快递查询",@"天气查询",@"家政资讯",@"业主拼车"];
        _imageArray = @[@"convenience_secondhand_button", @"convenience_life_button", @"convenience_event_button",@"convenience_houses_button",@"convenience_express_button",@"convenience_weather_button",@"convenience_homeservice_button",@"convenience_car_button"];
    }
    return self;
}

@end
