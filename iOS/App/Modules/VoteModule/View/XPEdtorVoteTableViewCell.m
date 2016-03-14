//
//  XPEdtorVoteTableViewCell.m
//  XPApp
//
//  Created by Mac OS on 15/12/31.
//  Copyright © 2015年 ShareMerge. All rights reserved.
//

#import "XPEdtorVoteTableViewCell.h"
#import "XPVoteViewModel.h"

@interface XPEdtorVoteTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *titleImage;
@property (weak, nonatomic) IBOutlet UITextField *optionsTextField;

@property (strong, nonatomic) XPEdtorVoteTableViewCell *model;

@end

@implementation XPEdtorVoteTableViewCell

- (void)awakeFromNib
{
    RAC(self.model, optionsTextField) = self.optionsTextField.rac_textSignal;
}

- (void)clickButton
{
}

@end
