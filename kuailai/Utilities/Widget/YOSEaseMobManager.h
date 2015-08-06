//
//  YOSEaseMobManager.h
//  kuailai
//
//  Created by yangyang on 15/7/16.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YOSEaseMobManager : NSObject

@property (nonatomic, strong, readonly) NSArray *buddyList;

@property (nonatomic, strong, readonly) NSArray *blockedList;

+ (instancetype)sharedManager;

- (void)registerWithApplication:(UIApplication *)application launchOptions:(NSDictionary *)launchOptions;

/** 注册 */
- (BOOL)registerNewAccount;

/** 登录 */
- (void)loginEaseMob;

/** 退出 */
- (void)logoffWithUnbindDeviceToken:(BOOL)status;

/** 添加好友 */
- (BOOL)addBuddy:(NSString *)userName message:(NSString *)message;

/** 获取好友[异步] */
- (void)getBuddyListAsync;

/** 获取好友[同步] */
- (NSArray *)getBuddyListSync;

/** 接受好友 */
- (BOOL)acceptBuddy:(NSString *)username;

/** 拒绝好友 */
- (BOOL)rejuctBuddy:(NSString *)username reason:(NSString *)reason;

@end
