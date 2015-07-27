//
//  YOSFriendCell.h
//  kuailai
//
//  Created by yangyang on 15/6/18.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITableViewCell+YOSAdditions.h"

@class YOSUserInfoModel;

@interface YOSAddBuddyCell : UITableViewCell

@property (nonatomic, strong) YOSUserInfoModel *userInfoModel;
@property (nonatomic, assign) BOOL showTopLine;
@property (nonatomic, assign) BOOL showBottomLine;

@end
