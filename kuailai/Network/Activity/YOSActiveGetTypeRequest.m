//
//  YOSActiveGetTypeRequest.m
//  kuailai
//
//  Created by yangyang on 15/5/17.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSActiveGetTypeRequest.h"

@implementation YOSActiveGetTypeRequest {
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

- (NSString *)requestUrl {
    return @"active/getType";
}

- (id)requestArgument {
    return @{
             @"pid" : _pid,
             };
}

@end
