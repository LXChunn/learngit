//
//  XPMyCommentViewController.m
//  XPApp
//
//  Created by jy on 16/1/8.
//  Copyright 2016年 ShareMerge. All rights reserved.
//
#import "XPCommonTableViewCell.h"
#import "XPDetailPostViewController.h"
#import "XPEventDetailViewController.h"
#import "XPMyCommentListModel.h"
#import "XPMyCommentViewController.h"
#import "XPMyCommentViewModel.h"
#import "XPSecondHandOfPostDetailViewController.h"
#import "XPTopicModel.h"
#import "XPVoteDetailViewController.h"
#import <DateTools/DateTools.h>
#import <MJRefresh/MJRefresh.h>
#import <UIImageView+WebCache.h>
#import "XPCommonRefreshHeader.h"
#import "UIView+HESizeHeight.h"
#import "XPCommonRefreshFooter.h"
#import "XPHousekeepingDetailViewController.h"

@interface XPMyCommentViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableview;
#pragma clang diagnostic ignored "-Wobjc-property-synthesis"
#pragma clang diagnostic push
@property (strong, nonatomic) IBOutlet XPMyCommentViewModel *viewModel;
#pragma clang diagnostic pop
@property (strong, nonatomic) XPTopicModel *model;
@property (strong, nonatomic) UILabel *contentLabel;
@end

@implementation XPMyCommentViewController

#pragma mark - Life Circle
- (void)viewDidLoad
{
    [super viewDidLoad];
    @weakify(self);
    if(self.pageIndex == 0) {
        self.viewModel.type = @"1";
    } else {
        self.viewModel.type = @"2";
    }
    self.tableview.tableFooterView = [[UIView alloc]init];
    [self showFirstHud];
    [self rac_liftSelector:@selector(showToast:) withSignals:[[RACObserve(self.viewModel, error) ignore:nil] map:^id (id value) {
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
        [self hideFirstHud];
        if(self.viewModel.myCommentArray.count < 1) {
            @strongify(self);
            [self showNonetworkViewWithBlock:^{
                @strongify(self);
                [self.viewModel.mycommentsCommand execute:nil];
            }];
        }
        return [value localizedDescription];
    }], nil];
    [[RACObserve(self.viewModel, myCommentArray) ignore:nil] subscribeNext:^(id x) {
        @strongify(self);
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
        [self hideFirstHud];
        if (self.viewModel.myCommentArray.count<1) {
            [self showNoDataViewWithType:NoDataTypeOfComment];
            return ;
        }
        [self.tableview reloadData];
        [self removeNoNetworkView];
    }];
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"MyCommentRefreshNotification" object:nil] subscribeNext:^(id x) {
        @strongify(self);
        [self.viewModel.mycommentsCommand execute:nil];
    }];
    [self.viewModel.mycommentsCommand execute:nil];
    [[RACObserve(self.viewModel, isNoMoreDate) ignore:@(NO)] subscribeNext:^(id x) {
        @strongify(self);
        [self.tableview.mj_footer endRefreshingWithNoMoreData];
    }];
    self.tableview.mj_header = [XPCommonRefreshHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self.viewModel.mycommentsCommand execute:nil];
    }];
    self.tableview.mj_footer = [XPCommonRefreshFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self.viewModel.moreCommentsCommand execute:nil];
    }];
}

#pragma mark - Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewModel.myCommentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mycommentcell" forIndexPath:indexPath];
    UIImageView *avatarButton = [cell viewWithTag:11];
    UILabel *nikenameLable = [cell viewWithTag:12];
    UILabel *timeLabel = [cell viewWithTag:13];
    _contentLabel = [cell viewWithTag:14];
    UILabel *titleLabel = [cell viewWithTag:15];
    XPMyCommentListModel *model = self.viewModel.myCommentArray[indexPath.row];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.createdAt.doubleValue];
    timeLabel.text = [date formattedDateWithFormat:@"YYYY-MM-dd hh:mm"];
    nikenameLable.text = model.otherSide.nickname;
    _contentLabel.text = model.content;
    titleLabel.text = [NSString stringWithFormat:@"%@:%@", [self topicType:model.topicType], model.topicTitle];
    [avatarButton sd_setImageWithURL:[NSURL URLWithString:model.otherSide.avatarUrl] placeholderImage:[UIImage imageNamed:@"common_default_avatar"]];
    avatarButton.layer.masksToBounds = YES;
    avatarButton.layer.cornerRadius = 19.5;
    tableView.separatorColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    XPMyCommentListModel *topicModel = [self.viewModel.myCommentArray objectAtIndex:indexPath.row];
    switch ([topicModel.topicType integerValue]) {
        case 1 :
        {
            XPDetailPostViewController *controller = (XPDetailPostViewController *)[self instantiateViewControllerWithStoryboardName:@"DetailPost" identifier:@"DetailPost"];
            controller.forumtopicId = topicModel.topicId;
            controller.pushFromType = PushFromMyComment;
            [self pushViewController:controller];
        }
            break;
        case 2:
        {
            XPEventDetailViewController *eventVC = (XPEventDetailViewController *)[self instantiateViewControllerWithStoryboardName:@"Event" identifier:@"XPEventDetailViewController"];
            eventVC.forumtopicId = topicModel.topicId;
            [self pushViewController:eventVC];
        }
            break;
            case 3:
        {
            XPVoteDetailViewController *controller = (XPVoteDetailViewController *)[self instantiateViewControllerWithStoryboardName:@"Vote" identifier:@"XPVoteDetailViewController"];
            controller.forumtopicId = topicModel.topicId;
            [self pushViewController:controller];
        }
            break;
            case 4:
        {
            XPMyCommentListModel *model = self.viewModel.myCommentArray[indexPath.row];
            XPSecondHandOfPostDetailViewController *viewController = (XPSecondHandOfPostDetailViewController *)[self instantiateViewControllerWithStoryboardName:@"SecondHand" identifier:@"XPSecondHandOfPostDetailViewController"];
            viewController.secondHandItemId = model.topicId;
            [self pushViewController:viewController];
        }
            break;
            case 5:
        {
            XPMyCommentListModel *model = self.viewModel.myCommentArray[indexPath.row];
            XPHousekeepingDetailViewController *controller = (XPHousekeepingDetailViewController *)[self instantiateViewControllerWithStoryboardName:@"HousekeepingNews" identifier:@"XPHousekeepingDetailViewController"];
            controller.housekeepingItemId = model.topicId;
            [self pushViewController:controller];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XPMyCommentListModel *model = self.viewModel.myCommentArray[indexPath.row];
    return [UIView getTextSizeHeight:model.content font:14.0 withSize:CGSizeMake(self.contentLabel.frame.size.width, MAXFLOAT)]+97;
}

#pragma mark - Event Responds

#pragma mark - Private Methods
- (NSString *)topicType:(NSString *)type
{
    if([type isEqualToString:@"1"]) {
        return @"帖子";
    }
    if([type isEqualToString:@"2"]) {
        return @"活动";
    }
    if([type isEqualToString:@"3"]) {
        return @"投票";
    }
    if([type isEqualToString:@"4"]) {
        return @"二手";
    }
    return @"家政资讯";
}

#pragma mark - Getter & Setter

@end
