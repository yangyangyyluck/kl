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
- (void)setupRightButtonWithTitle:(NSString *)title;
- (void)setupLeftButtonWithTitle:(NSString *)title;
- (void)clickLeftItem:(UIButton *)item;
- (void)clickRightItem:(UIButton *)item;
- (void)setupNavTitle:(NSString *)title;

// custom methods for kuai lai
- (void)setupKuaiLai;

- (void)showDefaultMessage:(NSString *)message tappedBlock:(voidBlock)vBlock;
- (void)hideDefaultMessage;

@end
