//
//  XPYellowPageViewController.m
//  XPApp
//
//  Created by CaoShunQing on 16/1/14.
//  Copyright © 2016年 ShareMerge. All rights reserved.
//

#import "XPYellowPageViewController.h"
#import "XPYellowPageViewModel.h"
#import <MJRefresh/MJRefresh.h>
#import "XPCommonRefreshFooter.h"
#import "XPCommonRefreshHeader.h"
#import "UIView+block.h"
#import "XPYellowPageModel.h"

@interface XPYellowPageViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-property-synthesis"
@property (strong, nonatomic) IBOutlet XPYellowPageViewModel *viewModel;
#pragma clang diagnostic pop
@end

@implementation XPYellowPageViewController

#pragma mark - Life Circle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"黄页";
    @weakify(self);
    [self showFirstHud];
    [self rac_liftSelector:@selector(showToast:) withSignals:[[RACObserve(self.viewModel, error) ignore:nil] map:^id (id value) {
        [self hideLoader];
        @strongify(self);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self hideFirstHud];
        if(self.viewModel.pageArray.count < 1) {
            [self showNonetworkViewWithBlock:^{
                @strongify(self);
                [self.viewModel.yellowPageCommand execute:nil];
            }];
        }
        return [value localizedDescription];
    }], nil];
    [[RACObserve(self.viewModel, pageArray) ignore:nil] subscribeNext:^(id x) {
        @strongify(self);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self hideFirstHud];
        if(self.viewModel.pageArray.count < 1) {
            [self showNoDataViewWithType:NoDataTypeOfDefault];
            return;
        }
        [self removeNoNetworkView];
        [self.tableView reloadData];
    }];
    [self.viewModel.yellowPageCommand execute:nil];
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.mj_header = [XPCommonRefreshHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self.viewModel.yellowPageCommand execute:nil];
    }];
}

#pragma mark UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewModel.pageArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XPYellowPagecell" forIndexPath:indexPath];
    UILabel *detailLabel = [cell viewWithTag:10];
    UIButton *telLabel = [cell viewWithTag:11];
    UILabel *phoneLabel = [cell viewWithTag:12];
    UILabel *nameLabel = [cell viewWithTag:13];
    XPYellowPageModel *model = self.viewModel.pageArray[indexPath.row];
    detailLabel.text = model.title;
    phoneLabel.text = model.telephone;
    nameLabel.text = model.name;
    [[telLabel rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        NSMutableString *phone = [[NSMutableString alloc] initWithFormat:@"telprompt://%@",model.telephone];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phone]];
    }];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end
