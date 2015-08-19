//
//  YOSMessageCell.h
//  kuailai
//
//  Created by yangyang on 15/7/16.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITableViewCell+YOSAdditions.h"

@class YOSMessageModel, YOSUserInfoModel;

@interface YOSMessageCell : UITableViewCell

@property (nonatomic, strong) YOSMessageModel *messageModel;
@property (nonatomic, strong) YOSUserInfoModel *userInfoModel;

@property (nonatomic, assign) BOOL showTopLine;
@property (nonatomic, assign) BOOL showBottomLine;
@property (nonatomic, assign) BOOL showAccessoryView;
@property (nonatomic, assign) BOOL showTimeLabel;
@property (nonatomic, assign) BOOL showStatusLabel;
@property (nonatomic, assign) BOOL showCountLabel;

@property (nonatomic, weak) UIView *fatherVC;

@end
