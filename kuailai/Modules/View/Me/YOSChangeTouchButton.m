//
//  YOSChangeTouchButton.m
//  kuailai
//
//  Created by yangyang on 15/7/13.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSChangeTouchButton.h"

@implementation YOSChangeTouchButton

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    
    if (view == self) {
        return self.agencyView;
    } else {
        return nil;
    }
    
}

@end
