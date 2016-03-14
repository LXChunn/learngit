//
//  XPJFZDViewController.m
//  XPApp
//
//  Created by Mac OS on 15/12/19.
//  Copyright © 2015年 ShareMerge. All rights reserved.
//

#import "XPPropertyBillModel.h"
#import "XPPropertyBillTableViewCell.h"
#import "XPPropertyBillViewController.h"
#import "XPPropertyBillViewModel.h"
#import "XPUser.h"
#import <MJRefresh.h>
#import "XPCommonRefreshHeader.h"
#import "XPCommonRefreshFooter.h"
#import "XPCommonWebViewController.h"

@interface XPPropertyBillViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSString *_status;
    BOOL _isBack;
    NSString * _billId;
    NSInteger _requestCount;
}
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-property-synthesis"
@property (strong, nonatomic) IBOutlet XPPropertyBillViewModel *viewModel;
#pragma clang diagnostic pop
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (assign, nonatomic) NSInteger stutaType;

@end

@implementation XPPropertyBillViewController
;

#pragma mark - Life Circle
- (void)viewDidLoad
{
    [super viewDidLoad];
    @weakify(self);
    _requestCount = 0;
    [self showFirstHud];
    [self rac_liftSelector:@selector(showToast:) withSignals:[[RACObserve(self.viewModel, error) ignore:nil] map:^id (id value) {
        [self hideLoader];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self hideFirstHud];
        [self hideLoader];
        if(self.viewModel.list.count < 1) {
            [self showNonetworkViewWithBlock:^{
                @strongify(self);
                [self.viewModel.listCommand execute:nil];
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
    [[RACObserve(self.viewModel, paymentUrlDic)ignore:nil] subscribeNext:^(id x) {
       @strongify(self);
        [UIAlertView alertViewWithTitle:@"提示" message:@"请选择缴费的方式" block:^(NSInteger buttonIndex) {
            @strongify(self);
            XPCommonWebViewController * webViewController = (XPCommonWebViewController *)[self instantiateViewControllerWithStoryboardName:@"Forum" identifier:@"XPCommonWebViewController"];
            if (buttonIndex == 0) {
                webViewController.webUrl = x[@"ccb_pay_url"];
                webViewController.navTitle = @"建行用户支付";
//                [webViewController whenPaymentSuccess:^{
//                    _requestCount = 0;
//                    _isBack = NO;
//                    [self.viewModel.listCommand execute:nil];
//                }];
                _isBack = YES;
                self.navigationController.interactivePopGestureRecognizer.enabled = NO;
                [self pushViewController:webViewController];
            }else if (buttonIndex == 1){
                webViewController.webUrl = x[@"union_pay_url"];
                webViewController.navTitle = @"非建行用户支付";
//                [webViewController whenPaymentSuccess:^{
//                    _requestCount = 0;
//                    _isBack = NO;
//                    [self.viewModel.listCommand execute:nil];
//                }];
                _isBack = YES;
                self.navigationController.interactivePopGestureRecognizer.enabled = NO;
                [self pushViewController:webViewController];
            }
        } cancelButtonTitle:@"建行用户" otherButtonTitles:@"非建行用户",@"取消", nil];
    }];
    [[RACObserve(self.viewModel, isPaymentResult) ignore:nil] subscribeNext:^(id x) {
       @strongify(self);
        if (self.viewModel.isPaymentResult || _requestCount>=5) {
            [self hideLoader];
            _requestCount = 0;
            [self.viewModel.listCommand execute:nil];
        }else{
            if (_isBack) {
               [self lazyRequestResult];
            }
        }
    }];
    self.viewModel.status = [NSString stringWithFormat:@"%ld", (long)(_pageIndex + 1)];
    [self.viewModel.listCommand execute:nil];
    [self.tableView hideEmptySeparators];
    self.tableView.mj_header = [XPCommonRefreshHeader headerWithRefreshingBlock:^{
        [self.viewModel.listCommand execute:nil];
    }];
    self.tableView.mj_footer = [XPCommonRefreshFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self.viewModel.moreListCommand execute:nil];
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
//#warning 从支付成功界面返回的时候没做处理
    __weak typeof(self) weakSelf = self;
    if (_isBack) {
        [UIAlertView alertViewWithTitle:@"提示" message:@"是否支付?" block:^(NSInteger buttonIndex) {
            if (buttonIndex == 0) {
                _isBack = NO;
            }else{
                weakSelf.viewModel.billId = _billId;
                [weakSelf showLoader];
                _requestCount = 1;
                [weakSelf.viewModel.paymentResultCommand execute:nil];
            }
        }cancelButtonTitle:@"未支付" otherButtonTitles:@"已支付", nil];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

#pragma mark - Delegate
#pragma mark - UITableView Deleagate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewModel.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XPPropertyBillTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    [cell bindModel:self.viewModel.list[indexPath.row]];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_pageIndex == 0) {
        XPPropertyBillModel * model = self.viewModel.list[indexPath.row];
        _billId = model.billId;
        self.viewModel.billId = _billId;
        [self.viewModel.paymentCommand execute:nil];
    }
}

#pragma mark - Event Responds

#pragma mark - Private Methods
- (void)lazyRequestResult{
    __weak typeof(self) weakSelf = self;
    [NSTimer scheduledTimerWithTimeInterval:2 block:^{
        _requestCount ++;
        [weakSelf.viewModel.paymentResultCommand execute:nil];
    } repeats:NO];
}


#pragma mark - Getter & Setter

@end
