//
//  XPMyMaintenanceViewController.m
//  XPApp
//

//  Created by xinpinghuang on 12/25/15.
//  Copyright 2015 ShareMerge. All rights reserved.

//

#import "XPComplaintModel.h"
#import "XPComplaintTableViewCell.h"
#import "XPComplaintViewModel.h"
#import "XPDetailViewController.h"
#import "XPListComplaintViewController.h"
#import <MJRefresh/MJRefresh.h>
#import <UITableView+XPKit.h>
#import "XPCommonRefreshHeader.h"
#import "XPCommonRefreshFooter.h"
#import "XPComplaintViewController.h"

@interface XPListComplaintViewController ()

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-property-synthesis"
@property (strong, nonatomic) IBOutlet XPComplaintViewModel *viewModel;
#pragma clang diagnostic pop
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation XPListComplaintViewController

#pragma mark - Life Circle
- (void)viewDidLoad
{
    [super viewDidLoad];
    @weakify(self);
    [self showFirstHud];
    [self rac_liftSelector:@selector(showToast:) withSignals:[[RACObserve(self.viewModel, error) ignore:nil] map:^id (id value) {
        @strongify(self);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self hideFirstHud];
        if(self.viewModel.list.count < 1) {
            [self showNonetworkViewWithBlock:^{
                @strongify(self);
                [self.viewModel.orderCommand execute:nil];
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
    [[RACObserve(self.viewModel, isNoMoreDate) ignore:@(NO)] subscribeNext:^(id x) {
        @strongify(self);
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }];
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"ComplaintRefreshNotification" object:nil] subscribeNext:^(id x) {
        @strongify(self);
        [self.viewModel.orderCommand execute:nil];
    }];
    [self.viewModel.orderCommand execute:nil];
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

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    if([segue.identifier isEqualToString:@"list_detail"]) {
//        XPDetailViewController *detailViewController = segue.destinationViewController;
//        UITableViewCell *cell = [self.tableView selectedCell];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
//        detailViewController.detailModel = self.viewModel.list[indexPath.row];
//    }
//}

#pragma mark - Delegate
#pragma mark - UITableView Deleagate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewModel.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XPComplaintTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell bindModel:self.viewModel.list[indexPath.row]];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    XPDetailViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"XPDetailViewController"];
    viewController.detailModel = self.viewModel.list[indexPath.row];;
    [self pushViewController:viewController];
}

#pragma mark - Event Responds

- (IBAction)complaintItemAction:(id)sender
{
    XPComplaintViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"XPComplaintViewController"];
    [self pushViewController:viewController];
    
}


#pragma mark - Private Methods

#pragma mark - Getter & Setter

#pragma mark - Getter & Setter

@end
