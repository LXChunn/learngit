//
//  XPMeViewController.m
//  XPApp
//
//  Created by huangxinping on 15/10/17.
//  Copyright © 2015年 iiseeuu.com. All rights reserved.
//

#import "CExpandHeader.h"
#import "UIColor+XPKit.h"
#import "UIView+block.h"
#import "XPLoginModel.h"
#import "XPMeHeadView.h"
#import "XPMeViewController.h"
#import "XPMyCollectionViewController.h"
#import "XPMyCommentViewController.h"
#import "XPMyPostViewController.h"
#import "XPMyPrivateLetterListViewController.h"
#import "XPSecondHandViewController.h"
#import "XPTopicViewController.h"
#import "XPUnReadMessageViewModel.h"
#import "XPUserInfoViewModel.h"
#import <XPKit/XPKit.h>
#import <MJRefresh.h>
#import <UIImageView+WebCache.h>
#import <M13BadgeView/M13BadgeView.h>

@interface XPMeViewController ()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>
{
    CExpandHeader *_header;
}
@property (nonatomic, strong) XPMeHeadView *headView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet XPUnReadMessageViewModel *unReadViewModel;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-property-synthesis"
@property (strong, nonatomic) IBOutlet XPUserInfoViewModel *viewModel;
#pragma clang diagnostic pop
@end

@implementation XPMeViewController

#pragma mark - LifeCircle
- (void)viewDidLoad
{
    [super viewDidLoad];
    @weakify(self);
    [self rac_liftSelector:@selector(showToast:) withSignals:[[RACObserve(self.viewModel, error) ignore:nil] map:^id (id value) {
        return [value localizedDescription];
    }], nil];
    self.tableView.separatorColor = [UIColor clearColor];
    _headView = [[[NSBundle mainBundle] loadNibNamed:@"XPMeHeadView" owner:nil options:nil] lastObject];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0)
    {
        _headView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 154);
    }
    _header = [CExpandHeader expandWithScrollView:_tableView expandView:_headView];
    _headView.userInteractionEnabled = YES;
    [self.tableView bringSubviewToFront:self.headView];
    [_headView whenTapped:^{
        @strongify(self);
        if(![self isLogin])
        {
            [self presentLogin];
        }
        else
        {
            if(![self isBindHouse])
            {
                [self presentBindHouse];
            }
            else
            {
                [self pushViewController:[self instantiateViewControllerWithStoryboardName:@"UserInfo" identifier:@"XPUserInfoCenterViewController"]];
            }
        }
    }];
    [[_headView.settingButon rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self pushViewController:[self instantiateViewControllerWithStoryboardName:@"Setting" identifier:@"XPSettingViewController"]];
    }];
    [[RACObserve(self, viewModel.model) ignore:nil] subscribeNext:^(id x) {
        @strongify(self);
        [self configureTableView];
    }];
    [[RACObserve(self, unReadViewModel.unReadMessageCounte) ignore:nil] subscribeNext:^(id x) {
        @strongify(self);
        [self.tableView reloadData];
    }];
    [[RACObserve(self, unReadViewModel.unReadSystemMessageCounte) ignore:nil] subscribeNext:^(id x) {
        @strongify(self);
        [self.tableView reloadData];
    }];
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"ReloadPrivateMessageNotification" object:nil] subscribeNext:^(id x) {
        @strongify(self);
        [self.unReadViewModel.unReadCommand execute:nil];
    }];
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"ReloadSystemMessageNotification" object:nil] subscribeNext:^(id x) {
        @strongify(self);
        [self.unReadViewModel.unReadSystemMessageCommand execute:nil];
    }];
}

- (void)configureTableView
{
    if([self isLogin]) {
        _headView.userInfoView.hidden = NO;
        _headView.UnLoginLabel.hidden = YES;
        _headView.avatorImageView.contentMode = UIViewContentModeScaleAspectFill;
        [_headView.avatorImageView sd_setImageWithURL:[NSURL URLWithString:[XPLoginModel singleton].avatarUrl] placeholderImage:[UIImage imageNamed:@"common_default_avatar"]];
        _headView.nameLabel.text = [XPLoginModel singleton].nickname;
        _headView.addressLabel.text = [XPLoginModel singleton].household.communityTitle;
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self configureTableView];
    if(![self isLogin]) {
        _headView.avatorImageView.image = [UIImage imageNamed:@"common_default_avatar"];
        _headView.userInfoView.hidden = YES;
        _headView.UnLoginLabel.hidden = NO;
    } else {
        [self.viewModel.userInfoCommand execute:nil];
        [self.unReadViewModel.unReadSystemMessageCommand execute:nil];
        [self.unReadViewModel.unReadCommand execute:nil];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

#pragma mark - Delegate

#pragma mark UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}

#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0){
        return 2;
    }
    if(section == 1) {
        return 3;
    }
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 12.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 12)];
    view.backgroundColor = [UIColor colorWithHex:0xf1f1f1];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommonCell"];
    if(!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CommonCell" owner:nil options:nil] lastObject];
    }
    UILabel *label = [cell viewWithTag:20];
    UIImageView *iconImageView = [cell viewWithTag:10];
    UILabel *lineLabel = [cell viewWithTag:30];
    if(indexPath.section == 0) {
        if (indexPath.row == 0) {
            label.text = @"系统消息";
            iconImageView.image = [UIImage imageNamed:@"me_system_ico"];
            lineLabel.hidden = NO;
            UIImageView *unReadImageView = [cell viewWithTag:40];
            unReadImageView.hidden = NO;
            M13BadgeView * badgeView = [[M13BadgeView alloc] initWithFrame:CGRectMake(0, 0, 16.0, 16.0)];
            badgeView.hidesWhenZero = YES;
            badgeView.font = [UIFont systemFontOfSize:12];
            badgeView.horizontalAlignment = M13BadgeViewHorizontalAlignmentRight;
            badgeView.verticalAlignment = M13BadgeViewVerticalAlignmentTop;
            if (self.unReadViewModel.unReadSystemMessageCounte >= 99) {
                badgeView.text = @"99+";
            }
            else if (self.unReadViewModel.unReadSystemMessageCounte < 1){
                unReadImageView.hidden = YES;
            }
            else{
                badgeView.text = [@(self.unReadViewModel.unReadSystemMessageCounte) stringValue];
            }
            [unReadImageView addSubview:badgeView];
        }
        else{
            label.text = @"我的私信";
            iconImageView.image = [UIImage imageNamed:@"me_message_ico"];
            lineLabel.hidden = YES;
            UIImageView *unReadImageView = [cell viewWithTag:40];
            unReadImageView.hidden = NO;
            M13BadgeView * badgeView = [[M13BadgeView alloc] initWithFrame:CGRectMake(0, 0, 16.0, 16.0)];
            badgeView.hidesWhenZero = YES;
            badgeView.font = [UIFont systemFontOfSize:12];
            badgeView.horizontalAlignment = M13BadgeViewHorizontalAlignmentRight;
            badgeView.verticalAlignment = M13BadgeViewVerticalAlignmentTop;
            if (self.unReadViewModel.unReadMessageCounte >= 99) {
                badgeView.text = @"99+";
            }
            else if (self.unReadViewModel.unReadMessageCounte < 1){
                unReadImageView.hidden = YES;
            }
            else{
                badgeView.text = [@(self.unReadViewModel.unReadMessageCounte) stringValue];
            }
            [unReadImageView addSubview:badgeView];
        }
    } else if(indexPath.section == 1) {
        if(indexPath.row == 0) {
            label.text = @"我的发布";
            iconImageView.image = [UIImage imageNamed:@"me_publish_ico"];
            lineLabel.hidden = NO;
        } else if(indexPath.row == 1) {
            label.text = @"我的评论";
            iconImageView.image = [UIImage imageNamed:@"me_reply_ico"];
            lineLabel.hidden = NO;
        } else {
            label.text = @"我的收藏";
            iconImageView.image = [UIImage imageNamed:@"me_favorites_ico"];
            lineLabel.hidden = YES;
        }
    } else {
        if (indexPath.row== 0) {
            label.text = @"我的活动";
            iconImageView.image = [UIImage imageNamed:@"me_activity_ico"];
            lineLabel.hidden = NO;
        }else if(indexPath.row==1){
            label.text = @"我的拼车";
            iconImageView.image = [UIImage imageNamed:@"my_car_ico"];
            lineLabel.hidden = NO;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(![self isLogin]) {
        [self presentLogin];
    } else {
        if(![self isBindHouse]) {
            [self presentBindHouse];
        }
        else{
            if(indexPath.section == 0) {
                if (indexPath.row == 0) {
                    [self pushViewController:[self instantiateInitialViewControllerWithStoryboardName:@"SystemMessage"]];
                }else{
                    [self pushViewController:[self instantiateInitialViewControllerWithStoryboardName:@"MyPrivateLetter"]];
                }
            } else if(indexPath.section == 1) {
                UIViewController *viewController = [self instantiateInitialViewControllerWithStoryboardName:@"SecondHand"];
                XPSecondHandViewController *controller = (XPSecondHandViewController *)viewController;
                switch(indexPath.row) {
                    case 0: {
                        controller.mineType = MineTypeOfPost;
                        break;
                    }
                        
                    case 1: {
                        controller.mineType = MineTypeOfComment;
                        break;
                    }
                        
                    case 2: {
                        controller.mineType = MineTypeOfCollection;
                        break;
                    }
                        
                    default: {
                    }
                        break;
                }
                [self pushViewController:viewController];
            } else if(indexPath.section == 2) {
                if (indexPath.row==0) {
                    [self pushViewController:[self instantiateInitialViewControllerWithStoryboardName:@"MyActivity"]];
                }else if(indexPath.row == 1){
                    [self pushViewController:[self instantiateViewControllerWithStoryboardName:@"Carpool" identifier:@"XPMyCarpoolViewController"]];
                    ;
                }
            }
        }
    }
}

@end
