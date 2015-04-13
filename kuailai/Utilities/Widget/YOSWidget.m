//
//  YOSWidget.m
//  kuailai
//
//  Created by yangyang on 15/4/9.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSWidget.h"

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

@end
