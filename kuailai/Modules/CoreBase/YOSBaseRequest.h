//
//  YOSBaseRequest.h
//  kuailai
//
//  Created by yangyang on 15/4/9.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YTKRequest.h"
#import "YTKBaseRequest+YOSAdditions.h"

@interface YOSBaseRequest : YTKRequest

- (NSDictionary *)encodeWithDictionary:(NSDictionary *)dict;

@end
