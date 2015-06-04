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

typedef void (^voidBlock)(void);
typedef void (^voidBlock1)(id);

typedef BOOL (^boolBlock)(void);

/**
 *  sign keys
 */
extern NSString * const YOSEncodeSignUser;

extern NSString * const YOSEncodeSignKey;

/**
 *  UserDefault keys
 */
extern NSString * const YOSUserDefaultKeyCurrentMobileNumber;

extern NSString * const YOSUserDefaultKeySignInMobileNumber;

extern NSString * const YOSUserDefaultKeySignInID;

NSString* yos_encodeWithDictionary(NSDictionary* dict);
