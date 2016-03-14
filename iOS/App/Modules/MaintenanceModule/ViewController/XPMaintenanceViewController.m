//
//  XPMaintenanceViewController.m
//  XPApp
//
//  Created by xinpinghuang on 12/23/15.
//  Copyright 2015 ShareMerge. All rights reserved.
//

#import "NSString+Verify.h"
#import "UIViewController+BackButtonHandler.h"
#import "XPAddImageView.h"
#import "XPAlertController.h"
#import "XPMaintenanceViewController.h"
#import "XPMaintenanceViewModel.h"
#import "XPMyMaintenanceViewController.h"
#import <Masonry/Masonry.h>
#import <XPTextView/XPTextView.h>
#import <XPKit/XPKit.h>
@interface XPMaintenanceViewController ()<XPAlertControllerDelegate, BackButtonHandlerProtocol,UITextViewDelegate>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-property-synthesis"
@property (strong, nonatomic) IBOutlet XPMaintenanceViewModel *viewModel;
#pragma clang diagnostic pop

@property (weak, nonatomic) IBOutlet XPTextView *textView;
@property (weak, nonatomic) IBOutlet XPAddImageView *addImageView;
@property (weak, nonatomic) IBOutlet UIButton *typeButton;
@property (nonatomic, strong) XPAlertController *alertController;
@property (weak, nonatomic) IBOutlet UIImageView *commonArrowRight;
@property (nonatomic, strong) NSArray *typeArray;

@end

@implementation XPMaintenanceViewController

#pragma mark - Life Circle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.textView.placeholder = @"请描述您需要报修的状况(至少10个字)";
    self.textView.delegate = self;
    self.textView.font = [UIFont systemFontOfSize:16];
    self.textView.textColor = [UIColor colorWithHexString:@"#474747"];
    self.typeArray = @[@"供水报修", @"供电报修", @"燃气报修", @"其他报修"];
    RAC(self.viewModel, content) = self.textView.rac_textSignal;
    //    self.navigationItem.rightBarButtonItem.rac_command = self.viewModel.submitCommand;
    
    @weakify(self);
    RAC(self.viewModel, picUrls) = [RACObserve(self, addImageView.uploadFinshed) map:^id (id value) {
        return [value boolValue] ? self.addImageView.urls : nil;
    }];
    
    [self rac_liftSelector:@selector(cleverLoader:) withSignals:RACObserve(self.viewModel, executing), nil];
    [self rac_liftSelector:@selector(showToast:) withSignals:[[RACObserve(self.viewModel, error) ignore:nil] map:^id (id value) {
        return [value localizedDescription];
    }], nil];
    [[self.typeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self.view endEditing:YES];
        [self typeButtonTaped];
    }];
    self.commonArrowRight.userInteractionEnabled = YES;
    [self.commonArrowRight whenTapped:^{
        @strongify(self);
        [self.view endEditing:YES];
        [self typeButtonTaped];
    }];
}

#pragma mark - Delegate
#pragma mark - XPAlertControllerDelegate
- (void)alertController:(XPAlertController *)alertController didSelectRow:(NSInteger)row
{
    [self.typeButton setTitle:self.typeArray[row] forState:UIControlStateNormal];
    switch(row) {
        case 0:
        case 1:
        case 2: {
            self.viewModel.type = [NSString stringWithFormat:@"%ld", (long)row+1];
        }
            break;
            
        case 3: {
            self.viewModel.type = @"100";
        }
            break;
            
        default: {
        }
            break;
    }
}

#pragma mark - Event Responds
- (void)typeButtonTaped
{
    self.alertController = [[XPAlertController alloc] initWithActivity:self.typeArray];
    self.alertController.delegate = self;
    [self.alertController show];
}

- (IBAction)submitButtonAction:(id)sender
{
    [self.view endEditing:YES];
    @weakify(self);
    [[RACObserve(self.viewModel, successMessage) ignore:nil] subscribeNext:^(id x) {
        @strongify(self);
        [self showToast:self.viewModel.successMessage];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MyMaintenanceRefreshNotification" object:nil];
        [self goBackListAction];
    }];
    if (self.viewModel.content.length >=200) {
        self.viewModel.content = [self.viewModel.content substringToIndex:199];
    }
    if([NSString verifyPostMaintenanceContent:self.viewModel.content]) {
        [self.viewModel.submitCommand execute:nil];
    }
}

- (void)goBackListAction
{
    for(UIViewController *vc in self.navigationController.viewControllers) {
        if([vc isKindOfClass:[XPMyMaintenanceViewController class]]) {
            [self.navigationController popToViewController:vc animated:YES];
        }
    }
}

#pragma mark - Private Methods

#pragma mark - Getter & Setter

@end
