//
//  YOSRegionModel.m
//  kuailai
//
//  Created by yangyang on 15/5/16.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSRegionModel.h"

@implementation YOSRegionModel

+ (BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id" : @"ID",
                                                       }];
}

@end
