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
#import "ZWEmoji.h"

@implementation EMMessage (YOSAdditions)

- (JSQMessage *)transferToJSQMessageWithUserInfo:(YOSUserInfoModel *)userInfoModel {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:(self.timestamp / 1000)];
    
    NSString *text = [self yos_message];
    
    JSQMessage *message = [[JSQMessage alloc] initWithSenderId:userInfoModel.hx_user
                                             senderDisplayName:userInfoModel.nickname
                                                          date:date
                                                          text:text];
    
    return message;
}

- (JSQMessage *)transferToJSQMessageWithMeUserInfo:(YOSUserInfoModel *)meUserInfoModel otherUserInfo:(YOSUserInfoModel *)otherUserInfoModel {
 
    NSLog(@"from : %@, to : %@, message : %@", self.from, self.to, ((EMTextMessageBody *)self.messageBodies[0]).text);
    
    // other -> me
    if ([self.from isEqualToString:otherUserInfoModel.hx_user] && [self.to isEqualToString:meUserInfoModel.hx_user]) {
        return [self transferToJSQMessageWithUserInfo:otherUserInfoModel];
    }
    
    // me -> other
    if ([self.from isEqualToString:meUserInfoModel.hx_user] && [self.to isEqualToString:otherUserInfoModel.hx_user]) {
        return [self transferToJSQMessageWithUserInfo:meUserInfoModel];
    }
        
        
    return nil;
}

- (NSString *)yos_message {
    NSArray *body = self.messageBodies;
    
    NSString *text = ((EMTextMessageBody *)body[0]).text;
    
    text = [text zw_emojify];
    
    return text;
}

@end
