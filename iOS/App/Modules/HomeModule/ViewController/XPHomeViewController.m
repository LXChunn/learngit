//
//  XPHomeViewController.m
//  XPApp
//
//  Created by xinpinghuang on 12/23/15.
//  Copyright 2015 ShareMerge. All rights reserved.
//

#import "XPAnnouncementViewController.h"
#import "XPHomeViewController.h"
#import "XPLoginModel.h"
#import "XPLoginViewController.h"
#import "XPPropertyBillListViewController.h"
#import "XPUser.h"
#import "XPUserInfoViewModel.h"
#import <MJRefresh/MJRefresh.h>
#import <Masonry/Masonry.h>
#import <SDWebImage-ProgressView/UIImageView+ProgressView.h>
#import <XPAdPageView/XPADView.h>
#import <XPAutoNIBColor/XPAutoNIBColor.h>
#import <XPKit/XPKit.h>
#import "XPPropertyBillListViewController.h"
#import "XPDetailAnnounceViewController.h"
#import <UIImageView+WebCache.h>
#import "XPCommonRefreshHeader.h"
#import "XPCommonRefreshFooter.h"
#import "XPHomeADCell.h"
#import "XPCommercialServiceCell.h"
#import "XPFinancialServicesCell.h"
#import "XPCommonWebViewController.h"
#import "XPGuidePageViewController.h"

@interface XPHomeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic, strong) XPUserInfoViewModel *userInfoViewModel;
@property (nonatomic,strong)NSMutableArray *themePictures;

@end

@implementation XPHomeViewController

#pragma mark - Life Circle
- (void)viewDidLoad
{
    [super viewDidLoad];
    _themePictures = [NSMutableArray array];
    [self userInfo];
    @weakify(self);
    [self rac_liftSelector:@selector(showToast:) withSignals:[[RACObserve(self.userInfoViewModel, error) ignore:nil] map:^id (id value) {
        [self.myTableView.mj_header endRefreshing];
        return [value localizedDescription];
    }], nil];
    
    [[RACObserve(self.userInfoViewModel, list) ignore:nil] subscribeNext:^(id x) {
        @strongify(self);
        [_themePictures removeAllObjects];
        for (XPAnnouncementModel *model in self.userInfoViewModel.list)
        {
            if (model.themePicUrl) {
                [_themePictures addObject:model.themePicUrl];
            }
        }
        [_myTableView reloadData];
        [self.myTableView.mj_header endRefreshing];
    }];
    [self.userInfoViewModel.listCommand execute:nil];
    self.myTableView.mj_header = [XPCommonRefreshHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self.userInfoViewModel.listCommand execute:nil];
    }];
    self.myTableView.separatorColor = [UIColor clearColor];
}

- (void)viewWillAppear:(BOOL)animated{
    if ([XPUser isFirstLaunch]) {
        UIViewController * vc = [self instantiateViewControllerWithStoryboardName:@"GuidePage" identifier:@"XPGuidePageViewController"];
        [self.navigationController pushViewController:vc animated:NO];
    }
}

#pragma mark - Delegate
#pragma mark - UITableViewDelegateAndDatasource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self) weakSelf = self;
    switch (indexPath.row) {
        case 0:{
            XPHomeADCell * cell = [tableView dequeueReusableCellWithIdentifier:@"XPHomeADCell"];
            [cell configureUIWithImages:_themePictures clickBlock:^(NSInteger index) {
                XPAnnouncementModel *model = [self.userInfoViewModel.list objectAtIndex:index];
                XPDetailAnnounceViewController * viewController = (XPDetailAnnounceViewController *)[self instantiateViewControllerWithStoryboardName:@"CommunityAnnouncement" identifier:@"XPDetailAnnounceViewController"];
                viewController.detailModel = model;
                viewController.isHidden = YES;
                [weakSelf pushViewController:viewController];
            }];
            return cell;
        }
        case 1:{
            XPCommercialServiceCell * cell = [tableView dequeueReusableCellWithIdentifier:@"XPCommercialServiceCell"];
            [cell whenClickCommercialService:^(CommercialServiceType type) {
                switch (type) {
                    case CommercialServiceTypeOfCommunityBulletin:{
                        [weakSelf communityAnnouncementButtonTaped];
                       break;
                    }
                    case CommercialServiceTypeOfPropertyWarranty:{
                        [weakSelf maintenanceButtonTaped];
                        break;
                    }
                    case CommercialServiceTypeOfPropertyPayment:{
                        [weakSelf propertyBillButtonTaped];
                        break;
                    }
                    case CommercialServiceTypeOfCommunityForums:{
                        [weakSelf complaintButtonTaped];
                        break;
                    }
                    default:
                        break;
                }
            }];
            return cell;
        }
        case 2:{
            XPFinancialServicesCell * cell = [tableView dequeueReusableCellWithIdentifier:@"XPFinancialServicesCell"];
            [cell whenClickFinaccialService:^(FinancialServicesType type) {
                switch (type) {
                    case FinancialServicesTypeOfcreditCard:{
                        [self pushViewController:[self instantiateViewControllerWithStoryboardName:@"Home" identifier:@"XPCreditCardViewController"]];
                        break;
                    }
                    case FinancialServicesTypeOfloan:{
                        XPCommonWebViewController * webViewController = (XPCommonWebViewController *)[self instantiateViewControllerWithStoryboardName:@"Forum" identifier:@"XPCommonWebViewController"];
                        webViewController.navTitle = @"贷款";
                        webViewController.webUrl = @"http://dragonbutler.memeyin.com/h5/loans";
                        [self pushViewController:webViewController];
                        break;
                    }
                    case FinancialServicesTypeOfCCBBuy:{
                        XPCommonWebViewController * webViewController = (XPCommonWebViewController *)[self instantiateViewControllerWithStoryboardName:@"Forum" identifier:@"XPCommonWebViewController"];
                        webViewController.navTitle = @"善融";
                        webViewController.webUrl = @"http://js.gshccb.com/mobile";
                        [self pushViewController:webViewController];
                        break;
                    }
                    default:
                        break;
                }
            }];
            return cell;
        }
            
        default:
            return nil;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0){
        return [XPHomeADCell cellHeight];
    }else if (indexPath.row == 1){
        return [XPCommercialServiceCell cellHeight];
    }else {
        return [XPFinancialServicesCell cellHeight];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

#pragma mark - Event Responds
/**
 *  物业缴费
 */
- (void)propertyBillButtonTaped
{
    if(![self isLogin]) {
        [self presentLogin];
    } else {
        if(![self isBindHouse]) {
            [self presentBindHouse];
        } else {
            [self pushViewController:[self instantiateInitialViewControllerWithStoryboardName:@"PropertyBill"]];
        }
    }
}

/**
 *  社区公告
 */
- (void)communityAnnouncementButtonTaped
{
    if(![self isLogin]) {
        [self presentLogin];
    } else {
        if(![self isBindHouse]) {
            [self presentBindHouse];
        } else {
            [self pushViewController:[self instantiateInitialViewControllerWithStoryboardName:@"CommunityAnnouncement"]];
        }
    }
}

/**
 *  报修
 */
- (void)maintenanceButtonTaped
{
    if(![self isLogin]) {
        [self presentLogin];
    } else {
        if(![self isBindHouse]) {
            [self presentBindHouse];
        } else {
            UIViewController *viewController = [self instantiateInitialViewControllerWithStoryboardName:@"Maintenance"];
            [self pushViewController:viewController];
        }
    }
}

/**
 *  论坛
 */
- (void)complaintButtonTaped
{
    if(![self isLogin]) {
        [self presentLogin];
    } else {
        if(![self isBindHouse]) {
            [self presentBindHouse];
        } else {
            [self pushViewController:[self instantiateInitialViewControllerWithStoryboardName:@"Neighborhood"]];
        }
    }
}

#pragma mark - Private Methods
- (void)userInfo
{
    _userInfoViewModel = [[XPUserInfoViewModel alloc] init];
    if([self isLogin]) {
        [XPUser accessUserInfoInLoginModel];
        [_userInfoViewModel.userInfoCommand execute:nil];
    }
}

#pragma mark - Getter & Setter


@end
