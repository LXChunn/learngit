//
//  XPForumViewModel.m
//  XPApp
//
//  Created by jy on 15/12/28.
//  Copyright 2015年 ShareMerge. All rights reserved.
//

#import "XPForumViewModel.h"


@interface XPForumViewModel ()
@property (nonatomic,strong,readwrite) NSArray *titleArray;
@property (nonatomic,strong,readwrite) NSArray *imageArray;

@end

@implementation XPForumViewModel

- (instancetype)init {
	if (self = [super init]) {
        _titleArray = @[@"二手市场",@"悦生活",@"便利店"];
        _imageArray = @[@"convenience_secondhand_button",@"convenience_life_button",@"convenience_store_button"];
	}
	return self;
}

@end 
