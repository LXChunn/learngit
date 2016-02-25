//
//  XPHomeViewController.m
//  XPApp
//
//  Created by xinpinghuang on 12/23/15.
//  Copyright 2015 ShareMerge. All rights reserved.
//

#import "XPAnnouncementViewController.h"
#import "XPHomeViewController.h"
#import <MJRefresh/MJRefresh.h>
#import <Masonry/Masonry.h>
#import <SDWebImage-ProgressView/UIImageView+ProgressView.h>
#import <XPAdPageView/XPADView.h>
#import <XPAutoNIBColor/XPAutoNIBColor.h>
#import <XPKit/XPKit.h>
#import "XPLoginModel.h"
#import "XPLoginViewController.h"
#import "XPUser.h"
#import "XPUserInfoViewModel.h"

@interface XPHomeViewController ()<XPAdViewDelegate>

@property (nonatomic, strong) XPADView *adView;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIView *adContentView;
@property (nonatomic, weak) IBOutlet UIView *financialServiceView;

@property (nonatomic, weak) IBOutlet UIButton *propertyBillButton;
@property (nonatomic, weak) IBOutlet UIButton *communityAnnouncementButton;
@property (nonatomic, weak) IBOutlet UIButton *maintenanceButton;
@property (nonatomic, weak) IBOutlet UIButton *complaintButton;
@property (nonatomic,strong) XPUserInfoViewModel *userInfoViewModel;
@end

@implementation XPHomeViewController

#pragma mark - Life Circle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.adView.delegate = self;
    [self.adContentView addSubview:self.adView];
    [self.adView mas_remakeConstraints:^(MASConstraintMaker *make){
        make.leading.top.trailing.bottom.mas_equalTo(0);
    }];
    [self configFinancialService];
    
    @weakify(self);
    [[self.propertyBillButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self propertyBillButtonTaped];
    }];
    [[self.communityAnnouncementButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self communityAnnouncementButtonTaped];
    }];
    [[self.maintenanceButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self maintenanceButtonTaped];
    }];
    [[self.complaintButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self complaintButtonTaped];
    }];
    
#warning  测试数据
    [self.adView setDataArray:@[
                                @"http://img2.3lian.com/img2007/19/33/005.jpg",
                                @"http://pica.nipic.com/2008-03-19/2008319183523380_2.jpg",
                                @"http://pic.nipic.com/2007-11-09/200711912230489_2.jpg"
                                ]];
    [self.adView perform];
#warning   测试数据
    
    self.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self.scrollView.mj_header endRefreshing];
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    XPUser * user = [[XPUser alloc] init];
    if (![user getAccessToken])
    {
        UIViewController * viewController = [self instantiateInitialViewControllerWithStoryboardName:@"Login"];
        [self presentViewController:viewController animated:YES completion:nil];
    }
    else
    {
        [self showLoader];
        [XPLoginModel singleton].accessToken = [user getAccessToken];
        if (!_userInfoViewModel)
        {
            _userInfoViewModel = [[XPUserInfoViewModel alloc] init];
        }
        [[RACObserve(self, userInfoViewModel.model) ignore:nil] subscribeNext:^(id x) {
            [self hideLoader];
            if (![XPLoginModel singleton].isBound)
            {
                [self.parentViewController presentViewController:[self instantiateInitialViewControllerWithStoryboardName:@"Household"] animated:YES completion:nil];
            }
        }];
        [_userInfoViewModel.userInfoCommand execute:nil];
    }
    [super viewDidAppear:animated];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self.scrollView setContentSize:ccs(self.view.width, self.financialServiceView.frame.origin.y+self.financialServiceView.height)];
}

#pragma mark - Delegate
#pragma mark - XPAdPageView Delegate
- (void)adView:(XPADView *)adView didSelectedAtIndex:(NSUInteger)index imageView:(UIImageView *)imageView imagePath:(NSString *)imagePath
{
}

- (void)adView:(XPADView *)adView lazyLoadAtIndex:(NSUInteger)index imageView:(UIImageView *)imageView imageURL:(NSString *)imageURL
{
    [imageView sd_setImageWithURL:[NSURL URLWithString:imageURL] usingProgressView:nil];
}

#pragma mark - Event Responds
/**
 *  物业账单
 */
- (void)propertyBillButtonTaped
{
    [self pushViewController:[self instantiateInitialViewControllerWithStoryboardName:@"PropertyBill"]];
}

/**
 *  社区公告
 */
- (void)communityAnnouncementButtonTaped
{
    [self pushViewController:[self instantiateInitialViewControllerWithStoryboardName:@"Community"]];
}

/**
 *  报修
 */
- (void)maintenanceButtonTaped
{
    UIViewController *viewController = [self instantiateInitialViewControllerWithStoryboardName:@"Maintenance"];
    [self pushViewController:viewController];
}

/**
 *  投诉
 */
- (void)complaintButtonTaped
{
    UIViewController *viewController = [self instantiateInitialViewControllerWithStoryboardName:@"Complaint"];
    [self pushViewController:viewController];
}

#pragma mark - Private Methods
/**
 *  配置金融服务UI
 */
- (void)configFinancialService
{
    NSArray *resources = @[
                           @[@"home_investment", @"理财"],
                           @[@"home_mortgage", @"分期"],
                           @[@"home_loan", @"贷款"],
                           @[@"home_e_business", @"电商"]
                           ];
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    for(NSInteger i = 0; i < 4; i++) {
        UIButton *itemButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [itemButton setImage:[UIImage imageNamed:resources[i][0]] forState:UIControlStateNormal];
        [self.financialServiceView addSubview:itemButton];
        [itemButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(44);
            make.left.mas_equalTo(i*width/4);
            make.width.height.mas_equalTo(width/4);
        }];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:ccr(0, 0, 0, 0)];
        titleLabel.text = resources[i][1];
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.textColor = [XPAutoNIBColor colorWithName:@"c2"];
        [itemButton addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(itemButton);
            make.top.equalTo(itemButton.mas_centerY).mas_offset(itemButton.height).mas_offset(20);
        }];
    }
    [self.financialServiceView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(width/4+50);
    }];
}

#pragma mark - Getter & Setter
- (XPADView *)adView
{
    if(!_adView) {
        _adView = [[XPADView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _adView.displayTime = 4;
    }
    
    return _adView;
}

@end
