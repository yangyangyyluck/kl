//
//  EMMessage+YOSAdditions.m
//  kuailai
//
//  Created by yangyang on 15/8/10.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "EMMessage+YOSAdditions.h"
#import "JSQMessage.h"
#import "EMTextMessageBody.h"
#import "YOSUserInfoModel.h"

@implementation EMMessage (YOSAdditions)

- (JSQMessage *)transferToJSQMessageWithUserInfo:(YOSUserInfoModel *)userInfoModel {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:(self.timestamp / 1000)];
    
    NSArray *body = self.messageBodies;
    
    NSString *text = ((EMTextMessageBody *)body[0]).text;
    
    JSQMessage *message = [[JSQMessage alloc] initWithSenderId:self.messageId
                                             senderDisplayName:userInfoModel.nickname
                                                          date:date
                                                          text:text];
    
    return message;
}

@end
