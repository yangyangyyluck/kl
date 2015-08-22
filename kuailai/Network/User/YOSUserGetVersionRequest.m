//
//  YOSUserGetVersionRequest.m
//  kuailai
//
//  Created by yangyang on 15/8/22.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSUserGetVersionRequest.h"

@implementation YOSUserGetVersionRequest {
    NSString *_type;
}

- (instancetype)initWithIOS {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    return self;
}

- (id)requestArgument {
    return [self encodeWithDictionary:@{
                                        @"type" : @"1",
                                        }];
}

- (NSString *)requestUrl {
    return @"user/getVersion";
}

@end
