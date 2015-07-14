//
//  YOSHideTextField.m
//  kuailai
//
//  Created by yangyang on 15/7/13.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSHideTextField.h"

@implementation YOSHideTextField

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    
    CGPoint pt = [self convertPoint:point toView:self.agencyView];
    
    BOOL status = [super pointInside:pt withEvent:event];
    
    return status;
}

@end
