//
//  YOSActivityListModel.m
//  kuailai
//
//  Created by yangyang on 15/6/2.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSActivityListModel.h"

@implementation YOSActivityListModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id" : @"ID",
                                                       }];
}

- (BOOL)isEqual:(YOSActivityListModel *)object {
    if (self.ID && [self.ID isEqualToString:object.ID]) {
        return YES;
    } else {
        return [super isEqual:object];
    }
}

@end
