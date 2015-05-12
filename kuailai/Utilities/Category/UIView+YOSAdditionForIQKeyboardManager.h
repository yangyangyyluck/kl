//
//  UIView+YOSAdditionForIQKeyboardManager.h
//  kuailai
//
//  Created by yangyang on 15/5/12.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (YOSAdditionForIQKeyboardManager)

- (void)yos_addLeftRightOnKeyboardWithTarget:(id)target leftButtonTitle:(NSString*)leftTitle rightButtonTitle:(NSString*)rightTitle leftButtonAction:(SEL)leftAction rightButtonAction:(SEL)rightAction titleText:(NSString*)titleText;

@end
