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

@dynamic lastLoginUsername;

@dynamic currentLoginMobileNumber;

@dynamic currentLoginID;

@dynamic currentUserInfoDictionary;

@dynamic currentTagDictionary;

@dynamic isPublic;

@dynamic lastVersion;

- (NSDictionary *)setupDefaults {
    return @{
             @"isPublic" : @1,
             @"lastVersion" : @"0.9",
             };
}

- (void)logout {
    self.currentLoginID = nil;
    self.currentLoginMobileNumber = nil;
    self.currentTagDictionary = nil;
    self.currentUserInfoDictionary = nil;
    self.isPublic = 1;
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
