//
//  YOSEaseMobManager.m
//  kuailai
//
//  Created by yangyang on 15/7/16.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSEaseMobManager.h"
#import "EaseMob.h"
#import "YOSWidget.h"
#import "YOSUserInfoModel.h"

@interface YOSEaseMobManager () <EMChatManagerDelegate>

@property (nonatomic, strong) EaseMob *easeMob;

@property (nonatomic, strong) YOSUserInfoModel *userInfoModel;

@property (nonatomic, strong, readwrite) NSArray *buddyList;

@property (nonatomic, strong, readwrite) NSArray *blockedList;

/** 该方法比较特殊，只有在您之前获取过好友列表的情况下才会有值，且不能保证最新。 */
@property (nonatomic, strong) NSArray *buddyListInMemory;

@property (nonatomic, strong) NSArray *blockedListInMemory;

@end

@implementation YOSEaseMobManager

#pragma mark - public methods

+ (instancetype)sharedManager {
    static YOSEaseMobManager *mgr;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mgr = [YOSEaseMobManager new];
    });
    
    return mgr;
}

- (BOOL)registerNewAccount {
    
//    NSString *user = self.userInfoModel.hx_user;
    NSString *user = self.userInfoModel.username;
    NSString *pass = self.userInfoModel.hx_pwd;
    
    if (user.length == 0 || pass.length == 0) {
#warning TODO login out
        // kuailai login out
        NSLog(@"here need kuailai login out.");
        return NO;
    }
    
    EMError *error = nil;
    BOOL status = [self.easeMob.chatManager registerNewAccount:user password:pass error:&error];
    
    if (error) {
        NSLog(@"\r\n\r\n register error : %@", error);
    } else {
        NSLog(@"register success.");
    }
    
    return status;
}

- (void)loginEaseMob {
    
    BOOL isAutoLogin = [self.easeMob.chatManager isAutoLoginEnabled];
    if (isAutoLogin) {
        return;
    }
    
//    NSString *user = self.userInfoModel.hx_user;
    NSString *user = self.userInfoModel.username;
//    NSString *pass = self.userInfoModel.hx_pwd;
    NSString *pass = @"123123";
    
    if (user.length == 0 || pass.length == 0) {
#warning TODO login out
        // kuailai login out
        NSLog(@"here need kuailai login out.");
        return;
    }
    
    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:user password:pass completion:^(NSDictionary *loginInfo, EMError *error) {
        
        if (!error && loginInfo) {
            YOSLog(@"login success");
            // 设置自动登录
            [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
        } else {
            YOSLog(@"login failure");
#warning TODO login out
            // kuailai login out
            NSLog(@"here need kuailai login out.");
        }
        
    } onQueue:nil];
}

/**
 *  退出登录分两种类型：主动退出登录和被动退出登录。
 *
    主动退出登录：调用SDK的退出接口；
 
    被动退出登录： 1、 正在登陆的账号在另一台设备上登陆； 2、 正在登陆的账号被从服务器端删除。
 
    退出 提供了三种方法。
 
    logoffWithUnbindDeviceToken：是否解除device token的绑定，在被动退出时传NO，在主动退出时传YES.
 *
 *  @param status
 */
- (void)logoffWithUnbindDeviceToken:(BOOL)status {
    [self.easeMob.chatManager asyncLogoffWithUnbindDeviceToken:status completion:^(NSDictionary *info, EMError *error) {
        if (!error) {
            NSLog(@"退出成功");
        } else {
            NSLog(@"退出失败 error : %@ info : %@", error, info);
        }
    } onQueue:nil];
}

- (BOOL)addBuddy:(NSString *)userName message:(NSString *)message {
    EMError *error = nil;
    BOOL status = [[EaseMob sharedInstance].chatManager addBuddy:@"18600950783" message:@"我想加您为好友" error:&error];
    
    if (error) {
        YOSLog(@"\r\n\r\n添加好友出错: %@", error);
    }
    
    return status;
}

/** 获取好友[异步] */
- (void)getBuddyListAsync {
    [[EaseMob sharedInstance].chatManager asyncFetchBuddyListWithCompletion:^(NSArray *buddyList, EMError *error) {
        if (!error) {
            YOSLog(@"获取好友成功 -- %@",buddyList);
        } else {
            YOSLog(@"获取好友出错 : %@", error);
        }
        
        self.buddyList = buddyList;
        
    } onQueue:nil];
}

/** 获取好友[同步] */
- (void)getBuddyListSync {
    EMError *error = nil;
    NSArray *buddyList = [[EaseMob sharedInstance].chatManager fetchBuddyListWithError:&error];
    
    self.buddyList = buddyList;
    
    if (!error) {
        YOSLog(@"获取成功 -- %@",buddyList);
    } else {
        YOSLog(@"获取好友出错 : %@", error);
    }
    
    self.buddyList = buddyList;
}

- (void)getBlockedListSync {
    EMError *error = nil;
    NSArray *blockedList = [[EaseMob sharedInstance].chatManager fetchBlockedList:&error];
    
    self.blockedList = blockedList;
    
    if (!error) {
        YOSLog(@"获取黑名单成功 -- %@",blockedList);
    } else {
        YOSLog(@"获取黑名单失败 -- %@", error);
    }
}

- (void)getBlockedListAsync {
    
    [[EaseMob sharedInstance].chatManager asyncFetchBlockedListWithCompletion:^(NSArray *blockedList, EMError *error) {
        if (!error) {
            NSLog(@"获取黑名单成功 -- %@",blockedList);
            self.blockedList = blockedList;
        } else {
            YOSLog(@"获取黑名单失败 -- %@", error);
        }
    } onQueue:nil];
    
}

- (BOOL)acceptBuddy:(NSString *)username {
    EMError *error = nil;
    BOOL isSuccess = [[EaseMob sharedInstance].chatManager acceptBuddyRequest:username error:&error];
    
    if (isSuccess && !error) {
        NSLog(@"发送同意成功");
    } else {
        YOSLog(@"接受好友请求失败 : %@", error);
    }
    
    return isSuccess;
}

- (BOOL)rejuctBuddy:(NSString *)username reason:(NSString *)reason {
    EMError *error = nil;
    BOOL isSuccess = [[EaseMob sharedInstance].chatManager rejectBuddyRequest:username reason:reason error:&error];
    
    if (isSuccess && !error) {
        NSLog(@"发送拒绝好友成功");
    } else {
        YOSLog(@"拒绝好友请求失败 : %@", error);
    }
    
    return isSuccess;
}

- (BOOL)removeBuddy:(NSString *)username {
    EMError *error = nil;
    // 删除好友
    BOOL isSuccess = [[EaseMob sharedInstance].chatManager removeBuddy:username removeFromRemote:YES error:&error];
    
    if (isSuccess && !error) {
        YOSLog(@"删除好友成功");
    } else {
        YOSLog(@"删除好友失败 : %@", error);
    }
    
    return isSuccess;
}

- (BOOL)addBuddyToBlock:(NSString *)username {
    EMError *error = [[EaseMob sharedInstance].chatManager blockBuddy:username relationship:eRelationshipBoth];
    
    if (!error) {
        YOSLog(@"添加黑名单成功");
    } else {
        YOSLog(@"添加黑名单失败 : %@", error);
    }
    
    return (BOOL)(!error);
}

- (BOOL)removeBuddyToBlock:(NSString *)username {
    // 将6001移除黑名单
    EMError *error = [[EaseMob sharedInstance].chatManager unblockBuddy:username];
    if (!error) {
        YOSLog(@"移除黑名单成功");
    } else {
        YOSLog(@"移除黑名单失败 : %@", error);
    }
    
    return (BOOL)(!error);
}

#pragma mark - getter & setter

- (EaseMob *)easeMob {
    return [EaseMob sharedInstance];
}

- (YOSUserInfoModel *)userInfoModel {
    return [YOSWidget getCurrentUserInfoModel];
}

/** 该方法比较特殊，只有在您之前获取过好友列表的情况下才会有值，且不能保证最新。 */
- (NSArray *)buddyListInMemeory {
    return [self.easeMob.chatManager buddyList];
}

- (NSArray *)blockedListInMemory {
    return [self.easeMob.chatManager blockedList];
}

#pragma mark - EMChatManagerDelegate

- (void)willAutoLoginWithInfo:(NSDictionary *)loginInfo error:(EMError *)error {
    NSLog(@"%s", __func__);
    YOSLog(@"用户将要进行自动登录操作的回调");
}

- (void)didAutoLoginWithInfo:(NSDictionary *)loginInfo error:(EMError *)error {
    NSLog(@"%s", __func__);
    YOSLog(@"用户自动登录完成后的回调");
}

- (void)didLoginWithInfo:(NSDictionary *)loginInfo error:(EMError *)error {
    NSLog(@"%s", __func__);
    YOSLog(@"登陆成功。");
}

- (void)didReceiveBuddyRequest:(NSString *)username
                       message:(NSString *)message {
    [YOSWidget alertMessage:username title:message];
    
    [self acceptBuddy:username];
}

/*!
 @method
 @brief 将要发起自动重连操作时发送该回调
 @discussion
 @result
 */
- (void)willAutoReconnect {
    NSLog(@"%s", __func__);
    YOSLog(@"将要发起自动重连操作时发送该回调");
}

/*!
 @method
 @brief 自动重连操作完成后的回调（成功的话，error为nil，失败的话，查看error的错误信息）
 @discussion
 @result
 */
- (void)didAutoReconnectFinishedWithError:(NSError *)error {
    NSLog(@"%s", __func__);
    YOSLog(@"自动重连操作完成后的回调（成功的话，error为nil，失败的话，查看error的错误信息）");
}

/*!
 @method
 @brief 将好友加到黑名单完成后的回调
 @discussion
 @param buddy    加入黑名单的好友
 @param pError   错误信息
 */
- (void)didBlockBuddy:(EMBuddy *)buddy error:(EMError *)pError {
    YOSLog(@"添加黑名单完成的回调");
}

/*!
 @method
 @brief 将好友移出黑名单完成后的回调
 @discussion
 @param buddy    移出黑名单的好友
 @param pError   错误信息
 */
- (void)didUnblockBuddy:(EMBuddy *)buddy error:(EMError *)pError {
    YOSLog(@"移除黑名单完成的回调");
}

#pragma mark - private methods

- (void)registerWithApplication:(UIApplication *)application launchOptions:(NSDictionary *)launchOptions {
    
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    [[EaseMob sharedInstance] registerSDKWithAppKey:YOSEaseMobAppKey apnsCertName:YOSEaseMobCertName];
    [[EaseMob sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
