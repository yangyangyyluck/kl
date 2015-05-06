//
//  YOSInputView.h
//  kuailai
//
//  Created by yangyang on 15/5/6.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXNibBridge.h"

@interface YOSInputView : UIView <XXNibBridge>

- (instancetype)initWithTitle:(NSString *)title selectedStatus:(BOOL)selected;

@end
