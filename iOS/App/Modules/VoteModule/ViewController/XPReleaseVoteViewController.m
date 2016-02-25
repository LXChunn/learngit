//
//  XPReleaseVoteViewController.m
//  XPApp
//
//  Created by Mac OS on 15/12/30.
//  Copyright © 2015年 ShareMerge. All rights reserved.
//

#import "XPReleaseVoteViewController.h"
#import "XPVoteViewModel.h"
#import "XPAlertController.h"
#import <XPTextView/XPTextView.h>
#import <ARAlertController/ARAlertController.h>
#import <Masonry/Masonry.h>
#import "XPEditorVoteViewController.h"
#import "XPToVoteInDetailsViewController.h"

@interface XPReleaseVoteViewController ()

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-property-synthesis"

@property (strong, nonatomic) IBOutlet XPVoteViewModel *viewModel;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;

@property (strong, nonatomic) IBOutlet UIView *viewType;
@property (weak, nonatomic) IBOutlet XPTextView *describeTextView;


@end

@implementation XPReleaseVoteViewController

#pragma mark - Life Circle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.describeTextView.placeholder = @"请输入你要发布的内容";
    RAC(self.viewModel, title) = self.titleTextField.rac_textSignal;
    RAC(self.viewModel, content) = self.describeTextView.rac_textSignal;
    
    @weakify(self);
    
    [self rac_liftSelector:@selector(cleverLoader:) withSignals:RACObserve(self.viewModel, executing), nil];
    [self rac_liftSelector:@selector(showToast:) withSignals:[[RACObserve(self.viewModel, error) ignore:nil] map:^id (id value) {
        return [value localizedDescription];
    }], nil];
    
    [[RACObserve(self, viewModel.createpostFinished) ignore:@(NO)] subscribeNext:^(id x) {
        @strongify(self);
        [self pop];
    }];
}

#pragma mark - Delegate

#pragma mark - Event Responds
- (IBAction)nextAction:(id)sender
{
    XPEditorVoteViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"XPEditorVoteViewController"];
    [self pushViewController:viewController];
}



#pragma mark - Private Methods

#pragma mark - Getter & Setter

@end 
