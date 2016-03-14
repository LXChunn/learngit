//
//  XPTopicViewController.m
//  XPApp
//
//  Created by iiseeuu on 15/12/29.
//  Copyright © 2015年 ShareMerge. All rights reserved.
//

#import "XPActivityTableViewCell.h"
#import "XPCommonTableViewCell.h"
#import "XPCreatePostViewController.h"
#import "XPDetailPostViewController.h"
#import "XPEventDetailViewController.h"
#import "XPMoreOptionsViewController.h"
#import "XPPostEventViewController.h"
#import "XPReleaseVoteViewController.h"
#import "XPTopicModel.h"
#import "XPTopicViewController.h"
#import "XPTopicViewModel.h"
#import "XPUser.h"
#import "XPVoteDetailViewController.h"
#import "XPVoteTableViewCell.h"
#import <MJRefresh/MJRefresh.h>
#import <UITableView+XPKit.h>
#import "XPCommonRefreshFooter.h"
#import "XPCommonRefreshHeader.h"
#import "XPCommonRefreshHeader.h"
#import "XPCommonRefreshFooter.h"

@interface XPTopicViewController ()<XPOptionsViewControllerDelegate, UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet XPTopicViewModel *topicViewModel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *moreBtn;
@property (nonatomic, strong) XPTopicModel *topicModel;
@property (nonatomic, strong) XPMoreOptionsViewController *optionsViewController;
@property (nonatomic, strong) NSArray *array;

@end

@implementation XPTopicViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _array = [NSArray array];
    @weakify(self);
    [self showFirstHud];
    [self rac_liftSelector:@selector(showToast:) withSignals:[[RACObserve(self.topicViewModel, error) ignore:nil] map:^id (id value) {
        @strongify(self);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self hideFirstHud];
        [self showNonetworkViewWithBlock:^{
            @strongify(self);
            if(self.topicViewModel.list.count < 1) {
                [self.topicViewModel.reloadCommand execute:nil];
            }
        }];
        return [value localizedDescription];
    }], nil];
    [[RACObserve(self.topicViewModel, list) ignore:nil] subscribeNext:^(id x) {
        @strongify(self);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self hideFirstHud];
        if(self.topicViewModel.list.count < 1) {
            [self showNoDataViewWithType:NoDataTypeOfDefault];
            return;
        }
        [self removeNoNetworkView];
        [self.tableView reloadData];
    }];
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"TopicRefreshNotification" object:nil] subscribeNext:^(id x) {
        @strongify(self);
        [self.topicViewModel.reloadCommand execute:nil];
    }];
    [self.topicViewModel.reloadCommand execute:nil];
    [[RACObserve(self.topicViewModel, isNoMoreDate) ignore:@(NO)] subscribeNext:^(id x) {
        @strongify(self);
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }];
    self.tableView.mj_header = [XPCommonRefreshHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self.topicViewModel.reloadCommand execute:nil];
    }];
    self.tableView.mj_footer = [XPCommonRefreshFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self.topicViewModel.moreCommand execute:nil];
    }];
    self.tableView.separatorColor = [UIColor clearColor];
}

#pragma mark - Delegate
- (void)optionsViewController:(XPMoreOptionsViewController *)optionsViewController didSelectRow:(NSInteger)row
{
    switch(row) {
        case 0: {
            [self pushViewController:[self instantiateViewControllerWithStoryboardName:@"Topic" identifier:@"XPCreatePostViewController"]];
            break;
        }
            
        case 1: {
            [self pushViewController:[self instantiateViewControllerWithStoryboardName:@"Event" identifier:@"XPPostEventViewController"]];
            break;
        }
            
        case 2: {
            [self pushViewController:[self instantiateViewControllerWithStoryboardName:@"Vote" identifier:@"XPReleaseVoteViewController"]];
            break;
        }
            
        default: {
        }
            break;
    }
}

#pragma mark - UITableView Deleagate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.topicViewModel.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.topicModel = self.topicViewModel.list[indexPath.row];
    switch([_topicModel.type intValue]) {
        case 1: {
            XPCommonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XPCommonTableViewCell"];
            if(!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"XPCommonTableViewCell" owner:nil options:nil] firstObject];
            }
            
            [cell bindModel:self.topicViewModel.list[indexPath.row]];
            return cell;
        }
            
        case 2: {
            XPActivityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XPActivityTableViewCell"];
            if(!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"XPActivityTableViewCell" owner:nil options:nil] firstObject];
            }
            
            [cell bindModel:self.topicViewModel.list[indexPath.row]];
            return cell;
        }
            
        case 3: {
            XPVoteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XPVoteTableViewCell"];
            if(!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"XPVoteTableViewCell" owner:nil options:nil] firstObject];
            }
            
            [cell bindModel:self.topicViewModel.list[indexPath.row]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.topicModel = self.topicViewModel.list[indexPath.row];
    switch([_topicModel.type intValue]) {
        case 1: {
            return [XPCommonTableViewCell cellHeightWithArray:self.topicModel.extra.picUrls];
        }
            
        case 2: {
            return [XPActivityTableViewCell cellHeightWithArray:self.topicModel.extra.picUrls];
        }
            
        case 3: {
            return 121;
        }
    }
    return 120;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    XPTopicModel *topicModel = [self.topicViewModel.list objectAtIndex:indexPath.row];
    if([topicModel.type isEqualToString:@"1"]) {
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"DetailPost" bundle:nil];
        XPDetailPostViewController *detailViewController = [storyBoard instantiateViewControllerWithIdentifier:@"DetailPost"];
        detailViewController.forumtopicId = topicModel.forumTopicId;
        detailViewController.pushFromType = PushFromNeighborhood;
        [detailViewController setHidesBottomBarWhenPushed:YES];
        [self pushViewController:detailViewController];
    } else if([topicModel.type isEqualToString:@"2"]) {
        UIViewController *viewController = [self instantiateViewControllerWithStoryboardName:@"Event" identifier:@"XPEventDetailViewController"];
        XPEventDetailViewController *eventVC = (XPEventDetailViewController *)viewController;
        eventVC.forumtopicId = topicModel.forumTopicId;
        [eventVC setHidesBottomBarWhenPushed:YES];
        [self pushViewController:eventVC];
    } else if([topicModel.type isEqualToString:@"3"]) {
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Vote" bundle:nil];
        XPVoteDetailViewController *controller = [storyBoard instantiateViewControllerWithIdentifier:@"XPVoteDetailViewController"];
        controller.forumtopicId = topicModel.forumTopicId;
        [controller setHidesBottomBarWhenPushed:YES];
        [self pushViewController:controller];
    }
}

#pragma mark - Event Responds
- (IBAction)addMoreAction:(id)sender
{
    _optionsViewController = [[XPMoreOptionsViewController alloc]initWithMoreOptionsWithIcons:@[@"neighborhood_publish_ico", @"neighborhood_activity_ico", @"neighborhood_vote_ico"] titles:@[@"发布帖子", @"发起活动", @"发起投票"]];
    _optionsViewController.delegate = self;
    [_optionsViewController show];
}

#pragma mark - Private Methods

#pragma mark - Getter & Setter

#pragma mark - Getter & Setter

@end
