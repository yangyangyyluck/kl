//
//  YOSCellButton.h
//  kuailai
//
//  Created by yangyang on 15/6/22.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YOSCellButton : UIButton

@property (nonatomic, assign) BOOL showTopLine;

@property (nonatomic, assign) BOOL showBottomLine;

@property (nonatomic, assign) BOOL showRightAccessory;

- (instancetype)initWithImage:(NSString *)image title:(NSString *)title;

@end
