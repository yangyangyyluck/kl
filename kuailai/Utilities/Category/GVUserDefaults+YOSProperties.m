//
//  GVUserDefaults+YOSProperties.m
//  kuailai
//
//  Created by yangyang on 15/6/24.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "GVUserDefaults+YOSProperties.h"

@implementation GVUserDefaults (YOSProperties)

@dynamic currentRegisterMobileNumber;

@dynamic currentRegisterID;

@dynamic currentLoginMobileNumber;

@dynamic currentLoginID;

@dynamic currentUserInfoDictionary;

@dynamic currentTagDictionary;

- (NSDictionary *)setupDefaults {
    return nil;
}

- (void)logout {
    self.currentLoginID = nil;
    self.currentLoginMobileNumber = nil;
    self.currentTagDictionary = nil;
    self.currentUserInfoDictionary = nil;
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
