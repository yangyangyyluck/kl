//
//  YOSTagModel.m
//  kuailai
//
//  Created by yangyang on 15/7/10.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSTagModel.h"

@implementation YOSTagModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id" : @"ID",
                                                       }];
}

@end
