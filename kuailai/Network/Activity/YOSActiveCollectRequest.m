//
//  YOSActiveCollectRequest.m
//  kuailai
//
//  Created by yangyang on 15/8/19.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSActiveCollectRequest.h"

@implementation YOSActiveCollectRequest {
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

- (id)requestArgument {
    return [self encodeWithDictionary:@{
                                        @"uid" : _uid,
                                        @"aid" : _aid,
                                        }];
}

- (NSString *)requestUrl {
    return @"active/collect";
}

@end
