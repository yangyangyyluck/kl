//
//  GVUserDefaults+YOSProperties.h
//  kuailai
//
//  Created by yangyang on 15/6/24.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "GVUserDefaults.h"

/*
    注册页：当前注册的手机号
extern NSString * const YOSUserDefaultKeyCurrentRegisterMobileNumber;

    注册页：当前注册手机号的ID
extern NSString * const YOSUserDefaultKeyCurrentRegisterID;

    当前登录用户的手机号
extern NSString * const YOSUserDefaultKeyCurrentLoginMobileNumber;

    当前登录用户的手机号
extern NSString * const YOSUserDefaultKeyCurrentLoginID;

    当前登录用户的用户信息
extern NSString * const YOSUserDefaultKeyCurrentUserInfoDictionary;
*/

@interface GVUserDefaults (YOSProperties)

@property (nonatomic, weak) NSString *currentRegisterMobileNumber;

@property (nonatomic, weak) NSString *currentRegisterID;

/** 退出时清空 */
@property (nonatomic, weak) NSString *currentLoginMobileNumber;

/** 退出时清空 */
@property (nonatomic, weak) NSString *currentLoginID;

/** 退出时清空 */
@property (nonatomic, weak) NSDictionary *currentUserInfoDictionary;

/** 退出时清空 */
@property (nonatomic, weak) NSDictionary *currentTagDictionary;

- (void)logout;

@end
