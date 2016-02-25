//
//  XPMyMaintenanceViewController.m
//  XPApp
//

//  Created by xinpinghuang on 12/25/15.
//  Copyright 2015 ShareMerge. All rights reserved.

//

#import "XPMyMaintenanceViewController.h"
#import "XPMyMaintenanceModel.h"
#import "XPMaintenanceViewModel.h"
#import "XPMyMaintenanceTableViewCell.h"
#import "XPDetailMyMaintenanceViewController.h"
#import <UITableView+XPKit.h>
#import <MJRefresh/MJRefresh.h>

@interface XPMyMaintenanceViewController ()

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-property-synthesis"
@property (strong, nonatomic) IBOutlet XPMaintenanceViewModel *viewModel;
#pragma clang diagnostic pop
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation XPMyMaintenanceViewController

#pragma mark - Life Circle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self rac_liftSelector:@selector(cleverLoader:) withSignals:RACObserve(self.viewModel, executing), nil];
    [self rac_liftSelector:@selector(showToast:) withSignals:[[RACObserve(self.viewModel, error) ignore:nil] map:^id (id value) {
        [self hideLoader];
        [self.tableView.mj_footer endRefreshing];
        return [value localizedDescription];
    }], nil];
    @weakify(self);
    [[RACObserve(self.viewModel, orders) ignore:nil] subscribeNext:^(id x) {
        @strongify(self);
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
    [self.viewModel.orderCommand execute:nil];
    [self.tableView hideEmptySeparators];
#warning 测试数据
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self.tableView reloadData];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self.tableView reloadData];
    }];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"my_detail"]) {
        XPDetailMyMaintenanceViewController *detailViewController = segue.destinationViewController;
        UITableViewCell *cell = [self.tableView selectedCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
         NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        detailViewController.detailModel = self.viewModel.orders[indexPath.row];
    }
}

#pragma mark - Delegate
#pragma mark - UITableView Deleagate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewModel.orders.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XPMyMaintenanceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell bindModel:self.viewModel.orders[indexPath.row]];
    return cell;
}


#pragma mark - Event Responds

#pragma mark - Private Methods

#pragma mark - Getter & Setter

#pragma mark - Getter & Setter

@end
