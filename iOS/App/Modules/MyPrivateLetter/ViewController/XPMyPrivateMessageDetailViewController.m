//
//  XPMyPrivateMessageDetailViewController.m
//  XPApp
//
//  Created by jy on 16/1/9.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import "NSDate+DateTools.h"
#import "NSString+Category.h"
#import "NSString+Verify.h"
#import "UIView+HESizeHeight.h"
#import "XPMessageDetailModel.h"
#import "XPMyPrivateMessageDetailViewController.h"
#import "XPMySendMessageCell.h"
#import "XPPrivateMessageDetailViewModel.h"
#import "XPReceiveMessageCell.h"
#import <MJRefresh.h>
#import "XPCommonRefreshHeader.h"
#import "XPCommonRefreshFooter.h"
#import "XPAuthorModel.h"
#import "XPLoginModel.h"

@interface XPMyPrivateMessageDetailViewController ()<UITextViewDelegate, UITableViewDelegate, UITableViewDataSource>
{
    BOOL _isPullDown;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sendViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sendViewBottomLayoutConstraint;
@property (weak, nonatomic) IBOutlet UITextView *commentInputTextView;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
#pragma clang diagnostic ignored "-Wobjc-property-synthesis"
#pragma clang diagnostic push
@property (strong, nonatomic) IBOutlet XPPrivateMessageDetailViewModel *viewModel;
#pragma clang diagnostic pop
@end

@implementation XPMyPrivateMessageDetailViewController

#pragma mark - Life Circle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = _userModel.nickname;
    @weakify(self);
    [self showFirstHud];
    [self rac_liftSelector:@selector(showToast:) withSignals:[[RACObserve(self.viewModel, error) ignore:nil] map:^id (id value) {
        @strongify(self);
        [self.myTableView.mj_header endRefreshing];
        [self.myTableView.mj_footer endRefreshing];
        [self hideFirstHud];
        [self hideLoader];
        return [value localizedDescription];
    }], nil];
    [[RACObserve(self.viewModel, list) ignore:nil] subscribeNext:^(id x) {
        @strongify(self);
        [self.myTableView reloadData];
        if(!_isPullDown) {
            if(self.myTableView.contentSize.height > self.view.bounds.size.height - 51) {
                [self.myTableView setContentOffset:CGPointMake(0, self.myTableView.contentSize.height - self.myTableView.bounds.size.height) animated:NO];
            }
        }
        [self hideFirstHud];
        [self hideLoader];
        [self.myTableView.mj_header endRefreshing];
        [self.myTableView.mj_footer endRefreshing];
    }];
    [[RACObserve(self, viewModel.isSendSuccess) ignore:@(NO)] subscribeNext:^(id x) {
        @strongify(self);
        _commentInputTextView.text = @"";
        _sendViewHeight.constant = 51;
        [self hideLoader];
        if(self.myTableView.contentSize.height > self.view.bounds.size.height - 51) {
            [self.myTableView setContentOffset:CGPointMake(0, self.myTableView.contentSize.height - self.myTableView.bounds.size.height) animated:YES];
        }
    }];
    self.viewModel.contactUserId = self.userModel.userId;
    [self.viewModel.reloadCommand execute:nil];
    self.myTableView.mj_header = [XPCommonRefreshHeader headerWithRefreshingBlock:^{
        @strongify(self);
        _isPullDown = YES;
        [self.viewModel.moreCommand execute:nil];
    }];
    [self registerForKeyboardNotifications];
    self.myTableView.separatorColor = [UIColor clearColor];
}

#pragma mark - Delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self) weakSelf = self;
    XPMessageDetailModel *model = [self.viewModel.list objectAtIndex:indexPath.row];
    if([model.type isEqualToString:@"1"]) {
        XPMySendMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XPMySendMessageCell"];
        [cell bindModel:model];
        [cell whenClickAvatorWithBlock:^{
            XPAuthorModel *userModel = [[XPAuthorModel alloc] init];
            userModel.nickname = [XPLoginModel singleton].nickname;
            userModel.avatarUrl = [XPLoginModel singleton].avatarUrl;
            userModel.userId = [XPLoginModel singleton].userId;
            [weakSelf goOtherUserInfoCenterWithModel:userModel];
        }];
        return cell;
    } else {
        XPReceiveMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XPReceiveMessageCell"];
        cell.avatroUrl = _userModel.avatarUrl;
        [cell bindModel:model];
        [cell whenClickAvatorWithBlock:^{
            [weakSelf goOtherUserInfoCenterWithModel:_userModel];
        }];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XPMessageDetailModel *model = [self.viewModel.list objectAtIndex:indexPath.row];
    return 69 + [UIView getTextSizeHeight:model.content font:14 withSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 161, MAXFLOAT)];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewModel.list.count;
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView{
    float height = [UIView getTextSizeHeight:textView.text font:14 withSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 86, MAXFLOAT)];
    if (height < 18) {
        _sendViewHeight.constant = 51;
    }else if (height > 18 && height < 18*2){
        _sendViewHeight.constant = 51 + 19;
    }else if (height > 18*2 && height < 18*3){
        _sendViewHeight.constant = 51 + 19*2;
    }else if (height > 18*3){
        _sendViewHeight.constant = 51 + 19*3;
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    
}

#pragma mark - Event Responds
- (IBAction)sendAction:(id)sender{
    [self.view endEditing:YES];
    if(![NSString verifyPrivateMessage:_commentInputTextView.text]) {
        return;
    }
    if([_commentInputTextView.text isBlank]) {
        return;
    }
    [self showLoader];
    XPMessageDetailModel * model = [[XPMessageDetailModel alloc] init];
    model.content = _commentInputTextView.text;
    model.type = @"1";
    self.viewModel.detailModel = model;
    [self.viewModel.sendMessageCommand execute:nil];
}

#pragma mark - Private Methods
#pragma mark - 键盘 (created by jy time:2015-3-16)
- (void)registerForKeyboardNotifications
{
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillShowNotification object:nil] subscribeNext:^(id x) {
        [self handleKeyboardWillShowNote:nil];
    }];
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillHideNotification object:nil] subscribeNext:^(id x) {
        [self handleKeyboardWillHideNote:nil];
    }];
}

- (void)handleKeyboardWillShowNote:(NSNotification *)notification
{
    __weak typeof(self) weakSelf = self;
    CGRect keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey]doubleValue];
    [UIView animateWithDuration:duration animations:^{
        weakSelf.sendViewBottomLayoutConstraint.constant = keyboardRect.size.height;
    }completion:^(BOOL finished) {
        
    }];
}

- (void)handleKeyboardWillHideNote:(NSNotification *)notification
{
    __weak typeof(self) weakSelf = self;
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey]doubleValue];
    [UIView animateWithDuration:duration animations:^{
        weakSelf.sendViewBottomLayoutConstraint.constant = 0;
    }completion:^(BOOL finished) {
    }];
}

#pragma mark - Getter & Setter

@end
