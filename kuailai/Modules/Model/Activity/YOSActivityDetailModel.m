//
//  YOSActivityDetailModel.m
//  kuailai
//
//  Created by yangyang on 15/6/9.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSActivityDetailModel.h"
#import "YOSUserInfoModel.h"

@implementation YOSActivityDetailModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id" : @"ID",
                                                       }];
}

@end
