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
@property (nonatomic, strong) DeleteOptionBlock deleteBlock;
@property (nonatomic, strong) TextInputBlock textInputBlock;

@property (strong, nonatomic) XPVoteModel *model;
@end

@implementation XPEditorVoteTableViewCell

- (void)configureUIWithContent:(NSString *)content deleteBlock:(DeleteOptionBlock)deleteBlock textInputBlock:(TextInputBlock)textInputBlock
{
    _descriptionTextField.text = content;
    _deleteBlock = deleteBlock;
    _textInputBlock = textInputBlock;
}

- (IBAction)deleteButton:(UIButton *)sender
{
    if(_deleteBlock) {
        _deleteBlock();
    }
}

- (IBAction)textInputAction:(id)sender
{
    if(_textInputBlock) {
        _textInputBlock(_descriptionTextField.text);
    }
}

@end
