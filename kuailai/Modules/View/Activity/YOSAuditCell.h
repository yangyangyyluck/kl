//
//  YOSAuditCell.h
//  kuailai
//
//  Created by yangyang on 15/8/6.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITableViewCell+YOSAdditions.h"

@class YOSAuditModel;

@interface YOSAuditCell : UITableViewCell

@property (nonatomic, strong) YOSAuditModel *auditModel;
@property (nonatomic, assign) BOOL showTopLine;
@property (nonatomic, assign) BOOL showBottomLine;

@end
