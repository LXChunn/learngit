//
//  XPComplaintViewController.m
//  XPApp
//
//  Created by xinpinghuang on 12/23/15.
//  Copyright 2015 ShareMerge. All rights reserved.
//

#import "NSString+Verify.h"
#import "UIViewController+BackButtonHandler.h"
#import "XPAddImageView.h"
#import "XPAlertController.h"
#import "XPComplaintViewController.h"
#import "XPComplaintViewModel.h"
#import "XPListComplaintViewController.h"
#import <Masonry/Masonry.h>
#import <XPTextView/XPTextView.h>

@interface XPComplaintViewController ()<BackButtonHandlerProtocol, UITextViewDelegate>
@property (strong, nonatomic) IBOutlet XPComplaintViewModel *complaintViewModel;
@property (nonatomic, weak) IBOutlet XPTextView *textView;
@property (nonatomic, weak) IBOutlet XPAddImageView *addImageView;
@property (nonatomic, weak) IBOutlet UIView *contentView;

@end

@implementation XPComplaintViewController

#pragma mark - Life Circle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.textView.placeholder = @"请描述您需要投诉的状况(至少10个字)";
    self.textView.font = [UIFont systemFontOfSize:16];
    self.textView.delegate = self;
    RAC(self.complaintViewModel, content) = self.textView.rac_textSignal;
    RAC(self.complaintViewModel, picUrls) = [RACObserve(self, addImageView.uploadFinshed) map:^id (id value) {
        return [value boolValue] ? self.addImageView.urls : nil;
    }];
    [self rac_liftSelector:@selector(cleverLoader:) withSignals:RACObserve(self.complaintViewModel, executing), nil];
    [self rac_liftSelector:@selector(showToast:) withSignals:[[RACObserve(self.complaintViewModel, error) ignore:nil] map:^id (id value) {
        return [value localizedDescription];
    }], nil];
}

- (IBAction)submitButtonAction:(id)sender
{
    [self.view endEditing:YES];
    @weakify(self);
    [[RACObserve(self.complaintViewModel, successMsg) ignore:nil] subscribeNext:^(id x) {
        @strongify(self);
        [self showToast:self.complaintViewModel.successMsg];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ComplaintRefreshNotification" object:nil];
        [self goBackListAction];
    }];
    if (self.complaintViewModel.content.length >= 500) {
        self.complaintViewModel.content = [self.complaintViewModel.content substringToIndex:499];
    }
    if([NSString verifyPostComplaintContent:self.complaintViewModel.content]) {
        [self.complaintViewModel.complaintCommand execute:nil];
    }
}

- (void)goBackListAction
{
    for(UIViewController *vc in self.navigationController.viewControllers) {
        if([vc isKindOfClass:[XPListComplaintViewController class]]) {
            [self.navigationController popToViewController:vc animated:YES];
        }
    }
}

#pragma mark - Delegate

#pragma mark - Event Responds

#pragma mark - Private Methods

#pragma mark - Getter & Setter

@end
