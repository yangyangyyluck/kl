//
//  YOSEaseMobManager.h
//  kuailai
//
//  Created by yangyang on 15/7/16.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EaseMob.h"

@interface YOSEaseMobManager : NSObject

@property (nonatomic, strong, readonly) NSArray *buddyList;

@property (nonatomic, strong, readonly) NSArray *blockedList;

+ (instancetype)sharedManager;

- (BOOL)isHxLogin;

- (void)registerWithApplication:(UIApplication *)application launchOptions:(NSDictionary *)launchOptions;

/** 注册 */
- (BOOL)registerNewAccount;

/** 登录[异步] */
- (void)loginEaseMobAsync;

/** 登录[同步] */
- (BOOL)loginEaseMobSync;

/** 退出 */
- (void)logoffWithUnbindDeviceToken:(BOOL)status;

/** 同步退出 */
- (BOOL)logoffSyncWithUnbindDeviceToken:(BOOL)status;

- (BOOL)isFriendWithUser:(NSString *)user;

/*------------ 好友关系 ------------*/

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

/** 获取当前最新的好友列表 */
- (NSArray *)getNewestBuddyList;

/*------------ 好友关系 ------------*/


/*------------ 创建/销毁会话 ------------*/

- (__weak EMConversation *)conversationForChatter:(NSString *)username;

- (void)removeConversationByChatter:(NSString *)username;

- (void)removeAllConversations;

/*------------ 创建/销毁会话 ------------*/

/*------------ 发送消息 ------------*/

- (void)sendMessageToUser:(NSString *)username message:(NSString *)message;

/*------------ 发送消息 ------------*/

@end
