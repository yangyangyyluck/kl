//
//  UITabBarController+YOSAdditions.h
//  kuailai
//
//  Created by yangyang on 15/8/11.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBarController (YOSAdditions)

// red dot
- (void)showRedDotWithButtonAtIndex:(NSUInteger)index;
- (void)hideRedDotWithButtonAtIndex:(NSUInteger)index;

@end
