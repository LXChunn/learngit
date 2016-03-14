//
//  XPMyActivityViewController.m
//  XPApp
//
//  Created by CaoShunQing on 16/1/7.
//  Copyright © 2016年 ShareMerge. All rights reserved.
//

#import "XPActivitViewModel.h"
#import "XPActivityTableViewCell.h"
#import "XPEventDetailViewController.h"
#import "XPMyActivityViewController.h"
#import <MJRefresh/MJRefresh.h>
#import <UITableView+XPKit.h>
#import "XPCommonRefreshHeader.h"
#import "XPCommonRefreshFooter.h"

@interface XPMyActivityViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-property-synthesis"
@property (strong, nonatomic) IBOutlet XPActivitViewModel *activityModel;
#pragma clang diagnostic pop
@property (nonatomic, strong) NSMutableArray *sourceArray;
@end

@implementation XPMyActivityViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"我的活动";
    @weakify(self);
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self showFirstHud];
//    [self rac_liftSelector:@selector(cleverLoader:) withSignals:RACObserve(self.activityModel, executing), nil];
    [self rac_liftSelector:@selector(showToast:) withSignals:[[RACObserve(self.activityModel, error) ignore:nil] map:^id (id value) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self hideFirstHud];
        if(self.activityModel.souceArray.count < 1) {
            @strongify(self);
            [self showNonetworkViewWithBlock:^{
                @strongify(self);
                [self.activityModel.activtyCommand execute:nil];
            }];
        }
        return [value localizedDescription];
    }], nil];
    
    [[RACObserve(self.activityModel, souceArray) ignore:nil] subscribeNext:^(id x) {
        @strongify(self);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self hideFirstHud];
        if(self.activityModel.souceArray.count <1) {
            [self showNoDataViewWithType:NoDataTypeOfDefault];
            return;
        }
        [self.tableView reloadData];
        [self removeNoNetworkView];
    }];
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"MyactivityRefreshNotification" object:nil] subscribeNext:^(id x) {
        @strongify(self);
        [self.activityModel.activtyCommand execute:nil];
    }];
    [self.activityModel.activtyCommand execute:nil];
    self.tableView.mj_header = [XPCommonRefreshHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self.activityModel.activtyCommand execute:nil];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.activityModel.souceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XPActivityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XPActivityTableViewCell"];
    if(!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"XPActivityTableViewCell" owner:nil options:nil] firstObject];
    }
    [cell bindModel:self.activityModel.souceArray[indexPath.row]];
    tableView.separatorColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    XPEventDetailViewController *controller = (XPEventDetailViewController *)[self instantiateViewControllerWithStoryboardName:@"Event" identifier:@"XPEventDetailViewController"];
    XPTopicModel *model = self.activityModel.souceArray[indexPath.row];
    controller.forumtopicId = model.forumTopicId;
    [self pushViewController:controller];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XPTopicModel *model = self.activityModel.souceArray[indexPath.row];
    return [XPActivityTableViewCell cellHeightWithArray:model.extra.picUrls];
}

@end
