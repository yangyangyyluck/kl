//
//  YOSMessageCell.h
//  kuailai
//
//  Created by yangyang on 15/7/16.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITableViewCell+YOSAdditions.h"

@class YOSMessageModel;

@interface YOSBuddyRequestCell : UITableViewCell

@property (nonatomic, strong) YOSMessageModel *messageModel;
@property (nonatomic, assign) BOOL showTopLine;
@property (nonatomic, assign) BOOL showBottomLine;

@end
