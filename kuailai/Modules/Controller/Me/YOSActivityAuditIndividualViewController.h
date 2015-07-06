//
//  YOSActivityAuditIndividualViewController.h
//  kuailai
//
//  Created by yangyang on 15/7/2.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSBaseViewController.h"

@interface YOSActivityAuditIndividualViewController : YOSBaseViewController

@property (nonatomic, strong) NSMutableArray *userInfoModels;

@property (nonatomic, strong) NSIndexPath *currentIndexPath;

@property (nonatomic, copy) NSString *aid;

@end
