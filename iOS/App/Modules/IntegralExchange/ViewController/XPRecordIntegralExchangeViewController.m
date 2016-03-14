//
//  XPRecordIntegralExchangeViewController.m
//  XPApp
//
//  Created by CaoShunQing on 16/2/25.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import "XPRecordIntegralExchangeViewController.h"
#import "XPIntegralExchangeViewModel.h"
#import "XPExchangeRecordModel.h"
#import "NSDate+DateTools.h"
#import <MJRefresh/MJRefresh.h>
#import "XPCommonRefreshFooter.h"
#import "XPCommonRefreshHeader.h"

@interface XPRecordIntegralExchangeViewController ()<UITableViewDataSource,UITableViewDelegate>
#pragma clang diagnostic ignored "-Wobjc-property-synthesis"
#pragma clang diagnostic push
@property (strong, nonatomic) IBOutlet XPIntegralExchangeViewModel *viewModel;
#pragma clang diagnostic pop
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation XPRecordIntegralExchangeViewController

#pragma mark - Life Circle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"积分兑换记录";
    @weakify(self);
    [self rac_liftSelector:@selector(showToast:) withSignals:[[RACObserve(self.viewModel, error) ignore:nil] map:^id (id value) {
        [self.tableView.mj_header endRefreshing];
        if(self.viewModel.listArray.count < 1) {
            @strongify(self);
            [self showNonetworkViewWithBlock:^{
                @strongify(self);
                [self.viewModel.RecordExchangeCommand execute:nil];
            }];
        }
        return [value localizedDescription];
    }], nil];
    [[RACObserve(self.viewModel, listArray) ignore:nil] subscribeNext:^(id x) {
        @strongify(self);
        [self.tableView.mj_header endRefreshing];
        if(self.viewModel.listArray.count < 1) {
            [self showNoDataViewWithType:NoDataTypeOfDefault];
            return;
        }
        [self removeNoNetworkView];
        [self.tableView reloadData];
    }];
    [self.viewModel.RecordExchangeCommand execute:nil];
    self.tableView.mj_header = [XPCommonRefreshHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self.viewModel.RecordExchangeCommand execute:nil];
    }];
    self.tableView.separatorColor = [UIColor clearColor];
}

#pragma mark - Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewModel.listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecordExchangeCell" forIndexPath:indexPath];
    XPExchangeRecordModel *model = self.viewModel.listArray[indexPath.row];
    UILabel *timeLabel = [cell viewWithTag:11];
    UILabel *pointLabel = [cell viewWithTag:12];
    timeLabel.text = [NSString stringWithFormat:@"%@",[[NSDate dateWithTimeIntervalSince1970:model.time] formattedDateWithFormat:@"YYYY-MM-dd   hh:mm"]];
    pointLabel.text =[NSString stringWithFormat:@"-%ld",(long)model.point];
    return cell;
}
#pragma mark - Event Responds

#pragma mark - Private Methods

#pragma mark - Getter & Setter

@end 
