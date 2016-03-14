//
//  XPLaunchViewModel.m
//  XPApp
//
//  Created by huangxinping on 5/11/15.
//  Copyright (c) 2015 iiseeuu.com. All rights reserved.
//

#import "XPHomeViewController.h"
#import "XPLaunchViewModel.h"
#import "XPLoginStorage.h"
#import <Aspects/Aspects.h>
#import <Masonry/Masonry.h>
#import <UIKit/UIKit.h>
#import <XPKit/XPKit.h>

#import "XPLaunchView.h"

@implementation XPLaunchViewModel
{
}

+ (void)load
{
    [super load];
    [XPLaunchViewModel sharedInstance];
}

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static XPLaunchViewModel *sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[XPLaunchViewModel alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    if(self = [super init]) {
        //        [UIViewController aspect_hookSelector:@selector(loadView) withOptions:AspectPositionAfter usingBlock:^(id < AspectInfo > aspectInfo) {
        //            [self loadView:[aspectInfo instance]];
        //        }
        //                                        error:nil];
        //
        //        [UIViewController aspect_hookSelector:@selector(viewWillAppear:) withOptions:AspectPositionAfter usingBlock:^(id < AspectInfo > aspectInfo, BOOL animated) {
        //            [self viewWillApear:animated viewController:[aspectInfo instance]];
        //        }
        //                                        error:nil];
    }
    
    return self;
}

#pragma mark - fake methods
- (void)loadView:(UIViewController *)viewController
{
    NSString *viewControllerClass = [viewController className];
    if([viewControllerClass isEqualToString:@"XPHomeViewController"]) {
        NSArray *launchNib = [[NSBundle mainBundle] loadNibNamed:@"LaunchView" owner:nil options:nil];
        if(launchNib && launchNib.count) {
            XPLaunchView *launchView = [launchNib lastObject];
            NSAssert(launchView, @"启动页创建失败！");
            UIWindow *mainWindow = [UIApplication sharedApplication].keyWindow;
            [mainWindow addSubview:launchView];
            [launchView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.top.trailing.bottom.mas_equalTo(0);
            }];
            [launchView startAnimation];
        }
    }
}

- (void)viewWillApear:(BOOL)animated viewController:(UIViewController *)viewController
{
    //    XPLogInfo(@"%@ will appear.", [viewController className]);
}

#pragma mark - Private Methods
//- (void)checkLogin:(UIViewController *)viewController
//{
//    [(XPMainViewController *)viewController presentLogin];
//}

@end
