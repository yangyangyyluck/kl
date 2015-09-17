//
//  YOSWidget.h
//  kuailai
//
//  Created by yangyang on 15/4/9.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YOSUserInfoModel;

@interface YOSWidget : NSObject

+ (instancetype)sharedInstance;

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


/**
 *  UserDefault
 */
+ (void)setUserDefaultWithKey:(NSString *)key value:(NSString *)value;

+ (id)getUserDefaultWithKey:(NSString *)key;

/**
 *  根据时间戳和格式返回当前时间
 *
 *  @param timeStamp 时间戳
 *  @param format    格式
 *
 *  @return NSString
 */
+ (NSString *)dateStringWithTimeStamp:(NSString *)timeStamp Format:(NSString *)format;

/**
 *  获取当前时间戳
 *
 *  @param date
 *
 *  @param format 格式 如 YYYY-MM-dd HH:mm:ss
 *
 *  @return NSString
 */
+ (NSString *)dateStringWithDate:(NSDate *)date Format:(NSString *)format;

/**
 *  返回带~结尾的提示信息
 *
 *  @param string
 *
 *  @return xxxx~
 */
+ (NSString *)waveMessageWithString:(NSString *)string;

+ (YOSUserInfoModel *)getCurrentUserInfoModel;

+ (BOOL)isLogin;

/**
 *  判断时间戳是不是今天
 *
 *  @param timeStamp
 *
 *  @return
 */
+ (BOOL)isTodayWithTimeStamp:(NSString *)timeStamp;

/**
 *  转 NSArray NSDictionary 为 json 字符串
 *
 *  @param object
 *
 *  @return 
 */
+ (NSString *)jsonStringWithJSONObject:(id)object;

/**
 *  中文转拼音
 *
 *  @param chinese
 *
 *  @return
 */
+ (NSString *)pinyinTransformWithChinese:(NSString *)chinese;

/**
 *  比较app版本
 *
 *  @param version1 v1
 *  @param version2 v2
 *
 *  @return result
 */
+ (NSComparisonResult)compareAppVersion1:(NSString *)version1 andAppVersion2:(NSString *)version2;

+ (NSString *)currentAppVersion;

+ (YOSUserInfoModel *)getUserInfoModelWithHxUser:(NSString *)hxUser;

+ (BOOL)isAcceptNotificationWithPrompt:(BOOL)isAccept;

@end
