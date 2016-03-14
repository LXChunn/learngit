 //
//  XPMyPostViewController.m
//  XPApp
//
//  Created by jy on 16/1/8.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import "XPActivityTableViewCell.h"
#import "XPCommonTableViewCell.h"
#import "XPDetailPostViewController.h"
#import "XPEventDetailViewController.h"
#import "XPMyPostViewController.h"
#import "XPMyPostViewModel.h"
#import "XPMySecondHandCell.h"
#import "XPSecondHandItemsListModel.h"
#import "XPSecondHandOfPostDetailViewController.h"
#import "XPTopicModel.h"
#import "XPVoteDetailViewController.h"
#import <MJRefresh/MJRefresh.h>
#import <UITableView+XPKit.h>
#import "XPVoteTableViewCell.h"
#import "XPCommonRefreshHeader.h"
#import "XPCommonRefreshFooter.h"
#import "XPOtherPostCell.h"
#import "XPOtherForumModel.h"
#import "XPHousekeepingDetailViewController.h"

@interface XPMyPostViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;

#pragma clang diagnostic ignored "-Wobjc-property-synthesis"
#pragma clang diagnostic push
@property (strong, nonatomic) IBOutlet XPMyPostViewModel *viewModel;
#pragma clang diagnostic pop
@property (nonatomic, strong) RACCommand *command;
@property (nonatomic, strong) RACCommand *moreCommand;
@property (nonatomic, strong) XPTopicModel *topicModel;

@end

@implementation XPMyPostViewController

#pragma mark - Life Circle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"我的发布";
    if(self.pageIndex == 0) {
        self.command = self.viewModel.myforumtopicsCommand;
        self.moreCommand = self.viewModel.moreForumtopicsCommand;
    } else if(self.pageIndex == 1) {
        self.command = self.viewModel.mysecondhandCommand;
        self.moreCommand = self.viewModel.moreSecondHandCommand;
    }else{
        self.command = self.viewModel.otherForumCommand;
        self.moreCommand = self.viewModel.moreOtherForumCommand;
    }
    @weakify(self);
    self.tableview.tableFooterView = [[UIView alloc]init];
    [self showFirstHud];
    [self rac_liftSelector:@selector(showToast:) withSignals:[[RACObserve(self.viewModel, error) ignore:nil] map:^id (id value) {
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
        [self hideFirstHud];
        if(self.viewModel.postArray.count < 1) {
            @strongify(self);
            [self showNonetworkViewWithBlock:^{
                @strongify(self);
                [self.command execute:nil];
            }];
        }
        return [value localizedDescription];
    }], nil];
    [[RACObserve(self.viewModel, postArray) ignore:nil] subscribeNext:^(id x) {
        @strongify(self);
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
        [self hideFirstHud];
        if (self.viewModel.postArray.count<1) {
            [self showNoDataViewWithType:NoDataTypeOfPost];
            return ;
        }
        [self.tableview reloadData];
        [self removeNoNetworkView];
    }];
    [[RACObserve(self.viewModel, isNoMoreDate) ignore:@(NO)] subscribeNext:^(id x) {
        @strongify(self);
        [self.tableview.mj_footer endRefreshingWithNoMoreData];
    }];
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"MyPostRefreshNotification" object:nil] subscribeNext:^(id x) {
        @strongify(self);
        [self.command execute:nil];
    }];
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"RefreshHousekeepingListNotification" object:nil] subscribeNext:^(id x) {
        @strongify(self);
        [self.command execute:nil];
    }];
    [self.command execute:nil];
    self.tableview.mj_header = [XPCommonRefreshHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self.command execute:nil];
    }];
    self.tableview.mj_footer = [XPCommonRefreshFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self.moreCommand execute:nil];
    }];
}

#pragma mark - Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewModel.postArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableView.separatorColor = [UIColor clearColor];
    UITableViewCell *cell = nil;
    if(self.pageIndex == 0) {
        self.topicModel = self.viewModel.postArray[indexPath.row];
        switch([_topicModel.type intValue]) {
            case 1: {
                XPCommonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XPCommonTableViewCell"];
                if(!cell) {
                    cell = [[[NSBundle mainBundle] loadNibNamed:@"XPCommonTableViewCell" owner:nil options:nil] firstObject];
                }
                [cell bindModel:self.viewModel.postArray[indexPath.row]];
                [cell hidden];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
                
            case 2: {
                XPActivityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XPActivityTableViewCell"];
                if(!cell) {
                    cell = [[[NSBundle mainBundle] loadNibNamed:@"XPActivityTableViewCell" owner:nil options:nil] firstObject];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell hideen];
                [cell ForMyPostBindModel:self.viewModel.postArray[indexPath.row]];
                [cell ForMyPostconfigureStatus];
                return cell;
            }
                
            case 3: {
                XPVoteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XPVoteTableViewCell"];
                if(!cell) {
                    cell = [[[NSBundle mainBundle] loadNibNamed:@"XPVoteTableViewCell" owner:nil options:nil] firstObject];
                }
                [cell bindModel:self.viewModel.postArray[indexPath.row]];
                [cell hiddenForMyPost];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
        }

    } else if(self.pageIndex == 1) {
        
        XPMySecondHandCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XPMySecondHandCell"];
        if(!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"XPMySecondHandCell" owner:nil options:nil]firstObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell bindModel:self.viewModel.postArray[indexPath.row]];
        return cell;
    }else{
        XPOtherPostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XPOtherPostCell"];
        if(!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"XPOtherPostCell" owner:nil options:nil]firstObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell bindModel:self.viewModel.postArray[indexPath.row]];
        return cell;
    }
    tableView.separatorColor = [UIColor clearColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.pageIndex == 0) {
        XPTopicModel *topicModel = [self.viewModel.postArray objectAtIndex:indexPath.row];
        switch ([topicModel.type integerValue]) {
            case 1:
            {
                XPDetailPostViewController *controller = (XPDetailPostViewController *)[self instantiateViewControllerWithStoryboardName:@"DetailPost" identifier:@"DetailPost"];
                controller.forumtopicId = topicModel.forumTopicId;
                controller.pushFromType = PushFromMyPost;
                [self pushViewController:controller];
            }
                break;
            case 2:
            {
                XPEventDetailViewController *controller = (XPEventDetailViewController *)[self instantiateViewControllerWithStoryboardName:@"Event" identifier:@"XPEventDetailViewController"];
                controller.forumtopicId = topicModel.forumTopicId;
                [self pushViewController:controller];
            }
                break;
            case 3:
            {
                XPVoteDetailViewController *controller = (XPVoteDetailViewController *)[self instantiateViewControllerWithStoryboardName:@"Vote" identifier:@"XPVoteDetailViewController"];
                controller.forumtopicId = topicModel.forumTopicId;
                [self pushViewController:controller];
            }
                break;
        }
    } else if(self.pageIndex == 1){
        XPSecondHandItemsListModel *model = self.viewModel.postArray[indexPath.row];
        XPSecondHandOfPostDetailViewController *viewController = (XPSecondHandOfPostDetailViewController *)[self instantiateViewControllerWithStoryboardName:@"SecondHand" identifier:@"XPSecondHandOfPostDetailViewController"];
        viewController.secondHandItemId = model.secondhandItemId;
        [self pushViewController:viewController];
    }else{
        XPHousekeepingDetailViewController *controller = (XPHousekeepingDetailViewController *)[self instantiateViewControllerWithStoryboardName:@"HousekeepingNews" identifier:@"XPHousekeepingDetailViewController"];
        XPOtherForumModel *model = self.viewModel.postArray[indexPath.row];
        controller.housekeepingItemId = model.otherItemId;
        [[RACObserve(controller, isChange) ignore:@(NO)] subscribeNext:^(id x) {
            [self.command execute:nil];
        }];
        [self pushViewController:controller];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.pageIndex == 1) {
        XPSecondHandItemsListModel *model = self.viewModel.postArray[indexPath.row];
        return [XPMySecondHandCell cellHeight:model.picUrls];
    } else if(self.pageIndex==0){
        XPTopicModel *model = self.viewModel.postArray[indexPath.row];
        switch([model.type intValue]) {
            case 1: {
                return [XPCommonTableViewCell cellHeightWithArray:model.extra.picUrls];
            }
                
            case 2: {
                return [XPActivityTableViewCell cellHeightWithArray:model.extra.picUrls];
            }
                
            case 3: {
                return 121;
            }
        }
    }else{
        XPOtherForumModel *model = self.viewModel.postArray[indexPath.row];
        return [XPOtherPostCell cellHeight:model.picUrls];
    }
    
    return 180;
}

#pragma mark - Event Responds

#pragma mark - Private Methods

#pragma mark - Getter & Setter

@end
