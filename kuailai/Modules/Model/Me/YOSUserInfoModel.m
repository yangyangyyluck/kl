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
                                                       @"degress_name" : @"degree_name",
                                                       }];
}

- (BOOL)isEqual:(YOSUserInfoModel *)object {
    if ([self.ID isEqualToString:object.ID]) {
        return YES;
    } else {
        return [super isEqual:object];
    }
}

- (instancetype)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err {
    NSMutableDictionary *mDict = [dict mutableCopy];
    
    NSString *avatar = mDict[@"avatar"];
    
    if (avatar.length && ![avatar hasPrefix:@"http://"]) {
        avatar = [NSString stringWithFormat:@"%@%@", YOSImageBaseUrl, avatar];
        mDict[@"avatar"] = avatar;
    }
    
    return [super initWithDictionary:mDict error:err];
}

@end
