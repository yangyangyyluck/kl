//
//  UIButton+YOSAdditions.h
//  kuailai
//
//  Created by yangyang on 15/4/27.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (YOSAdditions)

/**
 *  调整button为上图下文字且居中的模式.
 *  原理：计算image和title的落点落点的center。endCenter - beginCenter 即为UIEdgeInsets
 */
- (void)yos_adjustToTopImageBottomTitle;

@end
