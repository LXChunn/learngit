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
#import <Bugtags/Bugtags.h>
#import <MMPlaceHolder/MMPlaceHolder.h>
#import <NSLogger/NSLogger.h>

#import <OCUDL/OCUDL.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import <UISS/UISS.h>
#import <UMengAnalytics-NO-IDFA/MobClick.h>
#import <XPKit/XPKit.h>

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
    [NSBundle setLanguage:@"zh-Hans"];
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
    
    [[AFNetworkActivityLogger sharedLogger] setLevel:AFLoggerLevelError];
    [[AFNetworkActivityLogger sharedLogger] startLogging];
    [[AFNetworkingMeter sharedMeter] startMeter];
    
    [Bugtags startWithAppKey:@"2b8c82f078d3638230cf336cf435669e" invocationEvent:BTGInvocationEventBubble];
    
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
