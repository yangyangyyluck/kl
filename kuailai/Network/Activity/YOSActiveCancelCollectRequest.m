//
//  YOSActiveCancelCollectRequest.m
//  kuailai
//
//  Created by yangyang on 15/8/26.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSActiveCancelCollectRequest.h"

@implementation YOSActiveCancelCollectRequest {
    NSString *_uid;
    NSString *_aid;
}

- (instancetype)initWithUid:(NSString *)uid aid:(NSString *)aid {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _uid = YOSFliterNil2String(uid);
    _aid = YOSFliterNil2String(aid);
    
    return self;
}

- (NSString *)requestUrl {
    return @"active/cancel_collect";
}

- (id)requestArgument {
    return [self encodeWithDictionary:@{
                                        @"uid" : _uid,
                                        @"aid" : _aid,
                                        }];
}

@end
