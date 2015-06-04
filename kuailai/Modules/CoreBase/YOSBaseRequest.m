//
//  YOSBaseRequest.m
//  kuailai
//
//  Created by yangyang on 15/4/9.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSBaseRequest.h"
#import "YOSWidget.h"

@implementation YOSBaseRequest

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPost;
}

- (NSDictionary *)encodeWithDictionary:(NSDictionary *)dict {
    
    NSMutableDictionary *mDict = [dict mutableCopy];

    mDict[@"from"] = @"ios";
    mDict[@"sign"] = yos_encodeWithDictionary(mDict);
    
    return mDict;
}

@end
