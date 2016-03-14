//
//  XPSuggestionViewController.m
//  XPApp
//
//  Created by CaoShunQing on 16/1/12.
//  Copyright © 2016年 ShareMerge. All rights reserved.
//

#import "XPSuggestionViewController.h"
#import "XPSettingViewModel.h"
#import <XPTextView.h>

@interface XPSuggestionViewController ()

@property (weak, nonatomic) IBOutlet XPTextView *textView;

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-property-synthesis"
@property (strong, nonatomic) IBOutlet XPSettingViewModel *viewModel;
#pragma clang diagnostic pop
@property (weak, nonatomic) IBOutlet UIButton *suggesstionButton;

@end

@implementation XPSuggestionViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self.navigationItem setTitle:@"意见反馈"];
    @weakify(self);
    [self rac_liftSelector:@selector(cleverLoader:) withSignals:RACObserve(self.viewModel, executing), nil];
    [self rac_liftSelector:@selector(showToast:) withSignals:[[RACObserve(self.viewModel, error) ignore:nil] map:^id (id value) {
        return [value localizedDescription];
    }], nil];
    self.textView.layer.cornerRadius = 5;
    self.textView.translatesAutoresizingMaskIntoConstraints = NO;
    self.suggesstionButton.layer.cornerRadius = 3.51;
    _textView.layer.borderColor = UIColor.grayColor.CGColor;
    _textView.layer.borderWidth = 1;
    _textView.layer.cornerRadius = 6;
    _textView.font = [UIFont systemFontOfSize:14];
    [[RACObserve(self, viewModel.isSuccess) ignore:nil] subscribeNext:^(id x) {
        @strongify(self);
        if (self.viewModel.isSuccess) {
//            [self showToast:@"您的意见已经提交，谢谢您的支持！"];
            [self pop];
        }
    }];
}

- (IBAction)request:(id)sender
{
    [self.view endEditing:YES];
    if (self.textView.text.length == 0) {
        [self showToast:@"请填写您的意见"];
        return;
    }
    if (self.textView.text.length >= 200) {
        self.textView.text = [self.textView.text substringToIndex:199];
    }
    NSString * version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    self.viewModel.version = [version integerValue];
    self.viewModel.type = @"0";
    self.viewModel.content = self.textView.text;
    [self.viewModel.requestCommand execute:nil];
}

@end
