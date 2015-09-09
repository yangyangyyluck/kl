//
//  AppDelegate.m
//  kuailai
//
//  Created by yangyang on 15/4/3.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "AppDelegate.h"
#import "YOSIQContentView.h"
#import "YOSGuideViewController.h"

#import "YTKNetworkConfig.h"
#import "IQKeyboardManager.h"
#import "YOSLocalNotificationManager.h"
#import "EaseMob.h"
#import "YOSWidget.h"
#import "YOSEaseMobManager.h"
#import "MobClick.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialSinaSSOHandler.h"
#import "UMSocialSinaHandler.h"
#import "UMSocialQQHandler.h"
#import "GVUserDefaults+YOSProperties.h"
#import <FIR/FIR.h>

@interface AppDelegate () <EMChatManagerDelegate>

@end

@implementation AppDelegate

#pragma mark - application life cycles

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    UILocalNotification *localNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    
    if (localNotification) {
        [YOSLocalNotificationManager sharedManager].currentNotification = localNotification;
    }
    
    [[IQKeyboardManager sharedManager] considerToolbarPreviousNextInViewClass:[YOSIQContentView class]];
    
    [self configrueThiredLibrariesWith:application launchOptions:launchOptions];
    
    self.window.backgroundColor = [UIColor whiteColor];
    
    application.applicationIconBadgeNumber = 0;
    application.statusBarStyle = UIStatusBarStyleLightContent;
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    
    [[EaseMob sharedInstance] applicationDidEnterBackground:application];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    application.applicationIconBadgeNumber = 0;
    [[EaseMob sharedInstance] applicationWillEnterForeground:application];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    [[EaseMob sharedInstance] applicationWillTerminate:application];
}

#pragma mark - locate notification

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    NSLog(@"%s", __func__);
    [YOSLocalNotificationManager sharedManager].currentNotification = notification;
    
    if (application.applicationState != UIApplicationStateInactive) {
        [[YOSLocalNotificationManager sharedManager] dealWithCurrentNotification];
    }
    
}

#pragma mark - remote notification

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {

}

// 将得到的deviceToken传给SDK
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    [[EaseMob sharedInstance] application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

// 注册deviceToken失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    [[EaseMob sharedInstance] application:application didFailToRegisterForRemoteNotificationsWithError:error];
    NSLog(@"\r\n\r\n\r\nremote notification error ------ %@\r\n\r\n\r\n",error);
}

#pragma mark - open url

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return  [UMSocialSnsService handleOpenURL:url];
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return  [UMSocialSnsService handleOpenURL:url];
}

#pragma mark - private methods 

- (void)configrueThiredLibrariesWith:(UIApplication *)application launchOptions:(NSDictionary *)launchOptions {
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    // ytk network
    {
        [YTKNetworkConfig sharedInstance].baseUrl = YOSURLBase;
    }
    
    // 环信
    {
        [[YOSEaseMobManager sharedManager] registerWithApplication:application launchOptions:launchOptions];
    }
    
    // UMeng
    {
        [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToQQ,UMShareToQzone,UMShareToWechatSession,UMShareToWechatTimeline]];
        
        [MobClick startWithAppkey:YOSUMengAppKey reportPolicy:BATCH   channelId:@"Web"];
        [UMSocialData setAppKey:YOSUMengAppKey];
        
        // 微信
        [UMSocialWechatHandler setWXAppId:YOSWeixinAppKey appSecret:YOSWeixinAppSecret url:@"http://www.umeng.com/social"];
        
        // 微博
        [UMSocialSinaSSOHandler openNewSinaSSOWithRedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
        [UMSocialSinaHandler openSSOWithRedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
        
        // qq
        [UMSocialQQHandler setQQWithAppId:YOSQQAppID appKey:YOSQQAppKey url:@"http://www.umeng.com/social"];
    }
    
    // APNs推送
    {
        //iOS8 注册APNS
        if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
            [application registerForRemoteNotifications];
            UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge |
            UIUserNotificationTypeSound |
            UIUserNotificationTypeAlert;
            UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
            [application registerUserNotificationSettings:settings];
        }
        else{
            UIRemoteNotificationType notificationTypes = UIRemoteNotificationTypeBadge |
            UIRemoteNotificationTypeSound |
            UIRemoteNotificationTypeAlert;
            [[UIApplication sharedApplication] registerForRemoteNotificationTypes:notificationTypes];
        }
    }
    
    // fir.im bughd
    {
        [FIR handleCrashWithKey:YOSFirBugHDKey];
    }
}

@end
