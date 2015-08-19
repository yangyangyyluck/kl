//
//  YOSMessageViewController.m
//  kuailai
//
//  Created by yangyang on 15/7/16.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSMessageViewController.h"
#import "YOSAddBuddyViewController.h"
#import "YOSBuddyRequestViewController.h"
#import "YOSSendMessagesViewController.h"
#import "YOSLoginViewController.h"
#import "YOSBaseNavigationViewController.h"
#import "YOSMessageCell.h"
#import "YOSAddBuddyCell.h"

#import "YOSMessageModel.h"
#import "YOSUserInfoModel.h"

#import "YOSUserGetUserByHxRequest.h"

#import "Masonry.h"
#import "YOSDBManager.h"
#import "YOSWidget.h"
#import "EaseMob.h"
#import "EMMessage+YOSAdditions.h"
#import "YOSEaseMobManager.h"
#import "NSString+YOSAdditions.h"
#import "SVProgressHUD+YOSAdditions.h"
#import "GVUserDefaults+YOSProperties.h"

@interface YOSMessageViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *messageModels;

@property (nonatomic, strong) NSMutableArray *userInfoModels;

@property (nonatomic, strong) NSMutableDictionary *hx_users;

@end

@implementation YOSMessageViewController {

}

#pragma mark - life cycles

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavTitle:@"消息"];
    
    [self setupRightButtonWithTitle:@"添加好友"];
    
    if ([YOSWidget isLogin] && [YOSEaseMobManager sharedManager].isHxLogin) {
        
        [self login];
        
    } else if([YOSWidget isLogin] && ![YOSEaseMobManager sharedManager].isHxLogin) {
        
        [self waitHXLogin];
        
    } else {
        [self logout];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateBuddyRequest) name:YOSNotificationUpdateBuddyRequest object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveMessage:) name:YOSNotificationReceiveMessage object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetUnReadMessage:) name:YOSNotificationResetUnReadMessage object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(login) name:YOSNotificationLogin object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logout) name:YOSNotificationLogout object:nil];

}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupSubviews {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 100, 100) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 70.0f;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_tableView];
    
    _tableView.frame = CGRectMake(0, 64, 320, 400);
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero).priorityLow();
    }];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YOSMessageCell *cell = [YOSMessageCell cellWithTableView:tableView];
    
    // 这里代码有时间再重构， 设置fatherVC 一定要在 设置model前
    cell.fatherVC = self.view;
    cell.messageModel = self.messageModels[indexPath.row];
    cell.userInfoModel = self.userInfoModels[indexPath.row];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messageModels.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%s", __func__);
    
    if (indexPath.row == 0) {
        YOSBuddyRequestViewController *buddyVC = [YOSBuddyRequestViewController new];
        
        [self.navigationController pushViewController:buddyVC animated:YES];
    } else {
        YOSSendMessagesViewController *sendVC = [YOSSendMessagesViewController new];
        sendVC.otherUserInfoModel = self.userInfoModels[indexPath.row];
        
        [self.navigationController pushViewController:sendVC animated:YES];
    }
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row != 0) {
        return YES;
    } else {
        return NO;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSUInteger idx = indexPath.row;
        YOSUserInfoModel *deleteUserInfoModel = self.userInfoModels[idx];
        
        [self.messageModels removeObjectAtIndex:idx];
        [self.userInfoModels removeObjectAtIndex:idx];
        
        EMConversation *con = [[YOSEaseMobManager sharedManager] conversationForChatter:deleteUserInfoModel.hx_user];
        
        [con removeAllMessages];
        
        [self.tableView reloadData];
        
    }
}

#pragma mark - event response

- (void)clickRightItem:(UIButton *)item {
    
    self.messageModels = nil;
    
    YOSAddBuddyViewController *addVC = [YOSAddBuddyViewController new];
    
    [self.navigationController pushViewController:addVC animated:NO];
    
    [self.tableView reloadData];
}

#pragma mark - network

- (void)loadNewestChat {
    
    NSArray *usernames = [[YOSDBManager sharedManager] getNewestChatUsernames];
    
    if (!usernames.count) {
        return;
    }
    
    NSMutableArray *noCachedUsernames = [NSMutableArray array];
    [usernames enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
        
        NSString *jsonStr = [[YOSDBManager sharedManager] getUserInfoJsonWithUsername:obj];
        NSDictionary *userInfoDict = [jsonStr yos_toJSONObject];
        YOSUserInfoModel *userInfoModel = [[YOSUserInfoModel alloc] initWithDictionary:userInfoDict error:nil];
        
        if (!userInfoModel) {
            [noCachedUsernames addObject:obj];
        }
        
    }];
    
    if (noCachedUsernames.count) {
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
        YOSUserGetUserByHxRequest *request = [[YOSUserGetUserByHxRequest alloc] initWithHXUsers:noCachedUsernames];
        
        [request startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
            if ([request yos_checkResponse]) {
                NSLog(@"%s", __func__);
                
                NSArray *data = request.yos_data;
                
                [data enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
                    
                    NSString *jsonStr = [YOSWidget jsonStringWithJSONObject:obj];
                    
                    [[YOSDBManager sharedManager] updateUserInfoWithUsername:obj[@"hx_user"] json:jsonStr];
                    
                }];
                
                [self setupOriginMessagesWithUsernames:usernames];
                
            }
        } failure:^(YTKBaseRequest *request) {
            [request yos_checkResponse];
        }];
    } else {
        
        [self setupOriginMessagesWithUsernames:usernames];
    }

}

- (void)setupOriginMessagesWithUsernames:(NSArray *)usernames {
    
    NSUInteger isPublic = [GVUserDefaults standardUserDefaults].isPublic;
    
    if (isPublic == 2) {
        
        NSMutableArray *mUsernames = [usernames mutableCopy];
        
        NSArray *buddyLists = [[YOSEaseMobManager sharedManager] getNewestBuddyList];
        
        NSArray *buddyArr = [buddyLists valueForKeyPath:@"username"];
        
        [usernames enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
            if (![buddyArr containsObject:obj]) {
                [mUsernames removeObject:obj];
            }
        }];
        
        usernames = [mUsernames copy];
    }
    
    [usernames enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
        
        NSString *jsonStr = [[YOSDBManager sharedManager] getUserInfoJsonWithUsername:obj];
        NSDictionary *userInfoDict = [jsonStr yos_toJSONObject];
        YOSUserInfoModel *userInfoModel = [[YOSUserInfoModel alloc] initWithDictionary:userInfoDict error:nil];
        
        if (userInfoModel) {
            EMConversation *con = [[YOSEaseMobManager sharedManager] conversationForChatter:obj];
            EMMessage *message = [[con loadNumbersOfMessages:1 before:[NSDate date].timeIntervalSince1970 * 1000] lastObject];
            
//            NSLog(@"setupOriginMessagesWithUsernames, con is %@, msg is %@",con, message);
            
            YOSMessageModel *model = [self messageModelWithUserInfoModel:userInfoModel message:message];
            
            if (con && model) {
                [self.userInfoModels addObject:userInfoModel];
                self.hx_users[obj] = userInfoModel;
                [self.messageModels addObject:model];
                
                [[YOSEaseMobManager sharedManager] removeConversationByChatter:obj];
            }
        
        }
        
        [self.tableView reloadData];
        
    }];
    
}

#pragma mark - deal notification

- (void)updateBuddyRequest {
    NSLog(@"%s", __func__);
 
    [self.messageModels removeObjectAtIndex:0];
    
    YOSMessageModel *model = [YOSMessageModel new];
    model.avatar = @"想认识我的人";
    model.name = @"想认识我的人";
    
    YOSUserInfoModel *userInfoModel = [YOSWidget getCurrentUserInfoModel];
    
    NSArray *buddyLists = [[YOSDBManager sharedManager] getBuddyListWithUsername:userInfoModel.username];
    
    if (!buddyLists.count) {
        model.message = @"[暂无好友申请]";
    } else {
        model.message = [NSString stringWithFormat:@"[%zi位想认识我的人]", buddyLists.count];
    }
    
    [self.messageModels insertObject:model atIndex:0];
    
    [self.tableView reloadData];
}

- (void)receiveMessage:(NSNotification *)noti {
    
    EMMessage *message = noti.userInfo[@"message"];
    
    NSString *from = message.from;
    
    YOSUserInfoModel *currentUserInfoModel = [YOSWidget getCurrentUserInfoModel];
    
    if ([from isEqualToString:currentUserInfoModel.hx_user]) {
        from = message.to;
    }
    
    // 如果拒绝陌生人聊天，则不现实陌生人消息
    NSUInteger isPublic = [GVUserDefaults standardUserDefaults].isPublic;
    
    if (isPublic == 2) {
        
        BOOL status = [[YOSEaseMobManager sharedManager] isFriendWithUser:from];
        
        if (!status) {
            return;
        }
        
    }
    
    YOSUserInfoModel *userInfoModel = self.hx_users[from];
    
    if (!userInfoModel) {
        NSString *jsonStr = [[YOSDBManager sharedManager] getUserInfoJsonWithUsername:from];
        NSDictionary *userInfoDict = [jsonStr yos_toJSONObject];
        userInfoModel = [[YOSUserInfoModel alloc] initWithDictionary:userInfoDict error:nil];
    }
    
    if (!userInfoModel) {
        YOSUserGetUserByHxRequest *request = [[YOSUserGetUserByHxRequest alloc] initWithHXUsers:@[from]];
        
        [request startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
            if ([request yos_checkResponse]) {
                NSLog(@"%s", __func__);
                
                YOSUserInfoModel *userInfoModel = [[YOSUserInfoModel alloc] initWithDictionary:request.yos_data[0] error:nil];
                
                NSString *jsonStr = [YOSWidget jsonStringWithJSONObject:request.yos_data[0]];
                
                [[YOSDBManager sharedManager] updateUserInfoWithUsername:userInfoModel.hx_user json:jsonStr];
                
                YOSMessageModel *model = [self messageModelWithUserInfoModel:userInfoModel message:message];
                
                self.hx_users[from] = userInfoModel;
                
                [self refreshTableViewCellWithMessageModel:model userInfoModel:userInfoModel];
                
            }
        } failure:^(YTKBaseRequest *request) {
            [request yos_checkResponse];
        }];
    } else {
        
        self.hx_users[from] = userInfoModel;
        
        YOSMessageModel *model = [self messageModelWithUserInfoModel:userInfoModel message:message];
        
        [self refreshTableViewCellWithMessageModel:model userInfoModel:userInfoModel];
    }
}

- (void)resetUnReadMessage:(NSNotification *)noti {
    YOSUserInfoModel *userInfoModel = noti.userInfo[@"userInfoModel"];
    
    // 是否已经存在该好友消息的cell
    
    __block BOOL hasCell = NO;
    __block NSUInteger index = 0;
    
    [self.userInfoModels enumerateObjectsUsingBlock:^(YOSUserInfoModel *obj, NSUInteger idx, BOOL *stop) {
        
        // idx = 0 是 @"", 所以从idx >= 1 才是正确的YOSUserInfoModel
        if (idx >= 1) {
            
            if ([obj isEqual:userInfoModel]) {
                hasCell = YES;
                index = idx;
                *stop = YES;
            }
            
        }
        
    }];
    
    if (hasCell) {
        YOSMessageModel *model = self.messageModels[index];
        model.count = 0;
        [self.messageModels replaceObjectAtIndex:index withObject:model];
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark - private methods



- (void)refreshTableViewCellWithMessageModel:(YOSMessageModel *)model userInfoModel:(YOSUserInfoModel *)userInfoModel {
    
    // 是否已经存在该好友消息的cell
    
    __block BOOL hasCell = NO;
    __block NSUInteger index = 0;
    
    [self.userInfoModels enumerateObjectsUsingBlock:^(YOSUserInfoModel *obj, NSUInteger idx, BOOL *stop) {
        
        // idx = 0 是 @"", 所以从idx >= 1 才是正确的YOSUserInfoModel
        if (idx >= 1) {
            
            if ([obj isEqual:userInfoModel]) {
                hasCell = YES;
                index = idx;
                *stop = YES;
            }
            
        }
        
    }];
    
    if (hasCell) {
        [self.messageModels replaceObjectAtIndex:index withObject:model];
        [self.messageModels exchangeObjectAtIndex:1 withObjectAtIndex:index];
        [self.userInfoModels exchangeObjectAtIndex:1 withObjectAtIndex:index];
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:1 inSection:0];
        NSIndexPath *indexPath2 = [NSIndexPath indexPathForItem:index inSection:0];

        [self.tableView reloadRowsAtIndexPaths:@[indexPath, indexPath2] withRowAnimation:UITableViewRowAnimationFade];
    } else {
        [self.messageModels insertObject:model atIndex:1];
        [self.userInfoModels insertObject:userInfoModel atIndex:1];
        
        [self.tableView reloadData];
    }

}

- (YOSMessageModel *)messageModelWithUserInfoModel:(YOSUserInfoModel *)userInfoModel message:(EMMessage *)message {
    
    EMConversation *con = [[YOSEaseMobManager sharedManager] conversationForChatter:message.from];
    
//    NSLog(@"messageModelWithUserInfoModel, con is %@, msg is %@",con, message);
    
    YOSMessageModel *model = [YOSMessageModel new];
    
    model.avatar = userInfoModel.avatar;
    model.name = userInfoModel.nickname;
    model.count = YOSInt2String([con unreadMessagesCount]);
    model.message = [message yos_message];
    model.hx_user = userInfoModel.hx_user;
    
    if (![YOSWidget isTodayWithTimeStamp:[NSString stringWithFormat:@"%lli", message.timestamp / 1000]]) {
        model.date = [YOSWidget dateStringWithTimeStamp:[NSString stringWithFormat:@"%lli", message.timestamp / 1000] Format:@"MM-dd"];
    } else {
        model.date = [YOSWidget dateStringWithTimeStamp:[NSString stringWithFormat:@"%lli", message.timestamp / 1000] Format:@"HH:mm:ss"];
    }
    
    BOOL status = [[YOSEaseMobManager sharedManager] isFriendWithUser:userInfoModel.hx_user];
    
    if (status) {
        model.status = @"";
    } else {
        model.status = @"未添加";
    }
    
    return model;
}

- (void)login {
    
    [self setupSubviews];
    
    _tableView.hidden = NO;
    _userInfoModels = nil;
    _messageModels = nil;
    
    [self loadNewestChat];
}

- (void)waitHXLogin {
    _tableView.hidden = YES;
    
    [self showDefaultMessage:@"正在登录中.." tappedBlock:nil isShowHUD:YES];
    
    NSTimer *timer = [NSTimer timerWithTimeInterval:20 target:self selector:@selector(logout) userInfo:nil repeats:NO];
    
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
}

- (void)logout {
    _tableView.hidden = YES;
    
    YOSWSelf(weakSelf);
    [self showDefaultMessage:@"还未登录,点击登录" tappedBlock:^{
        
        YOSLoginViewController *loginVC = [YOSLoginViewController new];
        YOSBaseNavigationViewController *navVC = [[YOSBaseNavigationViewController alloc] initWithRootViewController:loginVC];
        
        [weakSelf presentViewController:navVC animated:YES completion:nil];
        
    } isShowHUD:NO];
}

#pragma mark - getter & setter

- (NSMutableDictionary *)hx_users {
    if (!_hx_users) {
        _hx_users = [NSMutableDictionary dictionary];
    }
    
    return _hx_users;
}

- (NSMutableArray *)userInfoModels {
    if (!_userInfoModels) {
        _userInfoModels = [NSMutableArray array];
        [_userInfoModels addObject:@""];
    }
    
    return _userInfoModels;
}

- (NSMutableArray *)messageModels {
    if (!_messageModels) {
        _messageModels = [NSMutableArray array];
        
        YOSMessageModel *model = [YOSMessageModel new];
        model.avatar = @"想认识我的人";
        model.name = @"想认识我的人";
        
        YOSUserInfoModel *userInfoModel = [YOSWidget getCurrentUserInfoModel];
        
        NSArray *buddyLists = [[YOSDBManager sharedManager] getBuddyListWithUsername:userInfoModel.username];
        
        if (!buddyLists.count) {
            model.message = @"[暂无好友申请]";
        } else {
            model.message = [NSString stringWithFormat:@"[%zi位想认识我的人]", buddyLists.count];
        }
        
        [_messageModels addObject:model];
        
        
        /*
         NSUInteger num = arc4random_uniform(20) + 5;
         
         NSUInteger i = 0;
         while (i < num) {
         ++i;
         YOSMessageModel *m = [YOSMessageModel new];
         
         NSString *total = @"我啊红烧豆腐鲁昆吉里拉手看到就烦离开我就饿马桑德拉看就访问离开人间哦啥地方abcdefghijklmnopqrstuvwsyz哈噢这里立交桥0就啊啥的哦";
         
         NSMutableString *name = [NSMutableString new];
         
         for (int i = 0; i < (arc4random_uniform(10) + 1); ++i) {
         NSString *randomName = [total substringWithRange:NSMakeRange(arc4random_uniform((int)total.length), 1)];
         [name appendString:randomName];
         }
         
         m.name = name;
         
         NSString *total2 = @"郭德纲的徒弟分八科，云鹤九霄，龙腾四海。黄鹤飞，一听就是郭德纲鹤字科的徒弟。2007年在郭德纲拍摄《相声演义》的时候，现场磕头拜师，起名黄鹤飞。黄鹤飞一门心思想搞电影，在遇到郭德纲之前在各大剧组里面摸爬滚打三四年，拜师之后，依然挂念摄影机，虽然作为北漂，混得很给北漂丢脸，但依然不改初衷，光影梦想不死。";
         
         NSMutableString *message = [NSMutableString new];
         
         for (int i = 0; i < (arc4random_uniform(40) + 5); ++i) {
         NSString *randomMessage = [total2 substringWithRange:NSMakeRange(arc4random_uniform((int)total2.length), 1)];
         [message appendString:randomMessage];
         }
         
         m.message = message;
         
         if (arc4random_uniform(2)) {
         m.date = @"15/02/07";
         }
         
         if (arc4random_uniform(2)) {
         m.status = @"未添加";
         }
         
         NSUInteger random = arc4random_uniform(3);
         if (random == 0) {
         m.count = @" 99+ ";
         }
         
         if (random == 1) {
         m.count = @"25";
         }
         
         if (random == 2) {
         m.count = @"4";
         }
         
         [_messageModels addObject:m];
         
         }
         */
        
        
    }
    
    return _messageModels;
}


@end
