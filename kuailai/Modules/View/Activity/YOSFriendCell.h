//
//  YOSFriendCell.h
//  kuailai
//
//  Created by yangyang on 15/6/18.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YOSFriendModel;

@interface YOSFriendCell : UITableViewCell

@property (nonatomic, strong) YOSFriendModel *friendModel;
@property (nonatomic, assign) BOOL showTopLine;
@property (nonatomic, assign) BOOL showBottomLine;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
