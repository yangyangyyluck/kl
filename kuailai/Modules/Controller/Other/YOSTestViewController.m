//
//  YOSTestViewController.m
//  kuailai
//
//  Created by yangyang on 15/7/12.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSTestViewController.h"
#import "YOSQRScanViewController.h"
#import "YOSEaseMobManager.h"
#import "YOSUserInfoViewController.h"

#import "UIImage+MDQRCode.h"
#import "Masonry.h"
#import "UITableViewCell+YOSAdditions.h"
#import "EaseMob.h"
#import "YOSWidget.h"

@interface YOSTestViewController () <UITableViewDataSource, UITableViewDelegate, EMChatManagerDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation YOSTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _tableView = [UITableView new];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 44.0;
    
    [self.view addSubview:_tableView];

    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero).priorityLow();
        make.width.mas_equalTo(YOSScreenWidth);
    }];
    
//    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [UITableViewCell cellWithTableView:tableView];
    
    cell.textLabel.text = YOSInt2String(indexPath.row);
    
    NSUInteger row = indexPath.row;
    
    if (row == 0) {
        cell.textLabel.text = @"注册";
    }
    
    if (row == 1) {
        cell.textLabel.text = @"登陆";
    }
    
    if (row == 2) {
        cell.textLabel.text = @"退出";
    }
    
    if (row == 3) {
        cell.textLabel.text = @"插入message";
    }
    
    if (row == 7) {
        cell.textLabel.text = @"send message";
    }
    
    if (row == 8) {
        cell.textLabel.text = @"userInfoModelVC";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%s", __func__);
    
    NSUInteger row = indexPath.row;
    
    if (row == 0) {
        [[YOSEaseMobManager sharedManager] registerNewAccount];
    }
    
    if (row == 1) {
        [[YOSEaseMobManager sharedManager] loginEaseMobAsync];
    }
    
    if (row == 2) {
        // 退出，传入YES，会解除device token绑定，不再收到群消息；传NO，不解除device token
        [[YOSEaseMobManager sharedManager] logoffWithUnbindDeviceToken:NO];
    }
    
    if (row == 3) {
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        YOSLog(@"path : %@", path);
        EMChatText *txt = [[EMChatText alloc] initWithText:@"test1"];
        EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithChatObject:txt];
        EMMessage *message = [[EMMessage alloc] initWithReceiver:@"8001" bodies:@[body]];
        message.messageType = eMessageTypeChat; // 设置为单聊消息
        //message.messageType = eConversationTypeGroupChat;// 设置为群聊消息
        //message.messageType = eConversationTypeChatRoom;// 设置为聊天室消息
        message.deliveryState = eMessageDeliveryState_Delivered;
        [[EaseMob sharedInstance].chatManager insertMessageToDB:message];
    }
    
    if (row == 4) {
        EMError *error = nil;
        BOOL isSuccess = [[EaseMob sharedInstance].chatManager addBuddy:@"18600950783" message:@"我想加您为好友" error:&error];
        if (isSuccess && !error) {
            NSLog(@"添加成功");
        }
    }
    
    if (row == 5) {
        [[YOSEaseMobManager sharedManager] getBuddyListSync];
        
        NSArray *arr = [YOSEaseMobManager sharedManager].buddyList;
        
        EMBuddy *buddy = arr[0];
        
        
        NSLog(@"arr %@ ", buddy.username);
    }
    
    if (row == 6) {
        EMBuddy *buddy = [EMBuddy buddyWithUsername:@"15510693558"];
        
        EMBuddyFollowState followS = buddy.followState;
        
        NSLog(@"%zi", followS);
    }
    
    if (row == 7) {
        NSUInteger random = arc4random_uniform(1000) + 5;
        [[YOSEaseMobManager sharedManager] sendMessageToUser:@"186009507831438757629" message:YOSInt2String(random)];
    }
    
    if (row == 8) {
        
        YOSUserInfoViewController *userVC = [YOSUserInfoViewController new];
        userVC.userInfoModel = [YOSWidget getCurrentUserInfoModel];
        
        [self.navigationController pushViewController:userVC animated:YES];
    }
    
}

#pragma mark - EMChatManagerDelegate

- (void)willAutoLoginWithInfo:(NSDictionary *)loginInfo error:(EMError *)error {
    NSLog(@"%s", __func__);
    YOSLog(@"用户将要进行自动登录操作的回调");
}

- (void)didAutoLoginWithInfo:(NSDictionary *)loginInfo error:(EMError *)error {
    NSLog(@"%s", __func__);
    YOSLog(@"用户自动登录完成后的回调");
}

- (void)didLoginWithInfo:(NSDictionary *)loginInfo error:(EMError *)error {
    NSLog(@"%s", __func__);
    YOSLog(@"登陆成功。");
}

- (void)didReceiveBuddyRequest:(NSString *)username
                       message:(NSString *)message {
    NSLog(@"%s", __func__);
    NSLog(@"%@ -- %@", username, message);
    [YOSWidget alertMessage:username title:message];
}

@end
