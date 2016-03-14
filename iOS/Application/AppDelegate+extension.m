//
//  AppDelegate+extension.m
//  XPApp
//
//  Created by huangxinping on 15/7/2.
//  Copyright (c) 2015年 iiseeuu.com. All rights reserved.
//

#import "AppDelegate+extension.h"
#import <AFNetworking/AFNetworkActivityIndicatorManager.h>

#import <XPAutoNIBColor/XPAutoNIBColor.h>
#import <XPAutoNIBi18n/XPAutoNIBi18n.h>

#import <AFNetworkActivityLogger/AFNetworkActivityLogger.h>
#import <AFNetworking/AFNetworkReachabilityManager.h>
#import <AFNetworkingMeter/AFNetworkingMeter.h>
#import <MMPlaceHolder/MMPlaceHolder.h>
#import <NSLogger/NSLogger.h>

#import <OCUDL/OCUDL.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import <UISS/UISS.h>
#import <UMengAnalytics-NO-IDFA/MobClick.h>
#import <XPKit/XPKit.h>

#import "WXApi.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>

#import <JPush/APService.h>
#import <MMPReactiveNotification/MMPReactiveNotification.h>

#import "UIViewController+XPCurrentViewController.h"
#import "XPMyPrivateLetterListViewController.h"
#import "XPMyPrivateMessageDetailViewController.h"
#import "XPMeViewController.h"
#import <XPKit.h>
#import "XPBaseTabBarViewController.h"
#import "UIApplication+RACSignal.h"
#import "XPUser.h"
#import "XPSystemMessageViewController.h"
#import "XPLoginStorage.h"

@implementation AppDelegate (TestCase)

- (BOOL)minimumTestCase
{
    NSDictionary *environment = [[NSProcessInfo processInfo] environment];
    NSString *injectBundle = environment[@"XCInjectBundle"];
    BOOL isRunningTests = [[injectBundle pathExtension] isEqualToString:@"xctest"];
    return isRunningTests;
}

@end

@implementation AppDelegate (SystemSetting)

- (void)configSettingBundle
{
    NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    
    [[NSUserDefaults standardUserDefaults] setObject:version
                                              forKey:@"version_preference"];
    
    NSString *build = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    [[NSUserDefaults standardUserDefaults] setObject:build
                                              forKey:@"build_preference"];
    
    NSString *githash = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"GITHash"];
    [[NSUserDefaults standardUserDefaults] setObject:githash
                                              forKey:@"githash_preference"];
}

@end

@implementation AppDelegate (Theme)

- (void)configTheme
{
    //    [NSBundle setLanguage:@"zh-Hans"];
    UIColor *primaryColor = $(#2667B5);
    UIColor *secondaryColor = $(#474747);
    UIColor *tertiaryColor = $(#949494);
    [XPAutoNIBColor setAutoNIBColorWithPrimaryColor:primaryColor secondaryColor:secondaryColor tertiaryColor:tertiaryColor, [UIColor colorWithWhite:0.565 alpha:1.000], nil];
    UISS *sharedUISS = [UISS configureWithDefaultJSONFile];
    sharedUISS.statusWindowEnabled = NO;
    sharedUISS.autoReloadEnabled = YES;
    sharedUISS.autoReloadTimeInterval = 1;
}

@end

@implementation AppDelegate (Debug)

- (void)configDebug
{
#if DEBUG
    //using it for size debug
    //    [MMPlaceHolderConfig defaultConfig].lineColor = [UIColor blackColor];
    //    [MMPlaceHolderConfig defaultConfig].lineWidth = 1;
    //    [MMPlaceHolderConfig defaultConfig].arrowSize = 5;
    //    [MMPlaceHolderConfig defaultConfig].backColor = [UIColor clearColor];
    //    [MMPlaceHolderConfig defaultConfig].frameWidth = 0;
    //    [MMPlaceHolderConfig defaultConfig].visibleKindOfClasses = @[UIImageView.class];
    //using it for frame debug
    //    [MMPlaceHolderConfig defaultConfig].autoDisplay = YES;
    //    [MMPlaceHolderConfig defaultConfig].autoDisplaySystemView = YES;
    //    [MMPlaceHolderConfig defaultConfig].showArrow = NO;
    //    [MMPlaceHolderConfig defaultConfig].showText = NO;
    //using it to control global visible
    //    [MMPlaceHolderConfig defaultConfig].visible = YES;
    
    [[AFNetworkActivityLogger sharedLogger] setLevel:AFLoggerLevelDebug];
    [[AFNetworkActivityLogger sharedLogger] startLogging];
    [[AFNetworkingMeter sharedMeter] startMeter];
    
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIApplicationDidEnterBackgroundNotification object:nil] subscribeNext:^(NSNotification *notification) {
        XPLog(@"AFNetworkingMeter.data: %@", [AFNetworkingMeter sharedMeter].formattedReport);
    }];
#endif
}

- (void)configRemoteDebug
{
    LoggerSetViewerHost(NULL, (__bridge CFStringRef)@"192.168.0.239", (UInt32)5000);
    // configure the default logger
    LoggerSetOptions(NULL, kLoggerOption_BufferLogsUntilConnection |
                     kLoggerOption_UseSSL |
                     kLoggerOption_CaptureSystemConsole |
                     kLoggerOption_BrowseBonjour |
                     kLoggerOption_BrowseOnlyLocalDomain);
}

@end

@implementation AppDelegate (Reachability)

- (void)configReachability
{
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:2 * 1024 * 1024
                                                            diskCapacity:100 * 01024 * 1024
                                                                diskPath:nil];
    [NSURLCache setSharedURLCache:sharedCache];
    
    static BOOL tipShow = NO;
    static AFNetworkReachabilityStatus lastNetworkStatus = AFNetworkReachabilityStatusUnknown;
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if(lastNetworkStatus != status && tipShow) {
            switch(status) {
                case AFNetworkReachabilityStatusUnknown:
                case AFNetworkReachabilityStatusNotReachable: {
                    [SVProgressHUD showErrorWithStatus:@"网络连接丢失"];
                    break;
                }
                    
                case AFNetworkReachabilityStatusReachableViaWWAN: {
                    [SVProgressHUD showInfoWithStatus:@"切换至蜂窝"];
                    break;
                }
                    
                case AFNetworkReachabilityStatusReachableViaWiFi: {
                    [SVProgressHUD showInfoWithStatus:@"切换至Wi-Fi"];
                    break;
                }
                    
                default: {
                    break;
                }
            }
        }
        
        lastNetworkStatus = status;
        tipShow = YES;
    }];
}

@end

@implementation AppDelegate (UMeng)

- (void)configUMeng
{
    NSString *iPhone = @"5668ea02e0f55a78c300053e";
    [MobClick startWithAppkey:iPhone];
}

@end

@implementation AppDelegate (ShareSDK)

- (void)configShareSDK
{
    [ShareSDK registerApp:@"e5aa1b810028"
          activePlatforms:@[
                            @(SSDKPlatformTypeWechat),
                            @(SSDKPlatformTypeQQ)
                            ]
                 onImport:^(SSDKPlatformType platformType)
     {
         switch(platformType) {
             case SSDKPlatformTypeWechat: {
                 [ShareSDKConnector connectWeChat:[WXApi class]];
             }
                 break;
                 
             case SSDKPlatformTypeQQ: {
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
             }
                 break;
                 
             default: {
             }
                 break;
         }
     }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         switch(platformType) {
             case SSDKPlatformTypeWechat: {
                 [appInfo SSDKSetupWeChatByAppId:@"wxefd2413bd42eab55"
                                       appSecret:@"fabccac7df72e2185690c178798e35a1"];
             }
                 break;
                 
             case SSDKPlatformTypeQQ: {
                 [appInfo SSDKSetupQQByAppId:@"1104979671"
                                      appKey:@"GG1XANNqckx0TZZf"
                                    authType:SSDKAuthTypeBoth];
             }
                 break;
                 
             default: {
             }
                 break;
         }
     }];
}

@end

@implementation AppDelegate (Push)

- (void)configAPNSWithLaunchOptions:(NSDictionary *)launchOptions{
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIApplicationDidBecomeActiveNotification object:nil] subscribeNext:^(id x) {
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    }];
    [[[MMPReactiveNotification service]
      remoteRegistration]
     subscribeNext:^(NSData *tokenData) {
         NSLog(@"Receiving push token: %@", tokenData);
         // Send the push token to your server
         [APService registerDeviceToken:tokenData];
         if ([XPLoginStorage user].gender.length > 0) {
             [APService setAlias:[NSString stringWithFormat:@"%@",[XPLoginStorage user].accessToken] callbackSelector:nil object:nil];
         }
     }
     error:^(NSError *error) {
         NSLog(@"Push registration error: %@", error);
     }];
    @weakify(self);
    [[[MMPReactiveNotification service]
      remoteNotifications]
     subscribeNext:^(NSDictionary *pushData) {
         @strongify(self);
         NSLog(@"Receiving push: %@", pushData);
         if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateBackground) {
             [self receiveRemoteNotificationBackground:pushData];
         }else if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive){
             [self receiveRemoteNotificationActive:pushData];
         }else if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateInactive){
             [self receiveRemoteNotificationInActive:pushData];
         }
         [APService handleRemoteNotification:pushData];
     }];
    if(!launchOptions) {
        return;
    }
    [APService setupWithOption:launchOptions];
}

//APP在后台运行时
- (void)receiveRemoteNotificationBackground:(NSDictionary *)pushData{
    
}

//APP在前台运行，接受事件
- (void)receiveRemoteNotificationActive:(NSDictionary *)pushData{
    NSString * type = pushData[@"type"];
    if ([type isEqualToString:@"sys_message"]){
        if ([[UIViewController getCurrentVC] isKindOfClass:[XPMeViewController class]]){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadSystemMessageNotification" object:nil];
        }
    }else if ([type isEqualToString:@"user_message"]){
        if ([[UIViewController getCurrentVC] isKindOfClass:[XPMyPrivateLetterListViewController class]]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshPrivateListNotification" object:nil];
        }else if ([[UIViewController getCurrentVC] isKindOfClass:[XPMeViewController class]]){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadPrivateMessageNotification" object:nil];
        }
    }
}

//APP在后台运行，点击顶部的通知进入
- (void)receiveRemoteNotificationInActive:(NSDictionary *)pushData{
    NSString * type = pushData[@"type"];
    if ([type isEqualToString:@"sys_message"]){
        UIStoryboard * storBoard = [UIStoryboard storyboardWithName:@"SystemMessage" bundle:nil];
        XPSystemMessageViewController * systemMessageListViewController = [storBoard instantiateViewControllerWithIdentifier:@"XPSystemMessageViewController"];
        if ([[UIViewController getCurrentVC] isKindOfClass:[XPSystemMessageViewController class]]) {
            //发个通知刷新listVC
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshSystemMessageListNotification" object:nil];
        }else if ([[UIViewController getCurrentVC] isKindOfClass:[XPMeViewController class]]){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadSystemMessageNotification" object:nil];
        }
        else{
            //遍历导航栏查看是否有listVC
            for (UIViewController * vc in [UIViewController getCurrentVC].navigationController.viewControllers) {
                if ([vc isKindOfClass:[XPSystemMessageViewController class]]) {
                    [[UIViewController getCurrentVC].navigationController popToViewController:vc animated:YES];
                    return;
                }
            }
            [[UIViewController getCurrentVC].navigationController pushViewController:systemMessageListViewController animated:YES];
        }
    }else if ([type isEqualToString:@"user_message"]){
        UIStoryboard * storBoard = [UIStoryboard storyboardWithName:@"MyPrivateLetter" bundle:nil];
        XPMyPrivateLetterListViewController * privateLetterListViewController = [storBoard instantiateViewControllerWithIdentifier:@"XPMyPrivateLetterListViewController"];
        if ([[UIViewController getCurrentVC] isKindOfClass:[XPMyPrivateLetterListViewController class]]) {
            //发个通知刷新listVC
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshPrivateListNotification" object:nil];
        }else if ([[UIViewController getCurrentVC] isKindOfClass:[XPMeViewController class]]){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadPrivateMessageNotification" object:nil];
        }
        else{
            //遍历导航栏查看是否有listVC
            for (UIViewController * vc in [UIViewController getCurrentVC].navigationController.viewControllers) {
                if ([vc isKindOfClass:[XPMyPrivateLetterListViewController class]]) {
                    [[UIViewController getCurrentVC].navigationController popToViewController:vc animated:YES];
                    return;
                }
            }
            [[UIViewController getCurrentVC].navigationController pushViewController:privateLetterListViewController animated:YES];
        }
    }
}

@end
