//
//  YOSEaseMobManager.h
//  kuailai
//
//  Created by yangyang on 15/7/16.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YOSEaseMobManager : NSObject

+ (instancetype)sharedManager;

- (BOOL)registerNewAccount;

- (void)loginEaseMob;

- (void)logoffWithUnbindDeviceToken:(BOOL)status;

@end
