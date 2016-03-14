//
//  XPMyMaintenanceViewController.m
//  XPApp
//

//  Created by xinpinghuang on 12/25/15.
//  Copyright 2015 ShareMerge. All rights reserved.

//

#import "XPDetailMyMaintenanceViewController.h"
#import "XPMaintenanceViewModel.h"
#import "XPMyMaintenanceModel.h"
#import "XPMyMaintenanceTableViewCell.h"
#import "XPMyMaintenanceViewController.h"
#import <MJRefresh/MJRefresh.h>
#import <UITableView+XPKit.h>
#import "XPCommonRefreshHeader.h"
#import "XPCommonRefreshFooter.h"
#import "XPMaintenanceViewController.h"

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
    @weakify(self);
    [self showFirstHud];
//    [self rac_liftSelector:@selector(cleverLoader:) withSignals:RACObserve(self.viewModel, executing), nil];
    [self rac_liftSelector:@selector(showToast:) withSignals:[[RACObserve(self.viewModel, error) ignore:nil] map:^id (id value) {
        [self hideLoader];
        @strongify(self);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self hideFirstHud];
        if(self.viewModel.orders.count < 1) {
            [self showNonetworkViewWithBlock:^{
                @strongify(self);
                [self.viewModel.orderCommand execute:nil];
            }];
        }
        
        return [value localizedDescription];
    }], nil];
    [[RACObserve(self.viewModel, orders) ignore:nil] subscribeNext:^(id x) {
        @strongify(self);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self hideFirstHud];
        if(self.viewModel.orders.count < 1) {
            [self showNoDataViewWithType:NoDataTypeOfDefault];
            return;
        }
        [self removeNoNetworkView];
        [self.tableView reloadData];
    }];
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"MyMaintenanceRefreshNotification" object:nil] subscribeNext:^(id x) {
        @strongify(self);
        [self.viewModel.orderCommand execute:nil];
    }];
    [self.viewModel.orderCommand execute:nil];
    [[RACObserve(self.viewModel, isNoMoreDate) ignore:@(NO)] subscribeNext:^(id x) {
        @strongify(self);
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }];
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.mj_header = [XPCommonRefreshHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self.viewModel.orderCommand execute:nil];
    }];
    self.tableView.mj_footer = [XPCommonRefreshFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self.viewModel.moreOrderCommand execute:nil];
    }];
}

#pragma mark - Delegate
#pragma mark - UITableView Deleagate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewModel.orders.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XPMyMaintenanceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell bindModel:self.viewModel.orders[indexPath.row]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    XPDetailMyMaintenanceViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"XPDetailMyMaintenanceViewController"];
    viewController.detailModel = self.viewModel.orders[indexPath.row];;
    [self pushViewController:viewController];
}

#pragma mark - Event Responds
- (IBAction)addButtonAction:(id)sender
{
    XPMaintenanceViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"XPMaintenanceViewController"];
    [self pushViewController:viewController];
    
    
}

#pragma mark - Private Methods

#pragma mark - Getter & Setter

#pragma mark - Getter & Setter

@end
