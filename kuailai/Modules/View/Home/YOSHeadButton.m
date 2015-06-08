//
//  YOSHeadButton.m
//  kuailai
//
//  Created by yangyang on 15/6/8.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSHeadButton.h"

@implementation YOSHeadButton

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    return CGRectMake(8, 8, 39, 39);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    return CGRectMake(8, 50, 39, 10);
}

@end
