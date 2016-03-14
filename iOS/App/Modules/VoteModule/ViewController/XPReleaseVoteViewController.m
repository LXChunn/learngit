//
//  XPReleaseVoteViewController.m
//  XPApp
//
//  Created by Mac OS on 15/12/30.
//  Copyright © 2015年 ShareMerge. All rights reserved.
//

#import "NSString+Verify.h"
#import "XPAlertController.h"
#import "XPEditorVoteViewController.h"
#import "XPReleaseVoteViewController.h"
#import "XPVoteViewModel.h"
#import <Masonry/Masonry.h>
#import <XPTextView/XPTextView.h>
#import "UITextField+XPLimitLength.h"

@interface XPReleaseVoteViewController ()<UITextFieldDelegate>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-property-synthesis"
@property (strong, nonatomic) IBOutlet XPVoteViewModel *viewModel;
#pragma clang diagnostic pop
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (strong, nonatomic) IBOutlet UIView *viewType;
@property (weak, nonatomic) IBOutlet XPTextView *describeTextView;

@end

@implementation XPReleaseVoteViewController

#pragma mark - Life Circle
- (void)viewDidLoad
{
    [super viewDidLoad];
    _titleTextField.placeholder = @"请输入投票标题（1-20个字）";
    [_titleTextField rac_textSignalWithLimitLength:20];
    self.describeTextView.placeholder = @"请输入投票描述(至少10个字)";
    self.describeTextView.font = [UIFont systemFontOfSize:16];
    RAC(self.viewModel, title) = self.titleTextField.rac_textSignal;
    RAC(self.viewModel, content) = self.describeTextView.rac_textSignal;
    [self rac_liftSelector:@selector(cleverLoader:) withSignals:RACObserve(self.viewModel, executing), nil];
    [self rac_liftSelector:@selector(showToast:) withSignals:[[RACObserve(self.viewModel, error) ignore:nil] map:^id (id value) {
        return [value localizedDescription];
    }], nil];
}

#pragma mark - Delegate

#pragma mark - Event Responds
- (IBAction)nextAction:(id)sender
{
    [self.view endEditing:YES];
    if (self.viewModel.content.length >= 200) {
        self.viewModel.content = [self.viewModel.content substringToIndex:199];
    }
    if(![NSString verifyVoteTitle:self.viewModel.title content:self.viewModel.content]) {
        return;
    }
    XPEditorVoteViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"XPEditorVoteViewController"];
    viewController.voteTitle = self.viewModel.title;
    viewController.voteContent = self.viewModel.content;
    [self pushViewController:viewController];
}

#pragma mark - Private Methods

#pragma mark - Getter & Setter

@end
