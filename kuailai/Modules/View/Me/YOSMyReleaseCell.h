//
//  YOSMyReleaseCell.h
//  kuailai
//
//  Created by yangyang on 15/6/30.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YOSActivityListModel;

@interface YOSMyReleaseCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) YOSActivityListModel *activityListModel;

@end
