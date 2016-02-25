//
//  XPLoginViewController.m
//  XPApp
//
//  Created by huangxinping on 15/9/23.
//  Copyright © 2015年 iiseeuu.com. All rights reserved.
//

#import "NSString+XPValid.h"
#import "XPAutoNIBColor.h"
#import "XPLoginStorage.h"
#import "XPLoginViewController.h"
#import "XPLoginViewModel.h"
#import <XPCountDownButton/XPCountDownButton.h>
#import <XPKit/XPKit.h>

@interface XPLoginViewController ()
{
}
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-property-synthesis"
@property (strong, nonatomic) IBOutlet XPLoginViewModel *viewModel;
#pragma clang diagnostic pop
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *verificationCodeTextField;
@property (weak, nonatomic) IBOutlet UIButton *comfirmButton;
@property (weak, nonatomic) IBOutlet XPCountDownButton *verificationButton;
@end

@implementation XPLoginViewController

#pragma mark - Life Circle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    @weakify(self);
    self.navigationItem.rightBarButtonItem.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id < RACSubscriber > subscriber) {
            @strongify(self);
            [subscriber sendNext:@(1)];
            [subscriber sendCompleted];
            [self dismissViewControllerAnimated:YES completion:nil];
            return nil;
        }];
    }];
    
    RAC(self.viewModel, phone) = self.phoneTextField.rac_textSignal;
    RAC(self.viewModel, verificationCode) = self.verificationCodeTextField.rac_textSignal;
    self.comfirmButton.rac_command = self.viewModel.comfirmCommand;
    RAC(self.verificationButton, enabled) = self.viewModel.phoneSignal;
    [[self.verificationButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        self.verificationButton.enabled = NO;
        [self.viewModel.vericationCodeCommand execute:nil];
        [self.verificationButton startWithSecond:60];
        [self.verificationButton didChange:^NSString *(XPCountDownButton *countDownButton, int second) {
            NSString *title = [NSString stringWithFormat:@"剩余%d秒", second];
            return title;
        }];
        [self.verificationButton didFinished:^NSString *(XPCountDownButton *countDownButton, int second) {
            countDownButton.enabled = YES;
            return @"获取验证码";
        }];
    }];
    
    [self rac_liftSelector:@selector(cleverLoader:) withSignals:RACObserve(self.viewModel, executing), nil];
    [self rac_liftSelector:@selector(showToast:) withSignals:[[RACObserve(self.viewModel, error) ignore:nil] map:^id (id value) {
        return [value localizedDescription];
    }], nil];
    [[[RACObserve(self.viewModel, model) ignore:nil] take:1] subscribeNext:^(id x) {
        @strongify(self);
        [self dismissViewControllerAnimated:YES completion:^{

        }];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

@end
