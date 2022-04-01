//
//  KYKJAppDelegate.m
//  KykjHospitalCustomImSDK
//
//  Created by liangyujuan on 02/23/2022.
//  Copyright (c) 2022 liangyujuan. All rights reserved.
//

#import "KYKJAppDelegate.h"
#import "HOIMHelper.h"
#import "TYMemberSearchViewController.h"
//#import "BaseNavigationController.h"

@implementation KYKJAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    [self initThirdPartWithOptions:launchOptions];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UINavigationBar appearance] setBackgroundColor:[UIColor whiteColor]];
    _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _window.backgroundColor = [UIColor whiteColor];
    
    TYMemberSearchViewController *vc = [[TYMemberSearchViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];

    nav.title = @"健康问诊";
    vc.hidesBottomBarWhenPushed = YES;
    self.window.rootViewController = nav;
    
    [self initThirdPartWithOptions:launchOptions];
    
    [self.window makeKeyAndVisible];
    
    
    return YES;
}

- (void)initThirdPartWithOptions:(NSDictionary *)launchOptions{
// 初始化融云的SDK
[[HOIMHelper shareInstance] initWithAppKey:@"pvxdm17jpwysr"];
[[HOIMHelper shareInstance] rongYunConfig:launchOptions timSDKAppId:1400645504 withDelegate:self];

}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

//按Home键使App进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application{
    [application setApplicationIconBadgeNumber:0];
    [application beginBackgroundTaskWithExpirationHandler:^{
            
    }];
//    [application cancelAllLocalNotifications];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [application setApplicationIconBadgeNumber:0];
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [application setApplicationIconBadgeNumber:0];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [application setApplicationIconBadgeNumber:0];
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
