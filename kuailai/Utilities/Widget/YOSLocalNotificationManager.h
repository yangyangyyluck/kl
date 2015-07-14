//
//  YOSLocalNotificationManager.h
//  kuailai
//
//  Created by yangyang on 15/7/14.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YOSLocalNotificationManager : NSObject

@property (nonatomic, strong) UILocalNotification *currentNotification;

+ (instancetype)sharedManager;

- (void)addNotificationWithDate:(NSDate *)date UserInfo:(NSDictionary *)userInfo;

- (void)dealWithCurrentNotification;

- (void)deleteNotificationWithUserInfo:(NSDictionary *)userInfo;

- (BOOL)isExistNotificationWithUserInfo:(NSDictionary *)userInfo;

- (UILocalNotification *)notificationWithUserInfo:(NSDictionary *)userInfo;

@end
