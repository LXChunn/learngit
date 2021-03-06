//
//  AppDelegate.m
//  XPApp
//
//  Created by huangxinping on 15/10/31.
//  Copyright © 2015年 ShareMerge. All rights reserved.
//

#import "AppDelegate+extension.h"
#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    @IgnoreTestCase
    [self configSettingBundle];
    [self configTheme];
    [self configDebug];
    [self configReachability];
    [self configUMeng];
    [self configShareSDK];
    [self configAPNSWithLaunchOptions:launchOptions];
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    return YES;
}
void uncaughtExceptionHandler(NSException *exception) {
    NSLog(@"CRASH: %@", exception);
    NSLog(@"Stack Trmace: %@", [exception callStackSymbols]);
    // Internal error reporting
}
- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application
{
}

@end
