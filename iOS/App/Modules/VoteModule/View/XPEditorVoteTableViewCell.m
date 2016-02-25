//
//  XPEdtorVoteTableViewCell.m
//  XPApp
//
//  Created by Mac OS on 15/12/31.
//  Copyright © 2015年 ShareMerge. All rights reserved.
//

#import "XPEditorVoteTableViewCell.h"
#import "XPVoteModel.h"

@interface XPEditorVoteTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *titleImage;
@property (weak, nonatomic) IBOutlet UITextField *descriptionTextField;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@property (strong, nonatomic)XPVoteModel *model;
@property (strong, nonatomic)NSArray *storageOptionsArray;
@end

@implementation XPEditorVoteTableViewCell

- (IBAction)deleteButton:(UIButton *)sender
{
//    if (self.model.open == true)
//    {
//        self.deleteButton.image = [UIImage imageNamed:@"common_trash_button_normal"];
//    }else{
//        self.deleteButton.image = [UIImage imageNamed:@"common_trash_button_clicked"];
//    }
}


@end
