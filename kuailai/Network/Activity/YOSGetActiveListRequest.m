//
//  YOSGetActiveList.m
//  kuailai
//
//  Created by yangyang on 15/6/2.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSGetActiveListRequest.h"

@implementation YOSGetActiveListRequest {
    YOSCityType _city;
    NSUInteger _page;
    NSUInteger _time;
    NSUInteger _type;
}

- (instancetype)initWithCity:(YOSCityType)city page:(NSUInteger)page start_time:(NSUInteger)time type:(NSUInteger)type {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _city = city;
    _page = page;
    _time = time;
    _type = type;
    
    return self;
}

- (NSString *)requestUrl {
    return @"active/getActiveList";
}

- (id)requestArgument {
    return [self encodeWithDictionary:@{
                                        @"city" : @(_city),
                                        @"page" : @(_page),
                                        @"start_time" : @(_time),
                                        @"type" : @(_type),
                                        }];
}

- (NSInteger)cacheTimeInSeconds {
    return 1000;
}

@end
