//
//  YOSActiveGetCityRequest.m
//  kuailai
//
//  Created by yangyang on 15/5/16.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSActiveGetCityRequest.h"

@implementation YOSActiveGetCityRequest {
    NSString *_pid;
}

- (instancetype)initWithPid:(NSString *)pid {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _pid = YOSFliterNil2String(pid);
    
    return self;
}

- (id)requestArgument {
    return @{@"pid" : _pid};
}

- (NSString *)requestUrl {
    return @"active/getCity";
}

@end
