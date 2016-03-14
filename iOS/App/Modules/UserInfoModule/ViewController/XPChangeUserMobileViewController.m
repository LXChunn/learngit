//
//  XPChangeUserMobileViewController.m
//  XPApp
//
//  Created by CaoShunQing on 16/1/15.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import "XPChangeUserMobileViewController.h"
#import "XPVerificationCodeViewModel.h"
#import "XPLoginModel.h"
#import "XPAPIManager+Login.h"
#import "XPChangeNewMobileViewController.h"
#import <XPCountDownButton/XPCountDownButton.h>
#import <XPKit/XPKit.h>
#import "NSString+Verify.h"

@interface XPChangeUserMobileViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-property-synthesis"
@property (strong, nonatomic) IBOutlet XPVerificationCodeViewModel *viewModel;
@property (nonatomic,strong)UITextField *oldVericodeTextField;
#pragma clang diagnostic pop
@property (nonatomic,assign)BOOL isClick;
@property (nonatomic,strong)XPCountDownButton *RequsetVerificationButton;
@end

@implementation XPChangeUserMobileViewController
//{
//    NSTimer *timer;
//    NSTimer *otherTimer;
//}
#pragma mark - Life Circle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self rac_liftSelector:@selector(cleverLoader:) withSignals:RACObserve(self.viewModel, executing), nil];
    [self rac_liftSelector:@selector(showToast:) withSignals:[[RACObserve(self.viewModel, error) ignore:nil] map:^id (id value) {
        return [value localizedDescription];
    }], nil];
    self.navigationItem.title = @"手机号更换";
    _tableView.tableFooterView = [[UIView alloc]init];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.scrollEnabled = NO;
    [[RACObserve(self.viewModel, isRecciveSuccess) ignore:nil] subscribeNext:^(id x) {
            [_RequsetVerificationButton startWithSecond:60];
    }];
//    timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(fuckRenWenTao) userInfo:nil repeats:YES];
//    otherTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(fuckRenWenTao2) userInfo:nil repeats:YES];
}
//
//- (void)fuckRenWenTao
//{
//  self.viewModel.phone = @"15239938380";
//    [self.viewModel.verCodelCommand execute:nil];
//}
//
//- (void)fuckRenWenTao2
//{
//    self.viewModel.phone = @"13303815712";
//    [self.viewModel.verCodelCommand execute:nil];
//}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"XPChangeNewMobileViewController"]) {
        XPChangeNewMobileViewController *controller = segue.destinationViewController;
        controller.oldVerificationCode = self.oldVericodeTextField.text;
    }
}

#pragma mark - Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        return 62;
    }
    if (indexPath.row==1) {
        return 53;
    }
    return self.tableView.frame.size.height-62-53;

}
#pragma mark - DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    tableView.separatorColor = [UIColor clearColor];
    if (indexPath.row==0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"Onecell" forIndexPath:indexPath];
        UILabel *oldMobileLabel = [cell viewWithTag:10];
        oldMobileLabel.text = [[XPLoginModel singleton].mobile stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (indexPath.row==1) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"Seccell" forIndexPath:indexPath];
        _oldVericodeTextField = [cell viewWithTag:11];
        _RequsetVerificationButton = [cell viewWithTag:12];
        @weakify(self);
        [[_RequsetVerificationButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            [self.view endEditing:NO];
            self.isClick = YES;
            self.viewModel.phone = [XPLoginModel singleton].mobile;
            [self.viewModel.verCodelCommand execute:nil];
            _RequsetVerificationButton.enabled = NO;
            [_RequsetVerificationButton didChange:^NSString *(XPCountDownButton *countDownButton, int second) {
                NSString *title = [NSString stringWithFormat:@"剩余%d秒", second];
                return title;
            }];
            [_RequsetVerificationButton didFinished:^NSString *(XPCountDownButton *countDownButton, int second) {
                countDownButton.enabled = YES;
                return @"获取验证码";
            }];
        }];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (indexPath.row == 2) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"Thrcell" forIndexPath:indexPath];
        UIButton *nextButton = [cell viewWithTag:13];
        [[nextButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            [self.view endEditing:NO];
            if (self.isClick == NO ) {
                [self showToast:@"您还没获取验证码!"];
                return;
            }
            if (self.oldVericodeTextField.text.length == 6&&[self isPureInt:self.oldVericodeTextField.text]) {
                [self performSegueWithIdentifier:@"XPChangeNewMobileViewController" sender:self];
            }else{
                [self showToast:@"请正确填写六位数字验证码"];
            }
        }];
        nextButton.layer.cornerRadius = 3.51;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - Event Responds

#pragma mark - Private Methods
- (BOOL)isPureInt:(NSString *)string
{
    NSScanner *scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}
#pragma mark - Getter & Setter

@end 
