//
//  XPIntegralExchangeViewController.m
//  XPApp
//
//  Created by CaoShunQing on 16/2/24.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import "XPIntegralExchangeViewController.h"
#import "XPIntegralExchangeViewModel.h"
#import "UIAlertView+XPKit.h"
#import "UIColor+XPKit.h"
#import "XPLoginModel.h"

@interface XPIntegralExchangeViewController ()
@property (weak, nonatomic) IBOutlet UITextField *pointTextField;
@property (weak, nonatomic) IBOutlet UILabel *pointLabel;
#pragma clang diagnostic ignored "-Wobjc-property-synthesis"
#pragma clang diagnostic push
@property (strong, nonatomic) IBOutlet XPIntegralExchangeViewModel *viewModel;
#pragma clang diagnostic pop
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pointLabelLayout;
@property (weak, nonatomic) IBOutlet UIButton *ExchangeButton;
@property (nonatomic,strong)NSString *textPoint;

@end

@implementation XPIntegralExchangeViewController

#pragma mark - Life Circle
- (void)viewDidLoad
{
    [super viewDidLoad];
    @weakify(self);
    [self rac_liftSelector:@selector(showToast:) withSignals:[[RACObserve(self.viewModel, error) ignore:nil] map:^id (id value) {
        @strongify(self);
        [self hideLoader];
        return [value localizedDescription];
    }], nil];
    [[RACObserve(self.viewModel, isSuccess) ignore:@(NO)] subscribeNext:^(id x) {
        @strongify(self);
        [XPLoginModel singleton].point = [XPLoginModel singleton].point - self.textPoint.doubleValue;
        self.pointTextField.text = @"";
    }];
    [self setUpUi];
}

#pragma mark - Delegate

#pragma mark - Event Responds
- (IBAction)Exchange:(id)sender
{
    [self.view endEditing:YES];
    if (![self isPureInt:self.pointTextField.text]||self.pointTextField.text.doubleValue>self.pointLabel.text.doubleValue||self.pointTextField.text.doubleValue <= 0) {
        [self showToast:@"请输入纯数字并确保小于您的积分数量并大于0"];
        return;
    }
    __weak typeof(self) weakSelf = self;
    [UIAlertView alertViewWithTitle:nil message:[NSString stringWithFormat:@"确定兑换%@积分吗",self.pointTextField.text] block:^(NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            weakSelf.viewModel.point = self.pointTextField.text.intValue;
            weakSelf.textPoint = self.pointTextField.text;
            [weakSelf.viewModel.ExchangeCommand execute:nil];
        }
    } cancelButtonTitle:@"确认" otherButtonTitles:@"取消", nil];
}

- (void)clickExchangeList
{
    [self.view endEditing:YES];
    [self pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"XPRecordIntegralExchangeViewController"]];
}

#pragma mark - Private Methods
- (void)setUpUi
{
    self.ExchangeButton.layer.cornerRadius = 7;
    self.ExchangeButton.layer.masksToBounds = YES;
    self.ExchangeButton.layer.borderWidth = 1.3;
    self.ExchangeButton.layer.borderColor = [UIColor colorWithHex:0x2677B5].CGColor;
    [self.ExchangeButton setTitleColor:[UIColor colorWithHex:0x2677B5] forState:UIControlStateNormal];
    
    self.textView.editable = NO;
    self.pointTextField.keyboardType = UIKeyboardTypeNumberPad;
    @weakify(self);
    [[RACObserve([XPLoginModel singleton], point) ignore:nil] subscribeNext:^(id x) {
        @strongify(self);
        self.pointLabel.text = [x stringValue];
    }];
    self.pointLabelLayout.constant = [UIScreen mainScreen].bounds.size.width;
    self.navigationItem.title = @"积分兑换";
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"兑换记录" style:UIBarButtonItemStylePlain target:self action:@selector(clickExchangeList)];
    self.navigationItem.rightBarButtonItem = rightItem;
    self.pointLabelLayout.constant = [UIScreen mainScreen].bounds.size.height*3/13;
}

- (BOOL)isPureInt:(NSString *)string
{
    NSScanner *scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}
#pragma mark - Getter & Setter

@end 
