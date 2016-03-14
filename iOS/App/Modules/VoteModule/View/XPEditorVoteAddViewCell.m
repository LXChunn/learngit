//
//  XPEditorVoteAddViewCell.m
//  XPApp
//
//  Created by Mac OS on 16/1/4.
//  Copyright © 2016年 ShareMerge. All rights reserved.
//

#import "XPEditorVoteAddViewCell.h"

@interface XPEditorVoteAddViewCell ()
@property (nonatomic, strong) AddOptionBlock block;
@end

@implementation XPEditorVoteAddViewCell

- (void)whenClickAddOptionWithBlock:(AddOptionBlock)block
{
    _block = block;
}

- (IBAction)addChooesButton:(UIButton *)sender
{
    if(_block) {
        _block();
    }
}

@end
