//
//  YOSTabBar.h
//  kuailai
//
//  Created by yangyang on 15/3/16.
//  Copyright (c) 2015年 isasa. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 
 *  [[NSNotificationCenter defaultCenter] postNotificationName:YOSNotificationShowRedDot object:nil userInfo:@{@"index": @0}];
 */

@interface YOSTabBar : UITabBar

// red dot
- (void)showRedDotWithButtonAtIndex:(NSUInteger)index;

@end
