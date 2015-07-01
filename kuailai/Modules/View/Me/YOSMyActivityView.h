//
//  YOSMyReleaseActivityView.h
//  kuailai
//
//  Created by yangyang on 15/6/30.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YOSActivityListModel;

@interface YOSMyActivityView : UIView

@property (nonatomic, strong) YOSActivityListModel *activityListModel;

@property (nonatomic, assign) BOOL showTopLine;

@property (nonatomic, assign) BOOL showBottomLine;

@end
