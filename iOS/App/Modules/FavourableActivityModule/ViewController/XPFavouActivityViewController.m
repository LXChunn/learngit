//
//  XPFavouActivityViewController.m
//  XPApp
//
//  Created by CaoShunQing on 16/1/18.
//  Copyright © 2016年 ShareMerge. All rights reserved.
//

#import "XPFavouActivityViewController.h"
#import "XPFavourActivityViewModel.h"
#import "XPMyFavActivityCell.h"
#import <MJRefresh/MJRefresh.h>
#import "XPCommonRefreshFooter.h"
#import "XPCommonRefreshHeader.h"
#import "XPFavourActivityDetailViewController.h"

@interface XPFavouActivityViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-property-synthesis"
@property (strong, nonatomic) IBOutlet XPFavourActivityViewModel *viewModel;
#pragma clang diagnostic pop
@property (nonatomic,assign)NSInteger selectIndex;
@end

@implementation XPFavouActivityViewController

#pragma mark lifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc]init];
    @weakify(self);
    [self showFirstHud];
    [self rac_liftSelector:@selector(showToast:) withSignals:[[RACObserve(self.viewModel, error) ignore:nil] map:^id (id value) {
        @strongify(self);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self hideFirstHud];
        if(self.viewModel.activityArray.count < 1) {
            [self showNonetworkViewWithBlock:^{
                @strongify(self);
                [self.viewModel.activityCommand execute:nil];
            }];
        }
        return [value localizedDescription];
    }], nil];

    [[RACObserve(self.viewModel, activityArray) ignore:nil] subscribeNext:^(id x) {
        @strongify(self);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self hideFirstHud];
        if(self.viewModel.activityArray.count < 1) {
            
            [self showNoDataViewWithType:NoDataTypeOfDefault];
            return;
        }

        [self removeNoNetworkView];
        [self.tableView reloadData];
    }];
    [self.viewModel.activityCommand execute:nil];
    self.tableView.separatorColor = [UIColor clearColor];
    [[RACObserve(self.viewModel, isNoMoreDate) ignore:@(NO)] subscribeNext:^(id x) {
        @strongify(self);
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }];
    self.tableView.mj_header = [XPCommonRefreshHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self.viewModel.activityCommand execute:nil];
    }];
    self.tableView.mj_footer = [XPCommonRefreshFooter footerWithRefreshingBlock:^{
        [self.viewModel.activityMoreCommand execute:nil];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
  self.title = @"优惠活动";
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"XPFavourActivityDetailViewController"]) {
        XPFavourActivityDetailViewController *controller = segue.destinationViewController;
        controller.sourceModel = self.viewModel.activityArray[_selectIndex];
    }
}

#pragma mark UITableViewdelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 111;
}

#pragma mark DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewModel.activityArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XPMyFavActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XPMyFavActivityCell"];
    if(!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"XPMyFavActivityCell" owner:nil options:nil] firstObject];
    }
    [cell bindModel:self.viewModel.activityArray[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   [self performSegueWithIdentifier:@"XPFavourActivityDetailViewController" sender:self];
    [self setHidesBottomBarWhenPushed:YES];
    self.selectIndex = indexPath.row;
}

@end
