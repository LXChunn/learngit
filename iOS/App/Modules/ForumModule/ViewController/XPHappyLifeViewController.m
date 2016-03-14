//
//  XPHappyLifeViewController.m
//  XPApp
//
//  Created by jy on 16/1/13.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import "XPHappyLifeViewController.h"
#import "XPHappyLifeViewModel.h"
#import <NSDate+DateTools.h>
#import "XPLoginModel.h"
#import "XPCommonWebViewController.h"

@interface XPHappyLifeViewController ()

@property (strong, nonatomic) IBOutlet XPHappyLifeViewModel *lifeViewModel;
@property (nonatomic,strong) NSString *navTitle;

@end

@implementation XPHappyLifeViewController

#pragma mark - Life Circle
- (void)viewDidLoad
{
    [super viewDidLoad];
    @weakify(self);
    [[RACObserve(self, lifeViewModel.webUrl)ignore:nil] subscribeNext:^(NSString * x) {
        @strongify(self);
        XPCommonWebViewController * webViewController = (XPCommonWebViewController *)[self instantiateViewControllerWithStoryboardName:@"Forum" identifier:@"XPCommonWebViewController"];
        webViewController.webUrl = x;
        webViewController.navTitle = self.navTitle;
        [self pushViewController:webViewController];
    }];
}

#pragma mark - Delegate

#pragma mark - Event Responds
- (IBAction)lifeServiceAction:(id)sender {
    self.navTitle = @"缴费充值";
    self.lifeViewModel.billType = BillTypeOfPay;
    [self configureData];
    [self.lifeViewModel.webCommand execute:nil];
}

- (IBAction)entertainmentTravelAction:(id)sender {
    self.navTitle = @"教育服务";
    self.lifeViewModel.billType = BillTypeOfEduication;
    [self configureData];
    [self.lifeViewModel.webCommand execute:nil];
}

- (IBAction)financialServiceAction:(id)sender {
    self.navTitle = @"保险医疗";
    self.lifeViewModel.billType = BillTypeOfMedical;
    [self configureData];
    [self.lifeViewModel.webCommand execute:nil];
}

#pragma mark - Private Methods
- (void)configureData
{
    self.lifeViewModel.time = [self getNowTime];
    self.lifeViewModel.date = [self getNowDate];
    self.lifeViewModel.cityCode = [XPLoginModel singleton].household.cityCode;
}

- (NSString *)getNowDate{
    return [[NSDate date] formattedDateWithFormat:@"YYYYMMDD"];
}

- (NSString *)getNowTime{
    return [[NSDate date] formattedDateWithFormat:@"hhmmss"];
}

#pragma mark - Getter & Setter

@end 
