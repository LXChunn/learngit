
//
//  XPCreatePostViewController.m
//  XPApp
//
//  Created by iiseeuu on 15/12/30.
//  Copyright 2015年 ShareMerge. All rights reserved.
//

#import "XPCreatePostViewController.h"
#import "XPAddImageView.h"
#import "XPCreatePostViewModel.h"
#import "XPAlertController.h"
#import <XPTextView/XPTextView.h>
#import <ARAlertController/ARAlertController.h>
#import <Masonry/Masonry.h>


@interface XPCreatePostViewController ()<XPAlertControllerDelegate>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-property-synthesis"

@property (strong, nonatomic) IBOutlet XPCreatePostViewModel *viewModel;
#pragma clang diagnostic pop
@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (weak, nonatomic) IBOutlet XPTextView *textView;
@property (weak, nonatomic) IBOutlet XPAddImageView *addImageView;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *submitPostMessage;


@end

@implementation XPCreatePostViewController

#pragma mark - Life Circle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.textView.placeholder = @"请输入你要发布的内容";
    RAC(self.viewModel, content) = self.textView.rac_textSignal;
//    self.navigationItem.rightBarButtonItem.rac_command = self.viewModel.createpostCommand;
    if(_topicTitle)
    {
        self.textField.text = _topicTitle;
        self.textView.text = _topicContent;
    }
 
    @weakify(self);
    RAC(self.viewModel, picUrls) = [RACObserve(self, addImageView.uploadFinshed) map:^id (id value) {
        return [value boolValue] ? self.addImageView.urls : nil;
    }];
    
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
- (IBAction)submitPostAction:(id)sender {
    
    [self.view endEditing:YES];
    @weakify(self);
    [[RACObserve(self.viewModel, successMsg) ignore:nil] subscribeNext:^(id x) {
        @strongify(self);
        [self showToast:self.viewModel.successMsg];
        [self pop];
    }];
    
    self.textView.text = @"发布的信息内容";
    self.textField.text = @"发布的信息标题";
    if (_textField.text.length < 1)
    {
        [self showToast:@"请输入发布信息标题"];
        return;
    }
    [self.viewModel.createpostCommand execute:nil];
    
    
}



#pragma mark - Private Methods

#pragma mark - Getter & Setter

@end 
