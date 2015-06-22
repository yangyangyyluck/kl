//
//  YOSFriendModel.m
//  kuailai
//
//  Created by yangyang on 15/6/18.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSFriendModel.h"

@implementation YOSFriendModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

- (BOOL)isEqual:(YOSFriendModel *)object {
    BOOL status0 = ([self.nickname isEqualToString:object.nickname]);
    BOOL status1 = ([self.company isEqualToString:object.company]);
    BOOL status2 = ([self.position isEqualToString:object.position]);
    BOOL status3 = ([self.avatar isEqualToString:object.avatar]);
    
    if (status0 && status1 && status2 && status3) {
        return YES;
    } else {
        return [super isEqual:object];
    }
}

@end
