 
//
//  XPCreatePostViewController.m
//  XPApp
//
//  Created by iiseeuu on 15/12/30.
//  Copyright 2015年 ShareMerge. All rights reserved.
//

#import "NSString+Verify.h"
#import "UIViewController+BackButtonHandler.h"
#import "XPAddImageView.h"
#import "XPAlertController.h"
#import "XPCommonContentCell.h"
#import "XPCommonTitleCell.h"
#import "XPCreatePostViewController.h"
#import "XPCreatePostViewModel.h"
#import "XPMyCommentViewController.h"
#import "XPMyPostViewController.h"
#import "XPSecondHandViewController.h"
#import "XPTopicViewController.h"
#import "XPTransferOrBuyOfSelectImageCell.h"
#import <Masonry/Masonry.h>
#import <XPTextView/XPTextView.h>

@interface XPCreatePostViewController ()<XPAlertControllerDelegate, BackButtonHandlerProtocol>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-property-synthesis"
@property (strong, nonatomic) IBOutlet XPCreatePostViewModel *viewModel;
#pragma clang diagnostic pop
@property (weak, nonatomic) IBOutlet UIBarButtonItem *submitPostMessage;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@end

@implementation XPCreatePostViewController

#pragma mark - Life Circle
- (void)viewDidLoad
{
    [super viewDidLoad];
    @weakify(self);
    [self rac_liftSelector:@selector(cleverLoader:) withSignals:RACObserve(self.viewModel, executing), nil];
    [self rac_liftSelector:@selector(showToast:) withSignals:[[RACObserve(self.viewModel, error) ignore:nil] map:^id (id value) {
        @strongify(self);
        [self hideLoader];
        return [value localizedDescription];
    }], nil];
    if(!_forumTopicModel) {
        _forumTopicModel = [[XPTransferOrBuyModel alloc] init];
    }
    [[RACObserve(self.viewModel, successMsg) ignore:nil] subscribeNext:^(id x) {
        @strongify(self);
        [self showToast:self.viewModel.successMsg];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TopicRefreshNotification" object:nil];
        [self goBackNeighborhoodList];
    }];
    [_myTableView reloadData];
    self.myTableView.separatorColor = [UIColor clearColor];
}

#pragma mark - Delegate
#pragma mark - UITableViewDelegateAndDatasource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self) weakSelf = self;
    switch(indexPath.row) {
        case 0: {
            XPCommonTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XPCommonTitleCell"];
            if(!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"XPCommonTitleCell" owner:nil options:nil] firstObject];
            }
            
            [cell configureUIWithTitle:_forumTopicModel.goodsTitle placeholder:@"请输入帖子标题（1-20个字）" block:^(NSString *text) {
                weakSelf.forumTopicModel.goodsTitle = text;
            }];
            return cell;
        }
            
        case 1: {
            XPCommonContentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XPCommonContentCell"];
            if(!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"XPCommonContentCell" owner:nil options:nil] firstObject];
            }
            [cell configureUIWithContent:_forumTopicModel.goodsDescriptions placeholder:@"请输入帖子内容（至少10个字）" block:^(NSString *text) {
                weakSelf.forumTopicModel.goodsDescriptions = text;
            }];
            return cell;
        }
            
        case 2: {
            XPTransferOrBuyOfSelectImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XPTransferOrBuyOfSelectImageCell"];
            if(!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"XPTransferOrBuyOfSelectImageCell" owner:nil options:nil] firstObject];
            }
            
            [cell whenUploadFinishImage:^(NSArray *pictures) {
                weakSelf.forumTopicModel.pictures = [NSMutableArray arrayWithArray:pictures];
            }
                               showUrls:self.forumTopicModel.pictures];
            return cell;
        }
            
        default: {
        }
            break;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch(indexPath.row) {
        case 0: {
            return 45;
        }
            
        case 1: {
            return 157;
        }
            
        case 2: {
            return 240;
        }
            
        default: {
        }
            break;
    }
    return 0.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

#pragma mark - Event Responds
- (IBAction)submitPostAction:(id)sender
{
    [self.view endEditing:YES];
    self.viewModel.type = @"1";
    if(_forumTopicId.length > 0) {
        [self updateSecondHand];
    } else {
        [self postSecondHand];
    }
}

- (void)postSecondHand
{
    @weakify(self);
    [[RACObserve(self.viewModel, successMessage) ignore:nil] subscribeNext:^(id x) {
        @strongify(self);
        [self showToast:self.viewModel.successMessage];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TopicRefreshNotification" object:nil];
        [self goBackNeighborhoodList];
    }];
    self.viewModel.model = _forumTopicModel;
    if (self.forumTopicModel.goodsDescriptions.length >= 2000) {
        self.forumTopicModel.goodsDescriptions = [self.forumTopicModel.goodsDescriptions substringToIndex:1999];
    }
    if([NSString verifyForumicTopicWithTitle:self.forumTopicModel.goodsTitle content:self.forumTopicModel.goodsDescriptions]) {
        [self.viewModel.createCommand execute:nil];
    }
}

- (void)updateSecondHand
{
    @weakify(self);
    [[RACObserve(self.viewModel, successMessage) ignore:nil] subscribeNext:^(id x) {
        @strongify(self);
        [self showToast:self.viewModel.successMessage];
        if (_pushFromType == PushFromMyPost) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"MyPostRefreshNotification" object:nil];
        }else{
              [[NSNotificationCenter defaultCenter] postNotificationName:@"TopicRefreshNotification" object:nil];
        }
      
        [self goBackNeighborhoodList];
    }];
    self.viewModel.model = _forumTopicModel;
    if (self.forumTopicModel.goodsDescriptions.length >= 2000) {
        self.forumTopicModel.goodsDescriptions = [self.forumTopicModel.goodsDescriptions substringToIndex:1999];
    }
    if([NSString verifyForumicTopicWithTitle:self.forumTopicModel.goodsTitle content:self.forumTopicModel.goodsDescriptions]) {
        self.viewModel.forumtopicId = self.forumTopicId;
        [self.viewModel.updateCommand execute:nil];
    }
}

#pragma mark -
- (BOOL)navigationShouldPopOnBackButton
{
    [self goBackNeighborhoodList];
    return NO;
}

#pragma mark - Private Methods

- (void)goBackNeighborhoodList
{
    if(_pushFromType == PushFromNeighborhood) {
        for(UIViewController *vc in self.navigationController.viewControllers) {
            if([vc isKindOfClass:[XPTopicViewController class]]) {
                [self.navigationController popToViewController:vc animated:YES];
            }
        }
    } else if(_pushFromType == PushFromMyPost) {
        for(UIViewController *vc in self.navigationController.viewControllers) {
            if([vc isKindOfClass:[XPSecondHandViewController class]]) {
                [self.navigationController popToViewController:vc animated:YES];
            }
        }
    } else if(_pushFromType == PushFromMyComment) {
        for(UIViewController *vc in self.navigationController.viewControllers) {
            if([vc isKindOfClass:[XPSecondHandViewController class]]) {
                [self.navigationController popToViewController:vc animated:YES];
            }
        }
    }
}

#pragma mark - Getter & Setter

@end
