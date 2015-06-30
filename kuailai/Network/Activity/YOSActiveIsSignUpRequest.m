//
//  YOSActiveIsSignUpRequest.m
//  kuailai
//
//  Created by yangyang on 15/6/30.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSActiveIsSignUpRequest.h"

@implementation YOSActiveIsSignUpRequest {
    NSString *_uid;
    NSString *_aid;
}

- (instancetype)initWithUid:(NSString *)uid andAid:(NSString *)aid {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _uid = YOSFliterNil2String(uid);
    _aid = YOSFliterNil2String(aid);
    
    return self;
}

- (NSString *)requestUrl {
    return @"active/isSignUp";
}

- (id)requestArgument {
    return [self encodeWithDictionary:@{
                                        @"uid" : _uid,
                                        @"aid" : _aid,
                                        }];
}

@end
