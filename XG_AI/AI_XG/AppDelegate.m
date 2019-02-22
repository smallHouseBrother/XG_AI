//
//  AppDelegate.m
//  AI_XG
//
//  Created by 小马哥 on 2018/1/24.
//  Copyright © 2018年 小马哥. All rights reserved.
//

#import "AppDelegate.h"
#import <UMCommon/UMCommon.h>
#import <UMAnalytics/MobClick.h>
#import <UShareUI/UShareUI.h>
#import <AVOSCloud/AVOSCloud.h>
#import <Bugly/Bugly.h>
#import "RootViewController.h"
#import "AuthViewController.h"

@interface AppDelegate ()
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self setAVOSCloud];
    [self setUMSDKs];
    [self setBugly];
    [GADMobileAds configureWithApplicationID:AdMobId];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    RootViewController * rootVC = [[RootViewController alloc] init];
    XGNavigationController * rootNavi = [[XGNavigationController alloc] initWithRootViewController:rootVC];
    self.window.rootViewController = rootNavi;
    [self.window makeKeyAndVisible];

    [self requestFingerAuth];
    
    return YES;
}

- (void)requestFingerAuth
{
    if (!isLocked) return;
    
    AuthViewController * auth = [[AuthViewController alloc] init];
    
    UIViewController * present = [self topViewControllerWithRootViewController:self.window.rootViewController];
    
    if ([present isKindOfClass:[AuthViewController class]]) return;
    
    [present presentViewController:auth animated:YES completion:nil];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [self requestFingerAuth];
}

#pragma mark - AVOSCloud
- (void)setAVOSCloud
{
    [AVOSCloud setApplicationId:@"SHQkfpEjBQSNB5GuP7C2tHhT-gzGzoHsz" clientKey:@"HQu4O3V8xg59CWIudOy2OEQ3"];
}

#pragma mark - 友盟分享、统计
- (void)setUMSDKs {
    [UMConfigure initWithAppkey:UM_AppKey channel:@"App Store"];
    
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:WeChat_AppKey appSecret:WeChat_Secret redirectURL:RedirectURL];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:QQ_AppKey appSecret:nil redirectURL:RedirectURL];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:Sina_AppKey  appSecret:Sina_Secret redirectURL:RedirectURL];
    
    [MobClick setScenarioType:E_UM_NORMAL];
}

#pragma mark - bugly
- (void)setBugly {
    [Bugly startWithAppId:Bugly_Key];
    BuglyConfig *config = [[BuglyConfig alloc] init];
    config.debugMode = IsDebug;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    return [[UMSocialManager defaultManager] handleOpenURL:url options:options];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [[UMSocialManager defaultManager] handleOpenURL:url];
}

- (UIViewController *)topViewControllerWithRootViewController:(UIViewController *)rootViewController
{
    if ([rootViewController isKindOfClass:[UITabBarController class]])
    {
        UITabBarController* tabBarController = (UITabBarController*)rootViewController;
        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
    }
    else if (rootViewController.presentedViewController)
    {
        UIViewController * presentedViewController = rootViewController.presentedViewController;
        return [self topViewControllerWithRootViewController:presentedViewController];
    }
    else if ([rootViewController isKindOfClass:[UINavigationController class]])
    {
        UINavigationController * navigationController = (UINavigationController *)rootViewController;
        return [self topViewControllerWithRootViewController:navigationController.visibleViewController];
    }
    else
    {
        return rootViewController;
    }
}

@end
