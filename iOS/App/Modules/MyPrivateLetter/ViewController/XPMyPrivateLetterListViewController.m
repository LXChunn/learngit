//
//  XPMyPrivateLetterListViewController.m
//  XPApp
//
//  Created by jy on 16/1/9.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import "XPMessageListModel.h"
#import "XPMyPrivateLetterListCell.h"
#import "XPMyPrivateLetterListViewController.h"
#import "XPMyPrivateMessageDetailViewController.h"
#import "XPPrivateMessageListViewModel.h"
#import <MJRefresh.h>
#import "XPCommonRefreshHeader.h"
#import "XPCommonRefreshFooter.h"
#import "UIViewController+BackButtonHandler.h"

@interface XPMyPrivateLetterListViewController ()<UITableViewDelegate, UITableViewDataSource,BackButtonHandlerProtocol>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
#pragma clang diagnostic ignored "-Wobjc-property-synthesis"
#pragma clang diagnostic push
@property (strong, nonatomic) IBOutlet XPPrivateMessageListViewModel *viewModel;
#pragma clang diagnostic pop
@end

@implementation XPMyPrivateLetterListViewController

#pragma mark - Life Circle
- (void)viewDidLoad
{
    [super viewDidLoad];
    @weakify(self);
    [self showFirstHud];
    [self rac_liftSelector:@selector(showToast:) withSignals:[[RACObserve(self.viewModel, error) ignore:nil] map:^id (id value) {
        @strongify(self);
        [self.myTableView.mj_header endRefreshing];
        [self.myTableView.mj_footer endRefreshing];
        [self hideFirstHud];
        if (self.viewModel.list.count < 1)
        {
            [self showNonetworkViewWithBlock:^{
                [self.viewModel.reloadCommand execute:nil];
            }];
        }
        return [value localizedDescription];
    }], nil];
    [[RACObserve(self.viewModel, list) ignore:nil] subscribeNext:^(id x) {
        @strongify(self);
        [self.myTableView.mj_header endRefreshing];
        [self.myTableView.mj_footer endRefreshing];
        [self hideFirstHud];
        if (self.viewModel.list.count < 1)
        {
            [self showNoDataViewWithType:NoDataTypeOfPrivateMessage];
            return;
        }
        [self removeNoNetworkView];
        [self.myTableView reloadData];
    }];
    [[RACObserve(self.viewModel, isNoMoreDate) ignore:@(NO)] subscribeNext:^(id x) {
        @strongify(self);
        [self.myTableView.mj_footer endRefreshingWithNoMoreData];
    }];
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"RefreshPrivateListNotification" object:nil] subscribeNext:^(id x) {
        //收到推送时的通知
        [self.viewModel.reloadCommand execute:nil];
    }];
    self.myTableView.mj_header = [XPCommonRefreshHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self.viewModel.reloadCommand execute:nil];
    }];
    self.myTableView.mj_footer = [XPCommonRefreshFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self.viewModel.moreCommand execute:nil];
    }];
    self.myTableView.separatorColor = [UIColor clearColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self.viewModel.reloadCommand execute:nil];
}

#pragma mark - Delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XPMyPrivateLetterListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XPMyPrivateLetterListCell"];
    XPMessageListModel *model = [self.viewModel.list objectAtIndex:indexPath.row];
    [cell bindModel:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 68;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewModel.list.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    XPMessageListModel *model = [self.viewModel.list objectAtIndex:indexPath.row];
    XPMyPrivateMessageDetailViewController *detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"XPMyPrivateMessageDetailViewController"];
    detailViewController.userModel = model.contact;
    [self pushViewController:detailViewController];
}

#pragma mark - BackButtonHandlerProtocol
- (BOOL)navigationShouldPopOnBackButton
{
    [self pop];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadPrivateMessageNotification" object:nil];
    return NO;
}

#pragma mark - Event Responds

#pragma mark - Private Methods

#pragma mark - Getter & Setter

@end
