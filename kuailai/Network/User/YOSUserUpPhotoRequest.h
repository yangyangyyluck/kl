//
//  YOSUserUpPhotoRequest.h
//  kuailai
//
//  Created by yangyang on 15/6/29.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSBaseRequest.h"

@interface YOSUserUpPhotoRequest : YOSBaseRequest

- (instancetype)initWithImage:(UIImage *)aImage uid:(NSString *)uid;

@end
