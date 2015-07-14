//
//  AppDelegate.m
//  kuailai
//
//  Created by yangyang on 15/4/3.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "AppDelegate.h"
#import "YTKNetworkConfig.h"
#import "IQKeyboardManager.h"
#import "YOSInputView.h"
#import "YOSTextField.h"
#import "YOSIQContentView.h"
#import "YOSLocalNotificationManager.h"

@interface AppDelegate ()

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
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - locate notification

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    NSLog(@"%s", __func__);
    [YOSLocalNotificationManager sharedManager].currentNotification = notification;
    
    if (application.applicationState != UIApplicationStateInactive) {
        [[YOSLocalNotificationManager sharedManager] dealWithCurrentNotification];
    }
    
}

#pragma mark - private methods 

- (void)configrueThiredLibrariesWith:(UIApplication *)application launchOptions:(NSDictionary *)launchOptions {
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    [YTKNetworkConfig sharedInstance].baseUrl = YOSURLBase;
}

@end
