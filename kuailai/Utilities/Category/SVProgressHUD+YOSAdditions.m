//
//  SVProgressHUD+YOSAdditions.m
//  kuailai
//
//  Created by yangyang on 15/4/14.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "SVProgressHUD+YOSAdditions.h"
#import "JRSwizzle.h"

@implementation SVProgressHUD (YOSAdditions)

- (UIControl *)yos_overlayView {
    
    UIControl *crl = [self performSelector:NSSelectorFromString(@"yos_overlayView") withObject:nil];
    
    crl.frame = CGRectMake(0, 64, YOSScreenWidth, YOSScreenHeight - 64);
    
    return crl;
}


+ (void)load {
    __autoreleasing NSError *error1 = nil;
    __autoreleasing NSError *error2 = nil;
    [self jr_swizzleMethod:NSSelectorFromString(@"displayDurationForString:") withMethod:@selector(yos_displayDurationForString:) error:&error1];
    
    [self jr_swizzleMethod:NSSelectorFromString(@"overlayView") withMethod:@selector(yos_overlayView) error:&error2];
    
    if (error1) {
        NSLog(@"\r\n\r\n SVProgressHUD swizzle is wrong 111.");
    }
    
    if (error2) {
        NSLog(@"\r\n\r\n SVProgressHUD swizzle is wrong 222.");
    }
    
}

- (NSTimeInterval)yos_displayDurationForString:(NSString*)string {
    return MIN((float)string.length*0.13 + 0.5, 5.0);
}

@end
