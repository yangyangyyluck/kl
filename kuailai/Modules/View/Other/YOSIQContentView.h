//
//  YOSIQContentView.h
//  kuailai
//
//  Created by yangyang on 15/5/17.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  why create this empty subclass?     yy annotate: IQKeyboardManager's problem
 *  IQKM told me should create a subclass and add customView in it.
 *
 *  If your textFields are on different customView and do not show previous/next to navigate between textField. Then you should create a SpecialView subclass of UIView, then put all customView inside SpecialView, then register SpecialView class using -(void)considerToolbarPreviousNextInViewClass:(Class)toolbarPreviousNextConsideredClass method in AppDelegate.(#154, #179)
 *  https://github.com/hackiftekhar/IQKeyboardManager
 */
@interface YOSIQContentView : UIView

@end
