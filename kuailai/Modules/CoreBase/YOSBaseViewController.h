//
//  YOSBaseViewController.h
//  kuailai
//
//  Created by yangyang on 15/4/3.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YOSBaseViewController : UIViewController

+ (instancetype)viewControllerFromStoryboardWithSBName:(NSString *)name;

- (void)setupBackArrow;
- (void)clickLeftItem:(UIBarButtonItem *)item;
- (void)setupNavTitle:(NSString *)title;

@end
