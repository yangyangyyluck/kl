//
//  YOSActivityFatherTypeModel.m
//  kuailai
//
//  Created by yangyang on 15/5/30.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSActivityFatherTypeModel.h"

@implementation YOSActivityFatherTypeModel

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id" : @"ID",
                                                       }];
}

@end
