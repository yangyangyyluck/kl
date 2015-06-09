//
//  YOSEditViewController.h
//  kuailai
//
//  Created by yangyang on 15/5/12.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSPresentViewController.h"

@interface YOSEditViewController : YOSPresentViewController

@property (nonatomic, copy) voidBlock_id vBlock;
@property (nonatomic, copy) NSString *text;

- (instancetype)initWithTitle:(NSString *)title placeholder:(NSString *)placeholder maxCharacters:(NSUInteger)maxCharacters;

@end
