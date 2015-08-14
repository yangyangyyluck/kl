//
//  YOSUserFeedbackRequest.m
//  kuailai
//
//  Created by yangyang on 15/8/14.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSUserFeedbackRequest.h"

@implementation YOSUserFeedbackRequest {
    NSString *_uid;
    NSString *_demand;
}

- (instancetype)initWithUid:(NSString *)uid demand:(NSString *)demand {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _uid = YOSFliterNil2String(uid);
    _demand = YOSFliterNil2String(demand);
    
    return self;
}

- (id)requestArgument {
    return [self encodeWithDictionary:@{
                                        @"uid" : _uid,
                                        @"demand" : _demand,
                                        }];
}

- (NSString *)requestUrl {
    return @"user/feedback";
}

@end
