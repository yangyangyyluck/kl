//
//  YOSActiveGetActiveRequest.m
//  kuailai
//
//  Created by yangyang on 15/6/9.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSActiveGetActiveRequest.h"

@implementation YOSActiveGetActiveRequest {
    NSString *_ID;
}

- (instancetype)initWithId:(NSString *)ID {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _ID = YOSFliterNil2String(ID);
    
    return self;
}

- (id)requestArgument {
    return [self encodeWithDictionary:@{
                                        @"id" : _ID,
                                        }];
}

- (NSString *)requestUrl {
    return @"active/getActive";
}

@end
