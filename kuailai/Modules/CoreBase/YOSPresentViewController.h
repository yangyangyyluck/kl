//
//  YOSPersentViewController.h
//  kuailai
//
//  Created by yangyang on 15/5/12.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YOSPresentViewController : UIViewController

- (void)setupNavigationBar;
- (void)setupNavTitle:(NSString *)title;
- (void)setupLeftButtonWithTitle:(NSString *)title;
- (void)setupRightButtonWithTitle:(NSString *)title;
- (void)clickLeftItem:(UIButton *)item;
- (void)clickRightItem:(UIButton *)item;

@end
