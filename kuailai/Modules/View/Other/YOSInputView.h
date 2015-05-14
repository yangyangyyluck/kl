//
//  YOSInputView.h
//  kuailai
//
//  Created by yangyang on 15/5/6.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, YOSInputViewPickerType) {
    YOSInputViewPickerTypeNone = 0,     // 不显示picker
    YOSInputViewPickerTypeActivity,     // 活动
    YOSInputViewPickerTypeAge,          // 年龄
    YOSInputViewPickerTypeAllCity,      // 选择城市
};

@interface YOSInputView : UIView

/**
 *  YOSInputViewDatePickerType type
 */
@property (nonatomic, assign) YOSInputViewPickerType pickerType;

/**
 *  当前选中状态
 */
@property (nonatomic, assign) BOOL selected;

/**
 *  设置展位文字
 */
@property (nonatomic, strong) NSString *placeholder;

/**
 *  init method
 *
 *  @param title         左边title
 *  @param selected      是否☑️
 *  @param maxCharacters 最大可写入字符 传入0则不限制
 *  @param single        单行/多行
 *
 *  @return YOSInputView
 */
- (instancetype)initWithTitle:(NSString *)title selectedStatus:(BOOL)selected maxCharacters:(NSUInteger)maxCharacters isSingleLine:(BOOL)single;

/**
 *  当前控件内文本
 *
 *  @return text
 */
- (NSString *)text;

/**
 *  当前view的高度
 *
 *  @return height
 */
- (CGFloat)height;

@end
