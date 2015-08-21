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
/** 更新用户信息 */
extern NSString * const YOSNotificationUpdateUserInfo;

/** 更新用户标签信息 */
extern NSString * const YOSNotificationUpdateTagInfo;

/** 拒绝或者同意参加活动请求 */
extern NSString * const YOSNotificationUpdateAuditInfo;

/** 拒绝或者同意添加好友 */
extern NSString * const YOSNotificationUpdateBuddyRequest;

extern NSString * const YOSNotificationLogin;

extern NSString * const YOSNotificationLogout;

/** 好友列表变更 */
extern NSString * const YOSNotificationUpdateBuddyList;

/** 接受到别人发来的消息 */
extern NSString * const YOSNotificationReceiveMessage;

/** 重置未读消息 */
extern NSString * const YOSNotificationResetUnReadMessage;

/** UITabBar 显示小红点 */
extern NSString * const YOSNotificationShowRedDot;

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

typedef NS_ENUM(NSUInteger, YOSActivityType) {
    YOSActivityTypeSWJL = 1,                                // 商务交流
    YOSActivityTypeHMCY,                                    // 黑马创业
    YOSActivityTypeCPFX,                                    // 产品分享
    YOSActivityTypeJSJL,                                    // 技术交流
    YOSActivityTypeSLXJ,                                    // 沙龙小聚
    YOSActivityTypeHWXX,                                    // 户外休闲
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

extern NSString * const YOSUMengAppKey;

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
