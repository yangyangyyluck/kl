//
//  YOSActiveGetCollectRequest.m
//  kuailai
//
//  Created by yangyang on 15/6/22.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSActiveGetCollectRequest.h"

@implementation YOSActiveGetCollectRequest {
    NSString *_aid;
    NSString *_page;
}

- (instancetype)initWithAid:(NSString *)aid page:(NSString *)page {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _aid = YOSFliterNil2String(aid);
    _page = YOSFliterNil2String(page);
    
    return self;
}

- (id)requestArgument {
    return [self encodeWithDictionary:@{
                                        @"aid" : _aid,
                                        @"page" : _page
                                        }];
}

- (NSString *)requestUrl {
    return @"active/get_collect";
}

@end
