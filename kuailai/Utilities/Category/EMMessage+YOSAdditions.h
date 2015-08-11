//
//  EMMessage+YOSAdditions.h
//  kuailai
//
//  Created by yangyang on 15/8/10.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "EMMessage.h"
@class JSQMessage, YOSUserInfoModel;
@interface EMMessage (YOSAdditions)

- (JSQMessage *)transferToJSQMessageWithUserInfo:(YOSUserInfoModel *)userInfoModel;

- (JSQMessage *)transferToJSQMessageWithMeUserInfo:(YOSUserInfoModel *)meUserInfoModel otherUserInfo:(YOSUserInfoModel *)otherUserInfoModel;

@end
