//
//  XPHousekeepingNewsViewController.m
//  XPApp
//
//  Created by jy on 16/2/16.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import "XPHousekeepingNewsViewController.h"
#import "XPHousekeepingNewsListCell.h"
#import "XPCommonRefreshHeader.h"
#import "XPCommonRefreshFooter.h"
#import "XPHousekeepingNewsListViewModel.h"
#import "XPHousekeepingListModel.h"
#import "XPAddHousekeepingNewViewController.h"
#import "XPHousekeepingDetailViewController.h"

@interface XPHousekeepingNewsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) IBOutlet XPHousekeepingNewsListViewModel *housekeepingNewsViewModel;

@end

@implementation XPHousekeepingNewsViewController

#pragma mark - Life Circle
- (void)viewDidLoad
{
    [super viewDidLoad];
    @weakify(self);
    [self showFirstHud];
    [self rac_liftSelector:@selector(showToast:) withSignals:[[RACObserve(self.housekeepingNewsViewModel, error) ignore:nil] map:^id (id value) {
        [self.myTableView.mj_header endRefreshing];
        [self.myTableView.mj_footer endRefreshing];
        [self hideFirstHud];
        if(self.housekeepingNewsViewModel.list.count < 1) {
            @strongify(self);
            [self showNonetworkViewWithBlock:^{
                @strongify(self);
                [self.housekeepingNewsViewModel.reloadCommand execute:nil];
            }];
        }
        return [value localizedDescription];
    }], nil];
    [[RACObserve(self.housekeepingNewsViewModel, list) ignore:nil] subscribeNext:^(id x) {
        @strongify(self);
        [self.myTableView.mj_header endRefreshing];
        [self.myTableView.mj_footer endRefreshing];
        [self hideFirstHud];
        if(self.housekeepingNewsViewModel.list.count < 1) {
            [self showNoDataViewWithType:NoDataTypeOfDefault];
            return;
        }
        [self removeNoNetworkView];
        [self.myTableView reloadData];
    }];
    [[RACObserve(self.housekeepingNewsViewModel, isNoMoreDate) ignore:@(NO)]subscribeNext:^(id x) {
        @strongify(self);
        [self.myTableView.mj_footer endRefreshingWithNoMoreData];
    }];
    [self.housekeepingNewsViewModel.reloadCommand execute:nil];
    self.myTableView.mj_header = [XPCommonRefreshHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self.housekeepingNewsViewModel.reloadCommand execute:nil];
    }];
    self.myTableView.mj_footer = [XPCommonRefreshFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self.housekeepingNewsViewModel.moreCommand execute:nil];
    }];
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"RefreshHousekeepingListNotification" object:nil] subscribeNext:^(id x) {
        [self.housekeepingNewsViewModel.reloadCommand execute:nil];
    }];
    self.myTableView.separatorColor = [UIColor clearColor];
}

#pragma mark - Delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XPHousekeepingNewsListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XPHousekeepingNewsListCell" forIndexPath:indexPath];
    [cell bindModel:self.housekeepingNewsViewModel.list[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XPHousekeepingListModel * model = self.housekeepingNewsViewModel.list[indexPath.row];
    return [XPHousekeepingNewsListCell cellHeight:model];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.housekeepingNewsViewModel.list.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    XPHousekeepingDetailViewController * controller = (XPHousekeepingDetailViewController *)[self instantiateViewControllerWithStoryboardName:@"HousekeepingNews" identifier:@"XPHousekeepingDetailViewController"];
    XPHousekeepingListModel * model = self.housekeepingNewsViewModel.list[indexPath.row];
    controller.housekeepingItemId = model.housekeepingItemId;
    @weakify(self);
    [[RACObserve(controller, isChange) ignore:@(NO)] subscribeNext:^(id x) {
        @strongify(self);
        [self.housekeepingNewsViewModel.reloadCommand execute:nil];
    }];
    [self pushViewController:controller];
}
#pragma mark - Event Responds
- (IBAction)addAction:(id)sender {
    XPAddHousekeepingNewViewController * controller = (XPAddHousekeepingNewViewController *)[self instantiateViewControllerWithStoryboardName:@"HousekeepingNews" identifier:@"XPAddHousekeepingNewViewController"];
    @weakify(self);
    [[RACObserve(controller, isChange) ignore:@(NO)] subscribeNext:^(id x) {
        @strongify(self);
        [self.housekeepingNewsViewModel.reloadCommand execute:nil];
    }];
    [self pushViewController:controller];
}

#pragma mark - Private Methods

#pragma mark - Getter & Setter

@end 
