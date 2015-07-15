//
//  YOSLocalNotificationManager.m
//  kuailai
//
//  Created by yangyang on 15/7/14.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSLocalNotificationManager.h"
#import "YOSActivityDetailViewController.h"

#import "YOSWidget.h"

@implementation YOSLocalNotificationManager

+ (instancetype)sharedManager {
    static YOSLocalNotificationManager *mgr;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]){
            
            [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
            
        }
        
        mgr = [YOSLocalNotificationManager new];
    });
    
    return mgr;
}

- (void)addNotificationWithDate:(NSDate *)date UserInfo:(NSDictionary *)userInfo {
    
    NSString *title = userInfo[@"title"];
    NSString *start_time = userInfo[@"start_time"];
    
    // 先删除以前设置的本地通知
    [self deleteNotificationWithUserInfo:userInfo];
    
    UILocalNotification *notification=[[UILocalNotification alloc] init];
    
//    notification.fireDate = [[NSDate new] dateByAddingTimeInterval:10];
    notification.fireDate = date;
    notification.repeatInterval = 0;
    notification.timeZone = [NSTimeZone defaultTimeZone];
    notification.applicationIconBadgeNumber = 1;
    notification.soundName= UILocalNotificationDefaultSoundName;
    
    //去掉下面2行就不会弹出提示框
    //提示信息 弹出提示框
    notification.alertBody=[NSString stringWithFormat:@"温馨提示:您参加的活动 \"%@\" 将于%@开始,注意把握时间哦~", [YOSWidget dateStringWithTimeStamp:start_time Format:@"YYYY-MM-dd HH:mm"], title];
    //提示框按钮
//    notification.alertAction = @"打开";
    //是否显示额外的按钮，为no时alertAction消失
    //notification.hasAction = NO;
    
    notification.userInfo = userInfo;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];

}

- (void)dealWithCurrentNotification {
    if (!self.currentNotification) {
        return;
    }
    
    NSString *activityId = self.currentNotification.userInfo[@"activityId"];
    
    UITabBarController *tabBarVC = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    
    id navVC = tabBarVC.selectedViewController;
    
    if ([navVC isKindOfClass:[UINavigationController class]]) {
        YOSActivityDetailViewController *detailVC = [[YOSActivityDetailViewController alloc] initWithActivityId:activityId];
        
        [((UINavigationController *)navVC) pushViewController:detailVC animated:YES];
    } else {
        YOSLog(@"\r\n\r\ncan't push detailVC, because did not has navVC");
    }
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [[UIApplication sharedApplication] cancelLocalNotification:self.currentNotification];
    self.currentNotification = nil;
}

- (void)deleteNotificationWithUserInfo:(NSDictionary *)userInfo {

    UIApplication *app = [UIApplication sharedApplication];

    NSArray *localArray = [app scheduledLocalNotifications];

    if (!localArray.count) { return; }
        
    for (UILocalNotification *noti in localArray) {
        NSDictionary *dict = noti.userInfo;
        if (!dict) { continue; }
        
        NSString *activityId = [dict objectForKey:@"activityId"];
        if ([activityId isEqualToString:userInfo[@"activityId"]]) {
            [app cancelLocalNotification:noti];
            break;
        }
        
    }
    
}

- (BOOL)isExistNotificationWithUserInfo:(NSDictionary *)userInfo {
    UIApplication *app = [UIApplication sharedApplication];
    
    NSArray *localArray = [app scheduledLocalNotifications];
    
    if (!localArray.count) { return NO; }
    
    for (UILocalNotification *noti in localArray) {
        NSDictionary *dict = noti.userInfo;
        if (!dict) { continue; }
        
        NSString *activityId = [dict objectForKey:@"activityId"];
        if ([activityId isEqualToString:userInfo[@"activityId"]]) {
            return YES;
        }
        
    }
    
    return NO;
}

- (UILocalNotification *)notificationWithUserInfo:(NSDictionary *)userInfo {
    UIApplication *app = [UIApplication sharedApplication];
    
    NSArray *localArray = [app scheduledLocalNotifications];
    
    if (!localArray.count) { return nil; }
    
    for (UILocalNotification *noti in localArray) {
        NSDictionary *dict = noti.userInfo;
        if (!dict) { continue; }
        
        NSString *activityId = [dict objectForKey:@"activityId"];
        if ([activityId isEqualToString:userInfo[@"activityId"]]) {
            return noti;
        }
        
    }
    
    return nil;
}

@end
