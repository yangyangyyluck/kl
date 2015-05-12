//
//  UIView+YOSAdditionForIQKeyboardManager.m
//  kuailai
//
//  Created by yangyang on 15/5/12.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "UIView+YOSAdditionForIQKeyboardManager.h"

#import "JRSwizzle.h"
#import <objc/runtime.h>
#import "IQToolbar.h"
#import "IQBarButtonItem.h"
#import "IQTitleBarButtonItem.h"
#import "IQKeyboardManagerConstantsInternal.h"

@implementation UIView (YOSAdditionForIQKeyboardManager)

+ (void)load {
    NSError *error = nil;
    [self jr_swizzleMethod:@selector(addLeftRightOnKeyboardWithTarget:leftButtonTitle:rightButtonTitle:leftButtonAction:rightButtonAction:titleText:) withMethod:@selector(yos_addLeftRightOnKeyboardWithTarget:leftButtonTitle:rightButtonTitle:leftButtonAction:rightButtonAction:titleText:) error:&error];
    
    if (error) {
        YOSLog(@"\r\n fatal error : JRSwizzle wrong.");
    }
    
}

- (void)yos_addLeftRightOnKeyboardWithTarget:(id)target leftButtonTitle:(NSString*)leftTitle rightButtonTitle:(NSString*)rightTitle leftButtonAction:(SEL)leftAction rightButtonAction:(SEL)rightAction titleText:(NSString*)titleText
{
    //  If can't set InputAccessoryView. Then return
    if (![self respondsToSelector:@selector(setInputAccessoryView:)])    return;
    
    //  Creating a toolBar for keyboard
    IQToolbar *toolbar = [[IQToolbar alloc] init];
    if ([self respondsToSelector:@selector(keyboardAppearance)])
    {
        switch ([(UITextField*)self keyboardAppearance])
        {
            case UIKeyboardAppearanceAlert: toolbar.barStyle = UIBarStyleBlack;     break;
            default:                        toolbar.barStyle = UIBarStyleDefault;   break;
        }
    }
    
    NSMutableArray *items = [[NSMutableArray alloc] init];
    
    //  Create a cancel button to show on keyboard to resign it. Adding a selector to resign it.
    IQBarButtonItem *cancelButton =[[IQBarButtonItem alloc] initWithTitle:leftTitle style:UIBarButtonItemStylePlain target:target action:leftAction];
    [items addObject:cancelButton];
    
    NSNumber *shouldHideTitle = objc_getAssociatedObject(self, @selector(shouldHideTitle));
    
    if ([titleText length] && [shouldHideTitle boolValue] == NO)
    {
        CGRect buttonFrame;
        
        if (IQ_IS_IOS7_OR_GREATER)
        {
            /*
             66 Cancel button maximum x.
             50 done button frame.
             8+8 distance maintenance
             */
            buttonFrame = CGRectMake(0, 0, toolbar.frame.size.width-66-50.0-16, 44);
        }
        else
        {
            /*
             66 Cancel button maximum x.
             57 done button frame.
             8+8 distance maintenance
             */
            buttonFrame = CGRectMake(0, 0, toolbar.frame.size.width-66-57.0-16, 44);
        }
        
        IQTitleBarButtonItem *title = [[IQTitleBarButtonItem alloc] initWithFrame:buttonFrame title:titleText];
        [items addObject:title];
    }
    
    //  Create a fake button to maintain flexibleSpace between doneButton and nilButton. (Actually it moves done button to right side.
    IQBarButtonItem *nilButton =[[IQBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [items addObject:nilButton];
    
    //  Create a done button to show on keyboard to resign it. Adding a selector to resign it.
    IQBarButtonItem *doneButton =[[IQBarButtonItem alloc] initWithTitle:rightTitle style:UIBarButtonItemStylePlain target:target action:rightAction];
    [items addObject:doneButton];
    
    //  Adding button to toolBar.
    [toolbar setItems:items];
    
    //  Setting toolbar to keyboard.
    [(UITextField*)self setInputAccessoryView:toolbar];
}

@end
