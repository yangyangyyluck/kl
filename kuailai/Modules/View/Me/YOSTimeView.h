//
//  YOSTimeView.h
//  kuailai
//
//  Created by yangyang on 15/7/13.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YOSTimeView : UIView

@property (nonatomic, strong, readonly) UISwitch *swh;

@property (nonatomic, strong) NSDate *alertDate;

@property (nonatomic, copy) voidBlock_id idBlock;

@end