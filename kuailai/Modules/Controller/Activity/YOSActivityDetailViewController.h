//
//  YOSActivityDetailViewController.h
//  kuailai
//
//  Created by yangyang on 15/6/9.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSBaseViewController.h"

@interface YOSActivityDetailViewController : YOSBaseViewController

- (instancetype)initWithActivityId:(NSString *)activityId;

@property (nonatomic, copy) voidBlock vBlock;

@end
