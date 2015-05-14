//
//  YOSDBManager.h
//  kuailai
//
//  Created by yangyang on 15/5/14.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, YOSDBManagerTableType) {
    YOSDBManagerTableTypeActivityCity,
    YOSDBManagerTableTypeActivityRegion,
};

@interface YOSDBManager : NSObject

+ (instancetype)sharedManager;

- (void)chooseTable:(YOSDBManagerTableType)tableType isUseQueue:(BOOL)status;

- (void)updateActivityCityWithArray:(NSArray *)array;

@end
