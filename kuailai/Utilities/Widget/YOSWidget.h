//
//  YOSWidget.h
//  kuailai
//
//  Created by yangyang on 15/4/9.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YOSWidget : NSObject

/**
 *  alert
 *
 *  @param message
 *  @param title
 */
+ (void)alertMessage:(NSString *)message title:(NSString *)title;

/**
 *  输入金额验证 用于textField 代理方法的 textField:shouldChangeCharactersInRange:
 *
 *  @param textField
 *  @param range
 *  @param string
 *
 *  @return BOOL
 */
+ (BOOL)validateInputMoneyWithTextField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;

/**
 *  输入数字验证 用于textField 代理方法的 textField:shouldChangeCharactersInRange:
 *
 *  @param textField
 *  @param range
 *  @param string
 *
 *  @return BOOL
 */
+ (BOOL)validateNumberWithTextField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;

/**
 *  输入字母、数字、下划线 验证 用于textField 代理方法的 textField:shouldChangeCharactersInRange:
 *
 *  @param textField
 *  @param range
 *  @param string
 *
 *  @return BOOL
 */
+ (BOOL)validatePasswordWithTextField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;

+ (void)setUserDefaultWithKey:(NSString *)key value:(NSString *)value;

+ (id)getUserDefaultWithKey:(NSString *)key;

@end
