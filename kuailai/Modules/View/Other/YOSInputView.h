//
//  YOSInputView.h
//  kuailai
//
//  Created by yangyang on 15/5/6.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YOSInputView : UIView

@property (nonatomic, assign) BOOL selected;

/**
 *  init method
 *
 *  @param title         左边title
 *  @param selected      是否☑️
 *  @param maxCharacters 最大可写入字符 传入0则不限制
 *  @param maxLines      直达可用行数 传入0则不限制
 *
 *  @return YOSInputView
 */
- (instancetype)initWithTitle:(NSString *)title selectedStatus:(BOOL)selected maxCharacters:(NSUInteger)maxCharacters maxLines:(NSUInteger)maxLines;

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
