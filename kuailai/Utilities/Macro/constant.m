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

NSString * const YOSURLBase = @"http://kuailai.zhangdd.cn/app/";

/**
 *  UserDefault keys
 */

NSString * const YOSUserDefaultKeyCurrentRegisterMobileNumber = @"YOSUserDefaultKeyCurrentRegisterMobileNumber";

NSString * const YOSUserDefaultKeyCurrentRegisterID = @"YOSUserDefaultKeyCurrentRegisterID";

NSString * const YOSUserDefaultKeyCurrentLoginMobileNumber = @"YOSUserDefaultKeyCurrentLoginMobileNumber";

NSString * const YOSUserDefaultKeyCurrentLoginID = @"YOSUserDefaultKeyCurrentLoginID";

NSString * const YOSUserDefaultKeyCurrentUserInfoDictionary = @"YOSUserDefaultKeyCurrentUserInfoDictionary";

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
