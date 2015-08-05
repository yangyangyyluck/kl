//
//  YOSSettingCell.h
//  kuailai
//
//  Created by yangyang on 15/8/5.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITableViewCell+YOSAdditions.h"

@interface YOSSettingCell : UITableViewCell

@property (nonatomic, assign) BOOL showTopLine;

@property (nonatomic, assign) BOOL showBottomLine;

@property (nonatomic, assign) BOOL showRightAccessoryArrow;

@property (nonatomic, assign) BOOL showSwitch;

@property (nonatomic, strong) UILabel *leftLabel;

@property (nonatomic, strong) UILabel *rightLabel;

- (void)showSwitchWithSelectedBlock:(voidBlock)selectedBlock unSelectedBlock:(voidBlock)unSelectedBlock;

@end
