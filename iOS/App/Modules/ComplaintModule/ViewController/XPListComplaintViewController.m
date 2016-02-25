//
//  XPMyMaintenanceViewController.m
//  XPApp
//

//  Created by xinpinghuang on 12/25/15.
//  Copyright 2015 ShareMerge. All rights reserved.

//

#import "XPListComplaintViewController.h"
#import "XPComplaintModel.h"
#import "XPComplaintViewModel.h"
#import "XPComplaintTableViewCell.h"
#import "XPDetailViewController.h"
#import <UITableView+XPKit.h>
#import <MJRefresh/MJRefresh.h>

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
    [self rac_liftSelector:@selector(cleverLoader:) withSignals:RACObserve(self.viewModel, executing), nil];
    [self rac_liftSelector:@selector(showToast:) withSignals:[[RACObserve(self.viewModel, error) ignore:nil] map:^id (id value) {
        return [value localizedDescription];
    }], nil];
    @weakify(self);
    [[RACObserve(self.viewModel, list) ignore:nil] subscribeNext:^(id x) {
        @strongify(self);
        [self.tableView reloadData];
    }];
    [self.viewModel.orderCommand execute:nil];
    [self.tableView hideEmptySeparators];

    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];
    }];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"list_detail"]) {
        XPDetailViewController *detailViewController = segue.destinationViewController;
        UITableViewCell *cell = [self.tableView selectedCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        detailViewController.model = self.viewModel.list[indexPath.row];
    }
}

#pragma mark - Delegate
#pragma mark - UITableView Deleagate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewModel.list.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XPComplaintTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell bindModel:self.viewModel.list[indexPath.row]];
    return cell;
}


#pragma mark - Event Responds

#pragma mark - Private Methods

#pragma mark - Getter & Setter

#pragma mark - Getter & Setter

@end
