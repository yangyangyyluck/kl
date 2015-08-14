//
//  YOSHobbyButton.h
//  kuailai
//
//  Created by yangyang on 15/8/14.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YOSHobbyButton : UIButton

@property (nonatomic, assign) BOOL showTopLine;

@property (nonatomic, assign) BOOL showBottomLine;

@property (nonatomic, assign) BOOL showLeftLine;

@property (nonatomic, assign) BOOL showRightLine;

- (instancetype)initWithImageName:(NSString *)imageName title:(NSString *)title;

@end
