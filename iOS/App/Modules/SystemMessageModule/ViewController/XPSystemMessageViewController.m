//
//  XPSystemMessageViewController.m
//  XPApp
//
//  Created by jy on 16/1/15.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import "XPSystemMessageViewController.h"
#import "XPSystemMessageViewModel.h"
#import "XPSystemMessageModel.h"
#import "XPCommonRefreshHeader.h"
#import "XPCommonRefreshFooter.h"
#import "UIView+HESizeHeight.h"
#import <NSDate+DateTools.h>
#import "XPLoginModel.h"
#import "XPSystemMessageDetailViewController.h"

@interface XPSystemMessageViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) IBOutlet XPSystemMessageViewModel *systemMessageViewModel;


@end

@implementation XPSystemMessageViewController

#pragma mark - Life Circle
- (void)viewDidLoad
{
    [super viewDidLoad];
    @weakify(self);
    [self showFirstHud];
    [self rac_liftSelector:@selector(showToast:) withSignals:[[RACObserve(self.systemMessageViewModel, error) ignore:nil] map:^id (id value) {
        @strongify(self);
        [self.myTableView.mj_header endRefreshing];
        [self.myTableView.mj_footer endRefreshing];
        [self hideFirstHud];
        if (self.systemMessageViewModel.list.count < 1)
        {
            [self showNonetworkViewWithBlock:^{
                [self.systemMessageViewModel.reloadCommand execute:nil];
            }];
        }
        return [value localizedDescription];
    }], nil];
    [[RACObserve(self.systemMessageViewModel, list) ignore:nil] subscribeNext:^(id x) {
        @strongify(self);
        [self.myTableView.mj_header endRefreshing];
        [self.myTableView.mj_footer endRefreshing];
        [self hideFirstHud];
        if (self.systemMessageViewModel.list.count < 1)
        {
            [self showNoDataViewWithType:NoDataTypeOfDefault];
            return;
        }
        [self removeNoNetworkView];
        [self.myTableView reloadData];
    }];
    [self.systemMessageViewModel.reloadCommand execute:nil];
    [[RACObserve(self.systemMessageViewModel, isNoMoreDate) ignore:@(NO)] subscribeNext:^(id x) {
        @strongify(self);
        [self.myTableView.mj_footer endRefreshingWithNoMoreData];
    }];
    self.myTableView.mj_header = [XPCommonRefreshHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self.systemMessageViewModel.reloadCommand execute:nil];
    }];
    self.myTableView.mj_footer = [XPCommonRefreshFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self.systemMessageViewModel.moreCommand execute:nil];
    }];
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"RefreshSystemMessageListNotification" object:nil] subscribeNext:^(id x) {
        @strongify(self);
       [self.systemMessageViewModel.moreCommand execute:nil];
    }];
    self.myTableView.separatorColor = [UIColor clearColor];
}

#pragma mark - Delegate
#pragma mark - UITableViewDelegateAndDatasource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XPSystemMessageModel * model = [self.systemMessageViewModel.list objectAtIndex:indexPath.row];
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ListCell"];
    if(!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ListCell" owner:nil options:nil] lastObject];
    }
    UILabel * contentLabel = [cell viewWithTag:1];
    contentLabel.text = model.content;
    UILabel * dateLabel = [cell viewWithTag:11];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.createdAt.doubleValue];
    dateLabel.text = [date formattedDateWithFormat:@"YYYY-MM-dd hh:mm"];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XPSystemMessageModel * model = [self.systemMessageViewModel.list objectAtIndex:indexPath.row];
    if ([UIView getTextSizeHeight:model.content font:14 withSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 30, MAXFLOAT)] > 21) {
        return 34 + 54;
    }
    else{
        return 17 + 54;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.systemMessageViewModel.list.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    XPSystemMessageModel * model = [self.systemMessageViewModel.list objectAtIndex:indexPath.row];
    XPSystemMessageDetailViewController * detaiViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"XPSystemMessageDetailViewController"];
    detaiViewController.systemMessageModel = model;
    [self pushViewController:detaiViewController];
}

#pragma mark - Event Responds

#pragma mark - Private Methods

#pragma mark - Getter & Setter

@end 
