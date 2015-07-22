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

@end

@implementation YOSEaseMobManager

+ (instancetype)sharedManager {
    static YOSEaseMobManager *mgr;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mgr = [YOSEaseMobManager new];
    });
    
    return mgr;
}

- (void)registerWithApplication:(UIApplication *)application launchOptions:(NSDictionary *)launchOptions {
    
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    [[EaseMob sharedInstance] registerSDKWithAppKey:YOSEaseMobAppKey apnsCertName:YOSEaseMobCertName];
    [[EaseMob sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
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

#pragma mark - getter & setter

- (EaseMob *)easeMob {
    return [EaseMob sharedInstance];
}

- (YOSUserInfoModel *)userInfoModel {
    return [YOSWidget getCurrentUserInfoModel];
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

@end
