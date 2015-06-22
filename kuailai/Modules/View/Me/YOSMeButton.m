//
//  YOSMeButton.m
//  kuailai
//
//  Created by yangyang on 15/6/22.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSMeButton.h"

@implementation YOSMeButton

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    return CGRectMake(8, 5, 39, 39);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    return CGRectMake(2.5, 50, 50, 11.5);
}

@end
