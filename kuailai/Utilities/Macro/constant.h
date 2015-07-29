//
//  constant.h
//  kuailai
//
//  Created by yangyang on 15/4/8.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+YOSAdditions.h"

extern NSString * const YOSURLBase;

// notification
extern NSString * const YOSNotificationUpdateUserInfo;

extern NSString * const YOSNotificationUpdateTagInfo;

extern NSString * const YOSNotificationUpdateAuditInfo;

typedef NS_ENUM(NSUInteger, BusinessRequestStatus) {
    BusinessRequestStatusSuccess                = 200,      // 请求成功
    BusinessRequestStatusBadRequest             = 400,      // 坏请求
    BusinessRequestStatusNoAuthorization        = 401,      // 没有权限
    BusinessRequestStatusFailure                = 10000,    // 请求失败
    BusinessRequestStatusDefault                = 99999,    // 所有未处理的状态
};

typedef NS_ENUM(NSUInteger, YOSCityType) {
    YOSCityTypeBJ = 1,                                      // 北京
    YOSCityTypeSH,                                          // 上海
    YOSCityTypeGZ,                                          // 广州
    YOSCityTypeSZ,                                          // 深圳
    YOSCityTypeHEB,                                         // 哈尔滨
    YOSCityTypeCD,                                          // 成都
    YOSCityTypeWLMQ,                                        // 乌鲁木齐
    YOSCityTypeJN,                                          // 济南
};

// 1姓名 2手机号码 3公司 4职位 5工作年限 6学历
typedef NS_ENUM(NSUInteger, YOSAuditType) {
    YOSAuditTypeName = 1,
    YOSAuditTypeMobile,
    YOSAuditTypeCompany,
    YOSAuditTypeJobTitle,
    YOSAuditTypeWorkYears,
    YOSAuditTypeUniversity,
};

typedef NS_ENUM(NSUInteger, YOSRefreshType) {
    YOSRefreshTypeHeader,
    YOSRefreshTypeFooter,
};

typedef NS_ENUM(NSUInteger, YOSFriendType) {
    YOSFriendTypeNotAdd = 0,
    YOSFriendTypeWaitForVerify,
    YOSFriendTypeBoth,
};

typedef void (^voidBlock)(void);
typedef void (^voidBlock_id)(id);

typedef BOOL (^boolBlock)(void);

/**
 *  sign keys
 */
extern NSString * const YOSEncodeSignUser;

extern NSString * const YOSEncodeSignKey;

extern NSString * const YOSAESKey;

extern NSString * const YOSEaseMobAppKey;

extern NSString * const YOSEaseMobCertName;

/**
 *  UserDefault keys
 */

///** 注册页：当前注册的手机号 */
//extern NSString * const YOSUserDefaultKeyCurrentRegisterMobileNumber;
//
///** 注册页：当前注册手机号的ID */
//extern NSString * const YOSUserDefaultKeyCurrentRegisterID;
//
///** 当前登录用户的手机号 */
//extern NSString * const YOSUserDefaultKeyCurrentLoginMobileNumber;
//
///** 当前登录用户的手机号 */
//extern NSString * const YOSUserDefaultKeyCurrentLoginID;
//
///** 当前登录用户的用户信息 */
//extern NSString * const YOSUserDefaultKeyCurrentUserInfoDictionary;

/**
 *  API权限验证用的签名
 *
 *  @param dict
 *
 *  @return string
 */
NSString *yos_encodeWithDictionary(NSDictionary *dict);

NSString *yos_getSex(NSString *sexId);
NSString *yos_getSexId(NSString *sex);

NSString *yos_getEducation(NSString *educationId);
NSString *yos_getEducationId(NSString *education);

NSString *yos_getJobYears(NSString *jobYearsId);
NSString *yos_getJobYearsId(NSString *jobYears);
