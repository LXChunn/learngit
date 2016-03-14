//
//  XPChangeNewMobileViewController.m
//  XPApp
//
//  Created by CaoShunQing on 16/1/15.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import "XPChangeNewMobileViewController.h"
#import "XPChangeUserMobileViewModel.h"
#import "XPLoginModel.h"
#import "XPCountDownButton.h"
#import "NSString+Verify.h"

@interface XPChangeNewMobileViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-property-synthesis"
@property (strong, nonatomic) IBOutlet XPChangeUserMobileViewModel *viewModel;
#pragma clang diagnostic pop
@property (nonatomic,strong)UITextField *nowPhoneTextField;
@property (nonatomic,strong)UITextField *nowoldVerificationCodeTextField;
@property (nonatomic,strong)XPCountDownButton *verificationCodeButton;
@property (nonatomic,assign)BOOL isDidClick;
@end

@implementation XPChangeNewMobileViewController

#pragma mark - Life Circle
- (void)viewDidLoad
{
    [super viewDidLoad];
    @weakify(self);
    [self rac_liftSelector:@selector(cleverLoader:) withSignals:RACObserve(self.viewModel, executing), nil];
    [self rac_liftSelector:@selector(showToast:) withSignals:[[RACObserve(self.viewModel, error) ignore:nil] map:^id (id value) {
        return [value localizedDescription];
    }], nil];
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.scrollEnabled = NO;
    
    [[RACObserve(self.viewModel, model) ignore:nil] subscribeNext:^(id x) {
        @strongify(self);
        [self popToRoot];
    }];
    [[RACObserve(self.viewModel, isReceiveCodeSuccess) ignore:nil] subscribeNext:^(id x) {
            [_verificationCodeButton startWithSecond:60];
    }];
    self.navigationItem.title = @"手机号更换";
}

#pragma mark - Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2) {
        return self.tableView.frame.size.height - 46*2;
    }
    return 46;
}

#pragma mark - DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"Onecell" forIndexPath:indexPath];        
        _nowPhoneTextField = [cell viewWithTag:10];
        [[_nowPhoneTextField rac_signalForControlEvents:UIControlEventEditingChanged] subscribeNext:^(id x) {
            [self textFieldValueChanged];
        }];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (indexPath.row == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"Seccell" forIndexPath:indexPath];
        _nowoldVerificationCodeTextField = [cell viewWithTag:11];
        _nowPhoneTextField.clearButtonMode = UITextFieldViewModeAlways;
        _verificationCodeButton = [cell viewWithTag:12];
        _verificationCodeButton.enabled = NO;
        @weakify(self);
        [[_verificationCodeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            if (![NSString verifyChangeUserPhoneWithMobile:self.nowPhoneTextField.text verifyCode:nil]) {
                return ;
            }
                if (![self isPureInt:self.nowPhoneTextField.text]) {
                    [self showToast:@"手机号须为11位数字"];
                }else
                {
                    [[_verificationCodeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                        @strongify(self);
                        _verificationCodeButton.enabled = NO;
                        self.viewModel.nowPhone = self.nowPhoneTextField.text;
                        [self.viewModel.verFicationCodeCommand execute:nil];
                        [_verificationCodeButton didChange:^NSString *(XPCountDownButton *countDownButton, int second) {
                            NSString *title = [NSString stringWithFormat:@"剩余%d秒", second];
                            self.isDidClick = YES;
                            return title;
                        }];
                        [_verificationCodeButton didFinished:^NSString *(XPCountDownButton *countDownButton, int second) {
                            self.isDidClick = NO;
                            if (self.nowPhoneTextField.text.length==11) {
                                countDownButton.enabled = YES;
                            }
                            return @"获取验证码";
                        }];
                    }];
                }
        }];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    cell = [tableView dequeueReusableCellWithIdentifier:@"Thrcell" forIndexPath:indexPath];
    UIButton *requestButton = [cell viewWithTag:13];
    [[requestButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        if (![self isPureInt:self.nowoldVerificationCodeTextField.text]) {
            [self showToast:@"验证码须为数字"];
            return;
        }
        if ([NSString verifyChangeUserPhoneWithMobile:self.nowPhoneTextField.text verifyCode:self.nowoldVerificationCodeTextField.text]) {
            self.viewModel.oldPhone = [XPLoginModel singleton].mobile;
            self.viewModel.oldVerificationCode = self.oldVerificationCode;
            self.viewModel.nowPhone = self.nowPhoneTextField.text;
            self.viewModel.nowVerificationCode = self.nowoldVerificationCodeTextField.text;
            [self.viewModel.userNewPhoneCommand execute:nil];
        }
    }];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    requestButton.layer.cornerRadius = 3.51;
    return cell;
}
#pragma mark - Event Responds
- (void)textFieldValueChanged
{
    if (self.nowPhoneTextField.text.length>0) {
        if (![[self.nowPhoneTextField.text substringToIndex:1] isEqualToString:@"1"]) {
            _verificationCodeButton.enabled = NO;
            return;
        }
    }
    if (self.nowPhoneTextField.text.length!=11) {
        _verificationCodeButton.enabled = NO;
        return;
    }
    _verificationCodeButton.enabled = YES;
    if (self.isDidClick==YES) {
        _verificationCodeButton.enabled = NO;
    }
}

#pragma mark - Private Methods
- (BOOL)isPureInt:(NSString *)string
{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}
#pragma mark - Getter & Setter

@end 
