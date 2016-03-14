//
//  XPMyCarpoolViewController.m
//  XPApp
//
//  Created by CaoShunQing on 16/2/23.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import "XPMyCarpoolViewController.h"
#import "XPCarpoolViewModel.h"
#import <MJRefresh/MJRefresh.h>
#import "XPCommonRefreshHeader.h"
#import "XPCommonRefreshFooter.h"
#import "XPMyCarpoolModel.h"
#import "NSDate+DateTools.h"
#import "XPHousekeepingDetailViewController.h"
#import "XPMyCarpoolDetailViewController.h"
#import "XPDetailCarpoolViewController.h"

@interface XPMyCarpoolViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
#pragma clang diagnostic ignored "-Wobjc-property-synthesis"
#pragma clang diagnostic push
@property (strong, nonatomic) IBOutlet XPCarpoolViewModel *viewModel;
#pragma clang diagnostic pop

@end

@implementation XPMyCarpoolViewController

#pragma mark - Life Circle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"我的拼车";
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.separatorColor = [UIColor clearColor];
    @weakify(self);
    [self showFirstHud];
    [self rac_liftSelector:@selector(showToast:) withSignals:[[RACObserve(self.viewModel, error) ignore:nil] map:^id (id value) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self hideFirstHud];
        if(self.viewModel.myCarpoolArray.count < 1) {
            @strongify(self);
            [self showNonetworkViewWithBlock:^{
                @strongify(self);
                [self.viewModel.myCarpoolCommand execute:nil];
            }];
        }
        return [value localizedDescription];
    }], nil];
    [[RACObserve(self.viewModel, myCarpoolArray) ignore:nil] subscribeNext:^(id x) {
        @strongify(self);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self hideFirstHud];
        if (self.viewModel.myCarpoolArray.count<1) {
            [self showNoDataViewWithType:NoDataTypeOfPost];
            return ;
        }
        [self.tableView reloadData];
        [self removeNoNetworkView];
    }];
    [[RACObserve(self.viewModel, isNoMoreData) ignore:@(NO)] subscribeNext:^(id x) {
        @strongify(self);
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }];
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"MyCarpoolRefreshNotification" object:nil] subscribeNext:^(id x) {
        @strongify(self);
        [self.viewModel.myCarpoolCommand execute:nil];
    }];
    [self.viewModel.myCarpoolCommand execute:nil];
    self.tableView.mj_header = [XPCommonRefreshHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self.viewModel.myCarpoolCommand execute:nil];
    }];
    self.tableView.mj_footer = [XPCommonRefreshFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self.viewModel.moreCarpoolCommand execute:nil];
    }];
}

#pragma mark - Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewModel.myCarpoolArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCarpoolCell" forIndexPath:indexPath];
    XPMyCarpoolModel *model = self.viewModel.myCarpoolArray[indexPath.row];
    UILabel *startLabel = [cell viewWithTag:11];
    UILabel *endLabel = [cell viewWithTag:12];
    UILabel *begainTimeLabel = [cell viewWithTag:13];
    
    startLabel.text = model.startPoint;
    endLabel.text = model.endPoint;
    begainTimeLabel.text = [[NSDate dateWithTimeIntervalSince1970:model.time.doubleValue] formattedDateWithFormat:@"YYYY-MM-dd hh:mm"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    XPDetailCarpoolViewController *controller =(XPDetailCarpoolViewController *)[self instantiateViewControllerWithStoryboardName:@"Carpoolings" identifier:@"XPDetailCarpoolViewController"];
    @weakify(self);
    [[RACObserve(controller, isDelete) ignore:@(NO)] subscribeNext:^(id x) {
        @strongify(self);
        [self.viewModel.myCarpoolCommand execute:nil];
    }];
    controller.detailModel = self.viewModel.myCarpoolArray[indexPath.row];
    [self pushViewController:controller];
}
#pragma mark - Event Responds

#pragma mark - Private Methods

#pragma mark - Getter & Setter

@end 
