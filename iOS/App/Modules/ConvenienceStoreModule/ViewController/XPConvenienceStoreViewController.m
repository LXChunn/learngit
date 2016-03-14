//
//  XPConvenienceStoreViewController.m
//  XPApp
//
//  Created by iiseeuu on 16/1/15.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import "XPConvenienceStoreViewController.h"
#import "XPConvenienceStoreViewModel.h"
#import <MJRefresh/MJRefresh.h>
#import "XPCommonRefreshHeader.h"
#import "XPCommonRefreshFooter.h"
#import "XPConvenienceStoreTableViewCell.h"
#import "XPDetailConvenienceStoreViewController.h"

@interface XPConvenienceStoreViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) IBOutlet XPConvenienceStoreViewModel *storeViewModel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation XPConvenienceStoreViewController

#pragma mark - Life Circle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self showFirstHud];
    self.navigationItem.title = @"便利店";
    @weakify(self);
    [self rac_liftSelector:@selector(showToast:) withSignals:[[RACObserve(self.storeViewModel, error) ignore:nil] map:^id (id value) {
        @strongify(self);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self hideFirstHud];
        if(self.storeViewModel.list.count < 1) {
            [self showNonetworkViewWithBlock:^{
                @strongify(self);
                [self.storeViewModel.reloadCommand execute:nil];
            }];
        }
        return [value localizedDescription];
    }], nil];
    
    [[RACObserve(self.storeViewModel, list) ignore:nil] subscribeNext:^(id x) {
        @strongify(self);
//       [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self hideFirstHud];
        if(self.storeViewModel.list.count < 1) {
            [self showNoDataViewWithType:NoDataTypeOfDefault];
            return;
        }
        [self removeNoNetworkView];
        [self.tableView reloadData];
    }];
    [self.storeViewModel.reloadCommand execute:nil];
    self.tableView.separatorColor = [UIColor clearColor];
    [[RACObserve(self.storeViewModel, isNoMoreDate) ignore:@(NO)] subscribeNext:^(id x) {
        @strongify(self);
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }];
    self.tableView.mj_header = [XPCommonRefreshHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self.storeViewModel.reloadCommand execute:nil];
    }];
    self.tableView.mj_footer = [XPCommonRefreshFooter footerWithRefreshingBlock:^{
        [self.storeViewModel.moreCommand execute:nil];
    }];
}

#pragma mark - Delegate
#pragma mark - UITableView Deleagate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.storeViewModel.list.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XPConvenienceStoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    XPLog(@"-------------%ld",(long)indexPath.row);
    [cell bindModel:self.storeViewModel.list[indexPath.row]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    XPDetailConvenienceStoreViewController *detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"XPDetailConvenienceStoreViewController"];
    detailViewController.detaiModel = self.storeViewModel.list[indexPath.row];
    [self pushViewController:detailViewController];
}

#pragma mark - Event Responds

#pragma mark - Private Methods

#pragma mark - Getter & Setter

@end 
