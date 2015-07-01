//
//  YOSUserGetMyActiveListRequest.h
//  kuailai
//
//  Created by yangyang on 15/6/30.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSBaseRequest.h"

@interface YOSUserGetMyActiveListRequest : YOSBaseRequest

- (instancetype)initWithUid:(NSString *)uid andPage:(NSString *)page andStatus:(NSString *)status;

@end
