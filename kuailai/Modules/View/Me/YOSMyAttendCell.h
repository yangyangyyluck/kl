//
//  YOSMyAttendCell.h
//  kuailai
//
//  Created by yangyang on 15/7/13.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITableViewCell+YOSAdditions.h"

@class YOSActivityListModel;

@interface YOSMyAttendCell : UITableViewCell

@property (nonatomic, strong) YOSActivityListModel *activityListModel;

@end
