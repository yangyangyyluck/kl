//
//  YOSUserInfoModel.m
//  kuailai
//
//  Created by yangyang on 15/6/8.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSUserInfoModel.h"

@implementation YOSUserInfoModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id" : @"ID",
                                                       @"degress" : @"degree",
                                                       }];
}

@end
