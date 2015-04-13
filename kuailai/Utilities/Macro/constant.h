//
//  constant.h
//  kuailai
//
//  Created by yangyang on 15/4/8.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const YOSURLBase;

typedef NS_ENUM(NSUInteger, BusinessRequestStatus) {
    BusinessRequestStatusSuccess                = 200,      // 请求成功
    BusinessRequestStatusBadRequest             = 400,      // 坏请求
    BusinessRequestStatusNoAuthorization        = 401,      // 没有权限
    BusinessRequestStatusFailure                = 10000,    // 请求失败
    BusinessRequestStatusDefault                = 99999,    // 所有未处理的状态
};


/**
 *  UserDefault keys
 */
extern NSString * const YOSUserDefaultKeyCurrentMobileNumber;

extern NSString * const YOSUserDefaultKeySignInMobileNumber;

extern NSString * const YOSUserDefaultKeySignInID;