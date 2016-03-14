//
//  XPSecondHandContentViewController.m
//  XPApp
//
//  Created by jy on 15/12/29.
//  Copyright 2015年 ShareMerge. All rights reserved.
//

#import "XPSecondHandCell.h"
#import "XPSecondHandContentViewController.h"
#import "XPSecondHandItemsListModel.h"
#import "XPSecondHandOfPostDetailViewController.h"
#import "XPSecondHandViewModel.h"
#import <MJRefresh.h>
#import "XPCommonRefreshHeader.h"
#import "XPCommonRefreshFooter.h"

@interface XPSecondHandContentViewController ()
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-property-synthesis"
@property (strong, nonatomic) IBOutlet XPSecondHandViewModel *viewModel;
#pragma clang diagnostic pop

@end

@implementation XPSecondHandContentViewController

#pragma mark - Life Circle
- (void)viewDidLoad
{
    [super viewDidLoad];
    @weakify(self);
    [self showFirstHud];
    [self rac_liftSelector:@selector(showToast:) withSignals:[[RACObserve(self.viewModel, error) ignore:nil] map:^id (id value) {
        [self.myTableView.mj_header endRefreshing];
        [self.myTableView.mj_footer endRefreshing];
        [self hideFirstHud];
        if(self.viewModel.list.count < 1) {
            @strongify(self);
            [self showNonetworkViewWithBlock:^{
                @strongify(self);
                [self.viewModel.secondHandReloadCommand execute:nil];
            }];
        }
        return [value localizedDescription];
    }], nil];
    [[RACObserve(self.viewModel, list) ignore:nil] subscribeNext:^(id x) {
        @strongify(self);
        [self.myTableView.mj_header endRefreshing];
        [self.myTableView.mj_footer endRefreshing];
        [self hideFirstHud];
        if(self.viewModel.list.count < 1) {
            [self showNoDataViewWithType:NoDataTypeOfDefault];
            return;
        }
        [self removeNoNetworkView];
        [self.myTableView reloadData];
    }];
    [[RACObserve(self.viewModel, isNoMoreDate) ignore:@(NO)]subscribeNext:^(id x) {
        @strongify(self);
        [self.myTableView.mj_footer endRefreshingWithNoMoreData];
    }];
    self.viewModel.type = [NSString stringWithFormat:@"%ld", (_pageIndex + 1)];
    [self.viewModel.secondHandReloadCommand execute:nil];
    self.myTableView.mj_header = [XPCommonRefreshHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self.viewModel.secondHandReloadCommand execute:nil];
    }];
    self.myTableView.mj_footer = [XPCommonRefreshFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self.viewModel.secondHandMoreCommand execute:nil];
    }];
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"RefreshSecondHandListNotification" object:nil] subscribeNext:^(id x) {
        [self.viewModel.secondHandReloadCommand execute:nil];
    }];
    self.myTableView.separatorColor = [UIColor clearColor];
}

#pragma mark - UItableViewDelegateAndDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XPSecondHandCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XPSecondHandCell" forIndexPath:indexPath];
    if(indexPath.row >= self.viewModel.list.count - 1) {
        cell.lineLabel.hidden = YES;
    } else {
        cell.lineLabel.hidden = NO;
    }
    
    [cell bindModel:self.viewModel.list[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XPSecondHandItemsListModel *model = self.viewModel.list[indexPath.row];
    return [XPSecondHandCell cellHeightWithArray:model.picUrls];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewModel.list.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    XPSecondHandItemsListModel *model = self.viewModel.list[indexPath.row];
    XPSecondHandOfPostDetailViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"XPSecondHandOfPostDetailViewController"];
    viewController.secondHandItemId = model.secondhandItemId;
    [self pushViewController:viewController];
}

#pragma mark - Event Responds

#pragma mark - Private Methods

#pragma mark - Getter & Setter

@end
