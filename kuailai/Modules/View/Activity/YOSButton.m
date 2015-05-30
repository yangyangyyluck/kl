//
//  YOSButton.m
//  kuailai
//
//  Created by yangyang on 15/5/30.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSButton.h"

@implementation YOSButton

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    CGRect bounds = self.bounds;
    
    CGFloat widthDelta = MAX(50 - self.bounds.size.width, 0);
    CGFloat heightDelta = MAX(50 - self.bounds.size.height, 0);
    
    bounds = CGRectInset(bounds, -0.5 * widthDelta, -0.5 * heightDelta);
    
    return CGRectContainsPoint(bounds, point);
}

@end
