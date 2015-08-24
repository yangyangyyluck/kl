//
//  YOSEaseMobManager.m
//  kuailai
//
//  Created by yangyang on 15/7/16.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSEaseMobManager.h"
#import "YOSWidget.h"
#import "YOSUserInfoModel.h"
#import "YOSDBManager.h"
#import "SVProgressHUD+YOSAdditions.h"
#import "ChatSendHelper.h"
#import "GVUserDefaults+YOSProperties.h"
#import "YOSLocalNotificationManager.h"
#import "NSString+YOSAdditions.h"
#import "EMMessage+YOSAdditions.h"

@interface YOSEaseMobManager () <EMChatManagerDelegate>

@property (nonatomic, strong) EaseMob *easeMob;

@property (nonatomic, strong) YOSUserInfoModel *userInfoModel;

@property (nonatomic, strong, readwrite) NSArray *buddyList;

@property (nonatomic, strong, readwrite) NSArray *blockedList;

/** 该方法比较特殊，只有在您之前获取过好友列表的情况下才会有值，且不能保证最新。 */
@property (nonatomic, strong) NSArray *buddyListInMemory;

@property (nonatomic, strong) NSArray *blockedListInMemory;

/** 所有创建的绘画 */
@property (nonatomic, strong) NSMutableDictionary *conversations;

@end

@implementation YOSEaseMobManager

#pragma mark - public methods

+ (instancetype)sharedManager {
    static YOSEaseMobManager *mgr;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mgr = [YOSEaseMobManager new];
    });
    
    return mgr;
}

- (BOOL)isHxLogin {
    return self.easeMob.chatManager.isLoggedIn;
}

- (BOOL)loginCheck {
    
    if ([YOSWidget isLogin]) {
        return YES;
    } else {
        // kuailai login out
        NSLog(@"\r\n\r\n\r\nhere need kuailai login out.\r\n\r\n\r\n");
        
        YOSPostNotification(YOSNotificationLogout);
        [[GVUserDefaults standardUserDefaults] logout];
        self.buddyList = nil;
        self.blockedList = nil;
        self.buddyListInMemory = nil;
        self.blockedListInMemory = nil;
        
        return NO;
    }

}

- (BOOL)registerNewAccount {
    
    if (![self loginCheck]) {
        return NO;
    }
    
    NSString *user = self.userInfoModel.hx_user;
    NSString *pass = self.userInfoModel.hx_pwd;
    
    EMError *error = nil;
    BOOL status = [self.easeMob.chatManager registerNewAccount:user password:pass error:&error];
    
    if (error) {
        NSLog(@"\r\n\r\n register error : %@", error);
    } else {
        NSLog(@"register success.");
    }
    
    return status;
}

#pragma mark - 好友关系

- (void)loginEaseMobAsync {
    
    if (![self loginCheck]) {
        return;
    }
    
    BOOL isAutoLogin = [self.easeMob.chatManager isAutoLoginEnabled];
    if (isAutoLogin) {
        YOSLog(@"\r\n\r\n\r\n --- auto login --- \r\n\r\n\r\n");
        return;
    }
    
    YOSLog(@"\r\n\r\n\r\n现在登录的用户是 %@\r\n\r\n\r\n", self.userInfoModel.hx_user);
    
    NSString *user = self.userInfoModel.hx_user;
    NSString *pass = self.userInfoModel.hx_pwd;
    
    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:user password:pass completion:^(NSDictionary *loginInfo, EMError *error) {
        
        if (!error && loginInfo) {
            YOSLog(@"login success");
            // 设置自动登录
            [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
            [self getBuddyListAsync];
            
            [self whetherShowRedDot];
            
            [self setupAPNs];
        } else {
            YOSLog(@"login failure");
        }
        
    } onQueue:nil];
}

- (BOOL)loginEaseMobSync {
    
    if (![self loginCheck]) {
        return NO;
    }
    
    YOSLog(@"\r\n\r\n\r\n现在登录的用户是 %@\r\n\r\n\r\n", self.userInfoModel.hx_user);
    
    NSString *user = self.userInfoModel.hx_user;
    NSString *pass = self.userInfoModel.hx_pwd;
    
    EMError *error = nil;
    NSDictionary *loginInfo = [[EaseMob sharedInstance].chatManager loginWithUsername:user password:pass error:&error];
    if (!error && loginInfo) {
        YOSLog(@"login success");
        // 设置自动登录
        [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
        
        [self getBuddyListAsync];
        
        [self whetherShowRedDot];
        
        [self setupAPNs];
        
        return YES;
    } else {
        YOSLog(@"login failure");
        
        return NO;
    }
    
}

/**
 *  退出登录分两种类型：主动退出登录和被动退出登录。
 *
    主动退出登录：调用SDK的退出接口；
 
    被动退出登录： 1、 正在登陆的账号在另一台设备上登陆； 2、 正在登陆的账号被从服务器端删除。
 
    退出 提供了三种方法。
 
    logoffWithUnbindDeviceToken：是否解除device token的绑定，在被动退出时传NO，在主动退出时传YES.
 *
 *  @param status
 */
- (void)logoffWithUnbindDeviceToken:(BOOL)status {
    
    [self.easeMob.chatManager asyncLogoffWithUnbindDeviceToken:status completion:^(NSDictionary *info, EMError *error) {
        if (!error) {
            NSLog(@"退出成功");
            self.buddyList = nil;
            self.blockedList = nil;
            self.buddyListInMemory = nil;
            self.blockedListInMemory = nil;
        } else {
            NSLog(@"退出失败 error : %@ info : %@", error, info);
        }
    } onQueue:nil];
    
}

- (BOOL)logoffSyncWithUnbindDeviceToken:(BOOL)status {
    EMError *error = nil;
    NSDictionary *info = [[EaseMob sharedInstance].chatManager logoffWithUnbindDeviceToken:status error:&error];
    if (!error) {
        NSLog(@"退出成功");
        self.buddyList = nil;
        self.blockedList = nil;
        self.buddyListInMemory = nil;
        self.blockedListInMemory = nil;
    } else {
        NSLog(@"退出失败 error : %@ info : %@", error, info);
    }
    
    return (BOOL)(!error);
}

- (BOOL)isFriendWithUser:(NSString *)user {
    __block BOOL status = NO;
    [self.buddyList enumerateObjectsUsingBlock:^(EMBuddy *obj, NSUInteger idx, BOOL *stop) {
        
        if ([obj.username isEqualToString:user]) {
            status = YES;
            *stop = YES;
        }
        
    }];
    
    return status;
}

- (BOOL)addBuddy:(NSString *)userName message:(NSString *)message {
    
    if (![self loginCheck]) {
        return NO;
    }
    
    EMError *error = nil;
    BOOL status = [[EaseMob sharedInstance].chatManager addBuddy:userName message:message error:&error];
    
    if (error) {
        YOSLog(@"\r\n\r\n添加好友出错: %@", error);
    } else {
        YOSLog(@"\r\n\r\n添加好友成功");
    }
    
    return status;
}

/** 获取好友[异步] */
- (void)getBuddyListAsync {
    
    if (![self loginCheck]) {
        return;
    }
    
    [[EaseMob sharedInstance].chatManager asyncFetchBuddyListWithCompletion:^(NSArray *buddyList, EMError *error) {
        if (!error) {
            YOSLog(@"获取好友成功 -- %@",buddyList);
        } else {
            YOSLog(@"获取好友出错 : %@", error);
        }
        
        self.buddyList = buddyList;
        
    } onQueue:nil];
}

/** 获取好友[同步] */
- (NSArray *)getBuddyListSync {
    
    if (![self loginCheck]) {
        return nil;
    }
    
    EMError *error = nil;
    NSArray *buddyList = [[EaseMob sharedInstance].chatManager fetchBuddyListWithError:&error];
    
    self.buddyList = buddyList;
    
    if (!error) {
        YOSLog(@"获取成功 -- %@",buddyList);
    } else {
        YOSLog(@"获取好友出错 : %@", error);
    }
    
    // 删除相互发送好友请求而添加为好友的行为 对应yos_buddyrequest
    // 对应的数据[因为没有事件触发, 所以在这里操作]
    
    static NSInteger times = 2;
    
    if (times--) {
        NSString *current_username = self.userInfoModel.hx_user;
        
        [buddyList enumerateObjectsUsingBlock:^(EMBuddy *obj, NSUInteger idx, BOOL *stop) {
            
            [[YOSDBManager sharedManager] deleteBuddyRequestWithCurrentUser:current_username buddy:obj.username];
            
        }];
        
    }
    
    return buddyList;
}

- (void)getBlockedListSync {
    
    if (![self loginCheck]) {
        return;
    }
    
    EMError *error = nil;
    NSArray *blockedList = [[EaseMob sharedInstance].chatManager fetchBlockedList:&error];
    
    self.blockedList = blockedList;
    
    if (!error) {
        YOSLog(@"获取黑名单成功 -- %@",blockedList);
    } else {
        YOSLog(@"获取黑名单失败 -- %@", error);
    }
}

- (void)getBlockedListAsync {
    
    if (![self loginCheck]) {
        return;
    }
    
    [[EaseMob sharedInstance].chatManager asyncFetchBlockedListWithCompletion:^(NSArray *blockedList, EMError *error) {
        if (!error) {
            NSLog(@"获取黑名单成功 -- %@",blockedList);
            self.blockedList = blockedList;
        } else {
            YOSLog(@"获取黑名单失败 -- %@", error);
        }
    } onQueue:nil];
    
}

- (BOOL)acceptBuddy:(NSString *)username {
    
    if (![self loginCheck]) {
        return NO;
    }
    
    EMError *error = nil;
    BOOL isSuccess = [[EaseMob sharedInstance].chatManager acceptBuddyRequest:username error:&error];
    
    if (isSuccess && !error) {
        NSLog(@"发送同意成功");
    } else {
        YOSLog(@"接受好友请求失败 : %@", error);
    }
    
    return isSuccess;
}

- (BOOL)rejuctBuddy:(NSString *)username reason:(NSString *)reason {
    
    if (![self loginCheck]) {
        return NO;
    }
    
    EMError *error = nil;
    BOOL isSuccess = [[EaseMob sharedInstance].chatManager rejectBuddyRequest:username reason:reason error:&error];
    
    if (isSuccess && !error) {
        NSLog(@"发送拒绝好友成功");
    } else {
        YOSLog(@"拒绝好友请求失败 : %@", error);
    }
    
    return isSuccess;
}

- (NSArray *)getNewestBuddyList {
    NSArray *buddyList = self.buddyList;
    
    if (!buddyList) {
        buddyList = [self getBuddyListSync];
    }
    
    if (!buddyList) {
        buddyList = [NSMutableArray array];
    }
    
    return buddyList;
}

- (BOOL)removeBuddy:(NSString *)username {
    
    if (![self loginCheck]) {
        return NO;
    }
    
    EMError *error = nil;
    // 删除好友
    BOOL isSuccess = [[EaseMob sharedInstance].chatManager removeBuddy:username removeFromRemote:YES error:&error];
    
    if (isSuccess && !error) {
        YOSLog(@"删除好友成功");
    } else {
        YOSLog(@"删除好友失败 : %@", error);
    }
    
    return isSuccess;
}

- (BOOL)addBuddyToBlock:(NSString *)username {
    
    if (![self loginCheck]) {
        return NO;
    }
    
    EMError *error = [[EaseMob sharedInstance].chatManager blockBuddy:username relationship:eRelationshipBoth];
    
    if (!error) {
        YOSLog(@"添加黑名单成功");
    } else {
        YOSLog(@"添加黑名单失败 : %@", error);
    }
    
    return (BOOL)(!error);
}

- (BOOL)removeBuddyToBlock:(NSString *)username {
    
    if (![self loginCheck]) {
        return NO;
    }
    
    EMError *error = [[EaseMob sharedInstance].chatManager unblockBuddy:username];
    if (!error) {
        YOSLog(@"移除黑名单成功");
    } else {
        YOSLog(@"移除黑名单失败 : %@", error);
    }
    
    return (BOOL)(!error);
}

#pragma mark - 创建/销毁回话

- (__weak EMConversation *)conversationForChatter:(NSString *)username {
    
    if (![self loginCheck]) {
        return nil;
    }
    
    if (!username.length) {
        return nil;
    }
    
    EMConversation *conversation = self.conversations[username];
    
    if (!conversation) {
        conversation = [[EaseMob sharedInstance].chatManager conversationForChatter:username conversationType:eConversationTypeChat];
    }
    
    self.conversations[username] = conversation;
    
    __weak EMConversation *con = conversation;
    
    return con;
}

- (void)removeConversationByChatter:(NSString *)username {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        BOOL status = [[EaseMob sharedInstance].chatManager removeConversationByChatter:username deleteMessages:NO append2Chat:YES];
        
        if (status) {
            [self.conversations removeObjectForKey:username];
        }
    });
    
}

- (void)removeAllConversations {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        BOOL status = [[EaseMob sharedInstance].chatManager removeAllConversationsWithDeleteMessages:NO append2Chat:YES];
        
        if (status) {
            [self.conversations removeAllObjects];
        }
    });
    
}

#pragma mark - 发送消息

- (EMMessage *)sendMessageToUser:(NSString *)username message:(NSString *)message {
    return [ChatSendHelper sendTextMessageWithString:message toUsername:username isChatGroup:NO requireEncryption:NO ext:nil];
}

#pragma mark - getter & setter

- (EaseMob *)easeMob {
    return [EaseMob sharedInstance];
}

- (YOSUserInfoModel *)userInfoModel {
    return [YOSWidget getCurrentUserInfoModel];
}

/** 该方法比较特殊，只有在您之前获取过好友列表的情况下才会有值，且不能保证最新。 */
- (NSArray *)buddyListInMemeory {
    return [self.easeMob.chatManager buddyList];
}

- (NSArray *)blockedListInMemory {
    return [self.easeMob.chatManager blockedList];
}

- (void)setBuddyList:(NSArray *)buddyList {
    _buddyList = buddyList;
    
    YOSPostNotification(YOSNotificationUpdateBuddyList);
}

- (NSMutableDictionary *)conversations {
    if (!_conversations) {
        _conversations = [NSMutableDictionary dictionary];
    }
    
    return _conversations;
}

#pragma mark - EMChatManagerDelegate

- (void)willAutoLoginWithInfo:(NSDictionary *)loginInfo error:(EMError *)error {
    NSLog(@"%s", __func__);
    YOSLog(@"用户将要进行自动登录操作的回调");
}

- (void)didAutoLoginWithInfo:(NSDictionary *)loginInfo error:(EMError *)error {
    NSLog(@"%s", __func__);
    YOSLog(@"用户自动登录完成后的回调");
    if (!error) {
        [self getBuddyListAsync];
        
        YOSPostNotification(YOSNotificationLogin);
        
        [self whetherShowRedDot];
        
        [self setupAPNs];
    }

}

- (void)didLoginWithInfo:(NSDictionary *)loginInfo error:(EMError *)error {
    NSLog(@"%s", __func__);
    YOSLog(@"登陆成功。");
    if (!error) {
        [self getBuddyListAsync];
        
        [self whetherShowRedDot];
    }
}

- (void)didReceiveBuddyRequest:(NSString *)username
                       message:(NSString *)message {
    
    [[YOSDBManager sharedManager] updateBuddyRequestWithCurrentUser:self.userInfoModel.hx_user buddy:username message:message];
    
    YOSPostNotification(YOSNotificationUpdateBuddyRequest);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:YOSNotificationShowRedDot object:nil userInfo:@{@"index": @1}];
}

/*!
 @method
 @brief 将要发起自动重连操作时发送该回调
 @discussion
 @result
 */
- (void)willAutoReconnect {
    NSLog(@"%s", __func__);
    YOSLog(@"将要发起自动重连操作时发送该回调");
}

/*!
 @method
 @brief 自动重连操作完成后的回调（成功的话，error为nil，失败的话，查看error的错误信息）
 @discussion
 @result
 */
- (void)didAutoReconnectFinishedWithError:(NSError *)error {
    NSLog(@"%s", __func__);
    YOSLog(@"自动重连操作完成后的回调（成功的话，error为nil，失败的话，查看error的错误信息）");
}

/*!
 @method
 @brief 好友请求被接受时的回调
 @discussion
 @param username 之前发出的好友请求被用户username接受了
 */
- (void)didAcceptedByBuddy:(NSString *)username {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
    
        [self getBuddyListSync];
        
        [[YOSDBManager sharedManager] deleteBuddyRequestWithCurrentUser:self.userInfoModel.hx_user buddy:username];
        
        EMMessage *msg = [[YOSEaseMobManager sharedManager] sendMessageToUser:username message:@"已添加您为好友~"];
        
        NSString *update_time = [NSString stringWithFormat:@"%lli", msg.timestamp / 1000];
        
        [[YOSDBManager sharedManager] updateNewestChatWithCurrentUser:msg.from buddy:msg.to update_time:update_time];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:YOSNotificationReceiveMessage object:[YOSEaseMobManager class] userInfo:@{@"message":msg}];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:YOSNotificationShowRedDot object:nil userInfo:@{@"index": @1}];
        });
        
    });
    
}

/*!
 @method
 @brief 好友请求被拒绝时的回调
 @discussion
 @param username 之前发出的好友请求被用户username拒绝了
 */
- (void)didRejectedByBuddy:(NSString *)username {
    [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"%@已拒绝添加您为好友~", username] maskType:SVProgressHUDMaskTypeClear];
}

/*!
 @method
 @brief 将好友加到黑名单完成后的回调
 @discussion
 @param buddy    加入黑名单的好友
 @param pError   错误信息
 */
- (void)didBlockBuddy:(EMBuddy *)buddy error:(EMError *)pError {
    YOSLog(@"添加黑名单完成的回调");
}

/*!
 @method
 @brief 将好友移出黑名单完成后的回调
 @discussion
 @param buddy    移出黑名单的好友
 @param pError   错误信息
 */
- (void)didUnblockBuddy:(EMBuddy *)buddy error:(EMError *)pError {
    YOSLog(@"移除黑名单完成的回调");
}

/*!
 @method
 @brief 收到消息时的回调
 @param message      消息对象
 @discussion 当EMConversation对象的enableReceiveMessage属性为YES时, 会触发此回调
 针对有附件的消息, 此时附件还未被下载.
 附件下载过程中的进度回调请参考didFetchingMessageAttachments:progress:,
 下载完所有附件后, 回调didMessageAttachmentsStatusChanged:error:会被触发
 */
- (void)didReceiveMessage:(EMMessage *)message {
    NSLog(@"%s", __func__);
    YOSLog(@"\r\n\r\n\r\nreceive message : %@\r\n\r\n\r\n", message);
    
    // 发送本地通知
    if ([UIApplication sharedApplication].applicationState != UIApplicationStateActive) {
        
        NSString *json = [[YOSDBManager sharedManager] getUserInfoJsonWithUsername:message.from];
        
        NSDictionary *dict = [json yos_toJSONObject];
        
        YOSUserInfoModel *userInfoModel = [[YOSUserInfoModel alloc] initWithDictionary:dict error:nil];
        
        NSString *nickname = userInfoModel.nickname;
        
        if (!nickname.length) {
            nickname = @"新消息";
        }
        
        NSDate *date = [[NSDate new] dateByAddingTimeInterval:1.5];
        
        NSString *msg = [NSString stringWithFormat:@"%@: %@", nickname, message.yos_message];
        
        [[YOSLocalNotificationManager sharedManager] addNotificationWithDate:date message:msg];
    }
    
    NSString *update_time = [NSString stringWithFormat:@"%lli", message.timestamp / 1000];
    
    [[YOSDBManager sharedManager] updateNewestChatWithCurrentUser:message.to buddy:message.from update_time:update_time];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:YOSNotificationReceiveMessage object:[YOSEaseMobManager class] userInfo:@{@"message":message}];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:YOSNotificationShowRedDot object:nil userInfo:@{@"index": @1}];
}

/*!
 @method
 @brief 接收到离线非透传消息的回调
 @discussion
 @param offlineMessages 接收到的离线列表
 @result
 */
- (void)didReceiveOfflineMessages:(NSArray *)offlineMessages {
    NSLog(@"%s", __func__);
    
    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
    [offlineMessages enumerateObjectsUsingBlock:^(EMMessage *obj, NSUInteger idx, BOOL *stop) {
        
        NSString *username = obj.from;
        
        NSMutableArray *temp = mDict[username];
        if (!temp) {
            temp = [NSMutableArray array];
        }
        
        [temp addObject:obj];
        
    }];
    
    [mDict enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSMutableArray *obj, BOOL *stop) {
        
        [obj sortUsingComparator:^NSComparisonResult(EMMessage *obj1, EMMessage *obj2) {
            
            long long num1 = obj1.timestamp;
            long long num2 = obj2.timestamp;
            
            if (num1 > num2) {
                return NSOrderedDescending;
            } else {
                return NSOrderedAscending;
            }
            
        }];
        
        EMMessage *lastMessage = [obj firstObject];
        
        NSString *update_time = [NSString stringWithFormat:@"%llx", lastMessage.timestamp / 1000];
        
        [[YOSDBManager sharedManager] updateNewestChatWithCurrentUser:lastMessage.to buddy:lastMessage.from update_time:update_time];
        
    }];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:YOSNotificationShowRedDot object:nil userInfo:@{@"index": @1}];
    
}

/*!
 @method
 @brief 当前登录账号在其它设备登录时的通知回调
 @discussion
 @result
 */
- (void)didLoginFromOtherDevice {
    
    [SVProgressHUD showInfoWithStatus:@"账户在其他手机登录~" maskType:SVProgressHUDMaskTypeClear];
    
    [self logoffWithUnbindDeviceToken:YES];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[GVUserDefaults standardUserDefaults] logout];
        YOSPostNotification(YOSNotificationLogout);
    });
    
}

#pragma mark - config methods

- (void)registerWithApplication:(UIApplication *)application launchOptions:(NSDictionary *)launchOptions {
    
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    [[EaseMob sharedInstance] registerSDKWithAppKey:YOSEaseMobAppKey apnsCertName:YOSEaseMobCertName];
    [[EaseMob sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
}

- (void)whetherShowRedDot {
    NSArray *buddyLists = [[YOSDBManager sharedManager] getBuddyListWithUsername:self.userInfoModel.hx_user];
    
    if (buddyLists.count) {
        [[NSNotificationCenter defaultCenter] postNotificationName:YOSNotificationShowRedDot object:nil userInfo:@{@"index": @1}];
    }
}

- (void)setupAPNs {
    NSString *nickname = self.userInfoModel.nickname;
    
    if (!nickname.length) {
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        EMPushNotificationOptions *options = [[EaseMob sharedInstance].chatManager pushNotificationOptions];
        
        options.displayStyle = ePushNotificationDisplayStyle_messageSummary;

        [self.easeMob.chatManager updatePushOptions:options error:nil];
        
        [self.easeMob.chatManager setApnsNickname:nickname];
    });
    
}

@end
