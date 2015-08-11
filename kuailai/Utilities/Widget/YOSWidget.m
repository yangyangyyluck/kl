//
//  YOSWidget.m
//  kuailai
//
//  Created by yangyang on 15/4/9.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSWidget.h"

#import "YOSUserInfoModel.h"
#import "GVUserDefaults+YOSProperties.h"

@implementation YOSWidget

+ (void)alertMessage:(NSString *)message title:(NSString *)title {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    
    [alert show];
}

+ (BOOL)validateInputMoneyWithTextField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    // 输入的不是1234567890. 或者空字符 则取消当此输入
    NSString *container = @"1234567890.";
    
    NSRange ran = [container rangeOfString:string];
    
    // 输入合法 || 删除操作
    if ([string isEqualToString:@""] || ran.location != NSNotFound) {
        
        // 输入 1~9
        if (![string isEqualToString:@"."]) {
            
            // 删除操作
            if ([string isEqualToString:@""]) {
                return YES;
            }
            
            // 当前输入过 .
            NSRange range = [textField.text rangeOfString:@"."];
            if (range.location != NSNotFound) {
                NSString *subString = [textField.text substringFromIndex:range.location];
                
                // .12 小数点后最多2位
                if (subString.length <= 2) {
                    return YES;
                } else {    // 小数点后已经2位
                    return NO;
                }
            } else {    // 没输入过 .
                return YES;
            }
            
        } else {    // 输入 .
            
            // 当前还没输入过 .
            if (((NSRange)[textField.text rangeOfString:@"."]).location == NSNotFound) {
                return YES;
            } else {    // 当前已经输入过 .
                return NO;
            }
        }
        
        
    } else {    // 输入非法
        return NO;
    }
}

+ (BOOL)validateNumberWithTextField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    // 输入的不是1234567890. 或者空字符 则取消当此输入
    NSString *container = @"1234567890";
    
    NSRange ran = [container rangeOfString:string];
    
    // 删除操作
    if ([string isEqualToString:@""]) {
        return YES;
    }
    
    // 输入合法(0~9)
    if (ran.location != NSNotFound) {
        return YES;
    } else {    // 输入非法
        return NO;
    }
}

+ (BOOL)validatePasswordWithTextField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    // 输入的不是字母、数字、下划线 则返回NO
    NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:@"[^0-9a-zA-Z_]" options:NSRegularExpressionCaseInsensitive error:nil];
    
    NSArray *result = [reg matchesInString:string options:NSMatchingReportProgress range:NSMakeRange(0, string.length)];
    
    if (result.count) {
        return NO;
    } else {
        return YES;
    }
}

+ (void)setUserDefaultWithKey:(NSString *)key value:(NSString *)value {
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (id)getUserDefaultWithKey:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

+ (NSString *)dateStringWithTimeStamp:(NSString *)timeStamp Format:(NSString *)format {
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:format];
    [formatter setTimeZone:timeZone];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeStamp longLongValue]];
    
    NSString *result = [formatter stringFromDate:date];
    
    return result;
}

+ (NSString *)dateStringWithDate:(NSDate *)date Format:(NSString *)format {
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = format;
    formatter.timeZone = timeZone;
    
    NSString *result = [formatter stringFromDate:date];
    
    return result;
}

+ (NSString *)waveMessageWithString:(NSString *)string {
    if ([string hasSuffix:@"~"]) {
        return string;
    } else {
        return [NSString stringWithFormat:@"%@~", string];
    }
}

+ (YOSUserInfoModel *)getCurrentUserInfoModel {
    
    NSDictionary *dict = [GVUserDefaults standardUserDefaults].currentUserInfoDictionary;
    
    if (dict) {
        YOSUserInfoModel *userInfoModel = [[YOSUserInfoModel alloc] initWithDictionary:dict error:nil];
        
        return userInfoModel;
    }
    
    return nil;
}

+ (BOOL)isLogin {
    YOSUserInfoModel *userInfoModel = [self getCurrentUserInfoModel];
    if (userInfoModel.username.length && userInfoModel.hx_user.length && userInfoModel.hx_pwd.length) {
        return YES;
    } else {
        return NO;
    }
}

+ (BOOL)isTodayWithTimeStamp:(NSString *)timeStamp {
    NSTimeInterval timeInterval = [timeStamp doubleValue];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSString *strDate = [formatter stringFromDate:[NSDate date]];
    NSDate *dateToday = [formatter dateFromString:strDate];
    NSTimeInterval timeTodayInterval = [dateToday timeIntervalSince1970]; // 这个就是今天0点的那个秒点整数了

    if (timeInterval > timeTodayInterval && timeInterval < (timeTodayInterval + 24 * 3600)) {
        return YES;
    } else {
        return NO;
    }

}

@end
