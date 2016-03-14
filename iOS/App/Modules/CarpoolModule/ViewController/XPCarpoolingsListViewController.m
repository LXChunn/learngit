//
//  XPCarpoolingsListViewController.m
//  XPApp
//
//  Created by iiseeuu on 16/2/22.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import "XPCarpoolingsListViewController.h"
#import "XPCarpoolModel.h"
#import "XPCarpoolingsViewModel.h"
#import <MJRefresh/MJRefresh.h>
#import "XPCommonRefreshHeader.h"
#import "XPCommonRefreshFooter.h"
#import "XPCarpoolingsTableViewCell.h"
#import "XPDetailCarpoolViewController.h"
#import "XPCreateCarpoolViewController.h"

@interface XPCarpoolingsListViewController ()<UITableViewDataSource,UITableViewDelegate>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-property-synthesis"
@property (strong, nonatomic) IBOutlet XPCarpoolingsViewModel *viewModel;
#pragma clang diagnostic pop
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation XPCarpoolingsListViewController

#pragma mark - Life Circle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self showFirstHud];
    @weakify(self);
    [self rac_liftSelector:@selector(showToast:) withSignals:[[RACObserve(self.viewModel, error) ignore:nil] map:^id (id value) {
        @strongify(self);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self hideFirstHud];
        if(self.viewModel.list.count < 1) {
            [self showNonetworkViewWithBlock:^{
                @strongify(self);
                [self.viewModel.listCommand execute:nil];
            }];
        }
        return [value localizedDescription];
    }], nil];
    [[RACObserve(self.viewModel, list) ignore:nil] subscribeNext:^(id x) {
        @strongify(self);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self hideFirstHud];
        if(self.viewModel.list.count < 1) {
            [self showNoDataViewWithType:NoDataTypeOfDefault];
            return;
        }
        [self removeNoNetworkView];
        [self.tableView reloadData];
    }];
    [self.viewModel.listCommand execute:nil];
    [[RACObserve(self.viewModel, isNoMoreDate) ignore:@(NO)] subscribeNext:^(id x) {
        @strongify(self);
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }];
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.mj_header = [XPCommonRefreshHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self.viewModel.listCommand execute:nil];
    }];
    self.tableView.mj_footer = [XPCommonRefreshFooter footerWithRefreshingBlock:^{
        [self.viewModel.listMoreCommand execute:nil];
    }];
}

#pragma mark - Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewModel.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XPCarpoolingsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    [cell bindModel:self.viewModel.list[indexPath.row]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    XPDetailCarpoolViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"XPDetailCarpoolViewController"];
    viewController.detailModel = self.viewModel.list[indexPath.row];
    @weakify(self);
    [[RACObserve(viewController, isDelete) ignore:@(NO)] subscribeNext:^(id x) {
        @strongify(self);
        [self.viewModel.listCommand execute:nil];
    }];
    [self pushViewController:viewController];
}

#pragma mark - Event Responds
//发布业主拼车
- (IBAction)createCarpoolItemAction:(id)sender
{
    XPCreateCarpoolViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"XPCreateCarpoolViewController"];
    @weakify(self);
    [[RACObserve(viewController, isAdd) ignore:@(NO)] subscribeNext:^(id x) {
       @strongify(self);
        [self.viewModel.listCommand execute:nil];
    }];
    [self pushViewController:viewController];
}

#pragma mark - Private Methods

#pragma mark - Getter & Setter

@end 
