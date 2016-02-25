//
//  XPSecondHandContentViewController.m
//  XPApp
//
//  Created by jy on 15/12/29.
//  Copyright 2015年 ShareMerge. All rights reserved.
//

#import "XPSecondHandContentViewController.h"
#import "XPSecondHandCell.h"
#import "XPSecondHandViewModel.h"
#import "XPSecondHandItemsListModel.h"
#import <MJRefresh.h>
#import "XPSecondHandOfPostDetailViewController.h"

@interface XPSecondHandContentViewController ()
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic,strong) NSString * lastSecondHandItemId;
#pragma clang diagnostic ignored "-Wobjc-property-synthesis"
@property (strong, nonatomic) IBOutlet XPSecondHandViewModel *viewModel;


@end

@implementation XPSecondHandContentViewController

#pragma mark - Life Circle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self rac_liftSelector:@selector(cleverLoader:) withSignals:RACObserve(self.viewModel, executing), nil];
    [self rac_liftSelector:@selector(showToast:) withSignals:[[RACObserve(self.viewModel, error) ignore:nil] map:^id (id value) {
        [self.myTableView.mj_header endRefreshing];
        [self.myTableView.mj_footer endRefreshing];
        return [value localizedDescription];
    }], nil];
    
    @weakify(self);
    [[RACObserve(self.viewModel, list) ignore:nil] subscribeNext:^(id x) {
        @strongify(self);
        if (self.viewModel.list.count == 0)
        {
            return;
        }
        XPSecondHandItemsListModel * model = [self.viewModel.list objectAtIndex:(self.viewModel.list.count - 1)];
        self.lastSecondHandItemId = model.secondhandItemId;
        [self.myTableView reloadData];
        [self.myTableView.mj_header endRefreshing];
        [self.myTableView.mj_footer endRefreshing];
    }];
    self.viewModel.type = [NSString stringWithFormat:@"%ld",(_pageIndex + 1)];
    [self.viewModel.listCommand execute:nil];
    self.myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self.viewModel.listCommand execute:nil];
    }];
    self.myTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        self.viewModel.lastSecondHandItemId = _lastSecondHandItemId;
        [self.viewModel.listCommand execute:nil];
    }];
    
}
#pragma mark - UItableViewDelegateAndDataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XPSecondHandCell * cell = [tableView dequeueReusableCellWithIdentifier:@"XPSecondHandCell" forIndexPath:indexPath];
    if (indexPath.row >= self.viewModel.list.count - 1)
    {
        cell.lineLabel.hidden = YES;
    }
    else
    {
        cell.lineLabel.hidden = NO;
    }
    [cell bindModel:self.viewModel.list[indexPath.row]];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XPSecondHandItemsListModel * model = self.viewModel.list[indexPath.row];
    return [XPSecondHandCell cellHeightWithArray:model.picUrls];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewModel.list.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    XPSecondHandItemsListModel * model = self.viewModel.list[indexPath.row];
    XPSecondHandOfPostDetailViewController * viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"XPSecondHandOfPostDetailViewController"];
    viewController.secondHandItemId = model.secondhandItemId;
    [self pushViewController:viewController];
}

#pragma mark - Event Responds

#pragma mark - Private Methods

#pragma mark - Getter & Setter

@end 
