//
//  YOSUserGetUserByHxRequest.m
//  kuailai
//
//  Created by yangyang on 15/7/29.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSUserGetUserByHxRequest.h"

@implementation YOSUserGetUserByHxRequest {
    NSString *_hxUsers;
}

- (instancetype)initWithHXUsers:(NSArray *)hxUsers {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _hxUsers = YOSFliterNil2String([hxUsers componentsJoinedByString:@","]);
    
    return self;
}

- (id)requestArgument {
    return [self encodeWithDictionary:@{
                                        @"hx_str" : _hxUsers,
                                        }];
}

- (NSString *)requestUrl {
    return @"user/getUserByHx";
}

@end
