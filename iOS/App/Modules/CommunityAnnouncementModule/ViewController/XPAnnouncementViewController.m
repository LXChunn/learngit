//
//  XPAnnouncementViewController.m
//  XPApp
//
//  Created by iiseeuu on 15/12/19.
//  Copyright © 2015年 ShareMerge. All rights reserved.
//

#import "XPAnnouncementModel.h"
#import "XPAnnouncementViewController.h"
#import "XPAnnouncementViewModel.h"
#import "XPCommnityTableViewCell.h"
#import "XPDetailAnnounceViewController.h"
#import <MJRefresh/MJRefresh.h>
#import "XPCommonRefreshHeader.h"
#import "XPCommonRefreshFooter.h"

@interface XPAnnouncementViewController () <UITableViewDelegate, UITableViewDataSource>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-property-synthesis"
@property (strong, nonatomic) IBOutlet XPAnnouncementViewModel *viewModel;
#pragma clang diagnostic pop
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation XPAnnouncementViewController

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Delegate
#pragma mark - UITableView Deleagate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewModel.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XPCommnityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    [cell bindModel:self.viewModel.list[indexPath.row]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    XPDetailAnnounceViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"XPDetailAnnounceViewController"];
    viewController.detailModel = self.viewModel.list[indexPath.row];;
    viewController.isHidden = NO;
    [self pushViewController:viewController];
}

#pragma mark - Event Responds

#pragma mark - Private Methods

#pragma mark - Getter & Setter

@end
