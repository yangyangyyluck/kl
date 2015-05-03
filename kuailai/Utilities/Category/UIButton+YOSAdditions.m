//
//  UIButton+YOSAdditions.m
//  kuailai
//
//  Created by yangyang on 15/4/27.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "UIButton+YOSAdditions.h"

@implementation UIButton (YOSAdditions)

- (void)yos_adjustToTopImageBottomTitle {
    CGPoint buttonBoundsCenter = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));

    // 找出imageView最终的center
    
    CGPoint endImageViewCenter = CGPointMake(buttonBoundsCenter.x, CGRectGetMidY(self.imageView.bounds));
    
    // 找出titleLabel最终的center
    
    CGPoint endTitleLabelCenter = CGPointMake(buttonBoundsCenter.x, CGRectGetHeight(self.bounds)-CGRectGetMidY(self.titleLabel.bounds));
    
    // 取得imageView最初的center
    
    CGPoint startImageViewCenter = self.imageView.center;
    
    // 取得titleLabel最初的center
    
    CGPoint startTitleLabelCenter = self.titleLabel.center;
    
    // 设置imageEdgeInsets
    
    CGFloat imageEdgeInsetsTop = endImageViewCenter.y - startImageViewCenter.y;
    
    CGFloat imageEdgeInsetsLeft = endImageViewCenter.x - startImageViewCenter.x;
    
    CGFloat imageEdgeInsetsBottom = -imageEdgeInsetsTop;
    
    CGFloat imageEdgeInsetsRight = -imageEdgeInsetsLeft;
    
    self.imageEdgeInsets = UIEdgeInsetsMake(imageEdgeInsetsTop, imageEdgeInsetsLeft, imageEdgeInsetsBottom, imageEdgeInsetsRight);
    
    // 设置titleEdgeInsets
    
    CGFloat titleEdgeInsetsTop = endTitleLabelCenter.y-startTitleLabelCenter.y;
    
    CGFloat titleEdgeInsetsLeft = endTitleLabelCenter.x - startTitleLabelCenter.x;
    
    CGFloat titleEdgeInsetsBottom = -titleEdgeInsetsTop;
    
    CGFloat titleEdgeInsetsRight = -titleEdgeInsetsLeft;
    
    self.titleEdgeInsets = UIEdgeInsetsMake(titleEdgeInsetsTop, titleEdgeInsetsLeft, titleEdgeInsetsBottom, titleEdgeInsetsRight);
}

@end
