//
//  constant.m
//  kuailai
//
//  Created by yangyang on 15/4/8.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "constant.h"

/**
 *  sign keys
 */
NSString * const YOSEncodeSignUser = @"kuailai";

NSString * const YOSEncodeSignKey = @"ao$i8nJ*S2AL";

NSString * const YOSAESKey = @"ooookuaiLai7oooo";

NSString * const YOSEaseMobAppKey = @"kuailai#kuailai";

#ifdef DEBUG
NSString * const YOSEaseMobCertName = @"dev";
#else
NSString * const YOSEaseMobCertName = @"pro";
#endif

NSString * const YOSUMengAppKey = @"55d72cebe0f55a7a86002fd7";

NSString * const YOSWeiboAppKey = @"2923223513";

NSString * const YOSWeiboAppSecret = @"67266bd6d5fc2084a507076224fbfb1c";

NSString * const YOSWeixinAppKey = @"wxe56c794b911ad1b4";

NSString * const YOSWeixinAppSecret = @"23d4012811f219c1f329622cc9abb396";

NSString * const YOSQQAppID = @"1104833626";

NSString * const YOSQQAppKey = @"V6Fv7zI63zQdHLnr";

NSString * const YOSTestInAppKey = @"0cf190ce386957f568933d98310545e5";

#ifdef TARGET_IPHONE_SIMULATOR
NSString * const YOSEnvironment = @"iOS Simulator";
#else
NSString * const YOSEnvironment = @"app store";
#endif

NSString * const YOSBugHDAppKey = @"92f49871d253ec675494ed2a6d8a037f";

//#ifdef DEBUG
//NSString * const YOSURLBase = @"http://kuailai.zhangdd.cn/app/";
//
//NSString * const YOSURLRoot = @"http://kuailai.zhangdd.cn/";
//#else
NSString * const YOSURLBase = @"http://www.comebar.cn/app/";

NSString * const YOSURLRoot = @"http://www.comebar.cn/";
//#endif

NSString * const YOSNotificationUpdateUserInfo = @"YOSNotificationUpdateUserInfo";

NSString * const YOSNotificationUpdateTagInfo = @"YOSNotificationUpdateTagInfo";

NSString * const YOSNotificationUpdateAuditInfo = @"YOSNotificationUpdateAuditInfo";

NSString * const YOSNotificationUpdateBuddyRequest = @"YOSNotificationUpdateBuddyRequest";

NSString * const YOSNotificationDeleteBuddy = @"YOSNotificationDeleteBuddy";

NSString * const YOSNotificationLogin = @"YOSNotificationLogin";

NSString * const YOSNotificationLogout = @"YOSNotificationLogout";

/** 好友列表变更 */
NSString * const YOSNotificationUpdateBuddyList = @"YOSNotificationUpdateBuddyList";

/** 接受到别人发来的消息 */
NSString * const YOSNotificationReceiveMessage = @"YOSNotificationReceiveMessage";

NSString * const YOSNotificationResetUnReadMessage = @"YOSNotificationResetUnReadMessage";

NSString * const YOSNotificationShowRedDot = @"YOSNotificationShowRedDot";

/**
 *  给出加密参数sign
 *
 *  @param dict @{name = yy, pass = 123}
 *
 *  @return md5(keyname=yy&pass=123key)
 */
NSString* yos_encodeWithDictionary(NSDictionary* dict){
    
    NSMutableDictionary *mDict = [NSMutableDictionary dictionaryWithDictionary:dict];
    
    NSUInteger count = [mDict count];
    
    NSArray *myKeys = [mDict allKeys];
    NSArray *sortedKeys = [myKeys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    NSMutableString *sortedValues = [[NSMutableString alloc] init];
    
    NSInteger i = 0;
    [sortedValues appendString:YOSEncodeSignKey];
    for(id key in sortedKeys) {
        id object = [mDict objectForKey:key];
        
        //屏蔽为空的值
        if ([object isKindOfClass:[NSString class]]) {
            if ([object isEqual:@""]) {
                i++;
                continue;
            }
        }
        
        [sortedValues appendString:key];
        [sortedValues appendString:@"="];
        if ([object isKindOfClass:[NSString class]]) {
            [sortedValues appendString:object];
        } else {
            [sortedValues appendFormat:@"%@", object];
        }
        
        i++;
        if (i < count) {
            [sortedValues appendString:@"&"];
        }
    }
    
    [sortedValues appendString:YOSEncodeSignKey];
    
    return [sortedValues yos_md5];
}

/*
 工作经验
 1. 1年以下
 2. 1-3年
 3. 3-5年
 4. 5-10年
 5. 10年以上
 
 学历：
 1. 高中
 2. 大专
 3. 本科
 4. 硕士
 5. 博士
 6. 其他
 
 性别：
 1. 男
 2. 女
 */

NSString *yos_getSex(NSString *sexId) {
    
    NSString *sex = nil;
    switch ([sexId integerValue]) {
        case 1:
            sex = @"男";
            break;
        case 2:
            sex = @"女";
            break;
            
        default:
            break;
    }
    
    return sex;
}

NSString *yos_getSexId(NSString *sex) {
    
    NSString *sexId = nil;
    if ([sex isEqualToString:@"男"]) {
        sexId = @"1";
    }
    
    if ([sex isEqualToString:@"女"]) {
        sexId = @"2";
    }
    
    return sexId;
}

NSString *yos_getEducation(NSString *educationId) {
//    1. 高中
//    2. 大专
//    3. 本科
//    4. 硕士
//    5. 博士
//    6. 其他
    NSString *education = nil;
    switch ([educationId integerValue]) {
        case 1:
            education = @"高中";
            break;
        case 2:
            education = @"大专";
            break;
        case 3:
            education = @"本科";
            break;
        case 4:
            education = @"硕士";
            break;
        case 5:
            education = @"博士";
            break;
        case 6:
            education = @"其他";
            break;
            
        default:
            break;
    }
    
    return education;
}

NSString *yos_getEducationId(NSString *education) {
    
    NSString *educationId = nil;
    if ([education isEqualToString:@"高中"]) {
        educationId = @"1";
    }
    
    if ([education isEqualToString:@"大专"]) {
        educationId = @"2";
    }
    
    if ([education isEqualToString:@"本科"]) {
        educationId = @"3";
    }
    
    if ([education isEqualToString:@"硕士"]) {
        educationId = @"4";
    }
    
    if ([education isEqualToString:@"博士"]) {
        educationId = @"5";
    }
    
    if ([education isEqualToString:@"其他"]) {
        educationId = @"6";
    }
    
    return educationId;
    
}

NSString *yos_getJobYears(NSString *jobYearsId) {
//    1. 1年以下
//    2. 1-3年
//    3. 3-5年
//    4. 5-10年
//    5. 10年以上
    NSString *jobYears = nil;
    switch ([jobYearsId integerValue]) {
        case 1:
            jobYears = @"1年以下";
            break;
        case 2:
            jobYears = @"1-3年";
            break;
        case 3:
            jobYears = @"3-5年";
            break;
        case 4:
            jobYears = @"5-10年";
            break;
        case 5:
            jobYears = @"10年以上";
            break;
            
        default:
            break;
    }
    
    return jobYears;
}

NSString *yos_getJobYearsId(NSString *jobYears) {

    NSString *jobYearsId = nil;
    if ([jobYears isEqualToString:@"1年以下"]) {
        jobYearsId = @"1";
    }
    
    if ([jobYears isEqualToString:@"1-3年"]) {
        jobYearsId = @"2";
    }
    
    if ([jobYears isEqualToString:@"3-5年"]) {
        jobYearsId = @"3";
    }
    
    if ([jobYears isEqualToString:@"5-10年"]) {
        jobYearsId = @"4";
    }
    
    if ([jobYears isEqualToString:@"10年以上"]) {
        jobYearsId = @"5";
    }
    
    return jobYearsId;
}
