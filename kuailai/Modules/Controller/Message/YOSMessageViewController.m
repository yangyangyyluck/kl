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

    [self setupSubviews];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateBuddyRequest) name:YOSNotificationUpdateBuddyRequest object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveMessage:) name:YOSNotificationReceiveMessage object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetUnReadMessage:) name:YOSNotificationResetUnReadMessage object:nil];

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
    
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messageModels.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%s", __func__);
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    UIView *father = cell.superview;
    
    NSLog(@"father : %@", father);
    
    [self.tableView reloadData];
    
    return;
    
    if (indexPath.row == 0) {
        YOSBuddyRequestViewController *buddyVC = [YOSBuddyRequestViewController new];
        
        [self.navigationController pushViewController:buddyVC animated:YES];
    } else {
        YOSSendMessagesViewController *sendVC = [YOSSendMessagesViewController new];
        sendVC.otherUserInfoModel = self.userInfoModels[indexPath.row];
        
        [self.navigationController pushViewController:sendVC animated:YES];
    }
    
}

#pragma mark - UITableViewDataSource 

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

#pragma mark - event response

- (void)clickRightItem:(UIButton *)item {
    
    self.messageModels = nil;
    
    YOSAddBuddyViewController *addVC = [YOSAddBuddyViewController new];
    
    [self.navigationController pushViewController:addVC animated:NO];
    
    [self.tableView reloadData];
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
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else {
        [self.messageModels addObject:model];
        [self.userInfoModels addObject:userInfoModel];
        [self.tableView reloadData];
    }

}

- (YOSMessageModel *)messageModelWithUserInfoModel:(YOSUserInfoModel *)userInfoModel message:(EMMessage *)message {
    
    EMConversation *con = [[YOSEaseMobManager sharedManager] conversationForChatter:message.from];
    
    YOSMessageModel *model = [YOSMessageModel new];
    
    model.avatar = userInfoModel.avatar;
    model.name = userInfoModel.nickname;
    model.count = YOSInt2String([con unreadMessagesCount]);
    model.message = [message yos_message];
    model.hx_user = userInfoModel.hx_user;
    
    if (![YOSWidget isTodayWithTimeStamp:[NSString stringWithFormat:@"%lli", message.timestamp]]) {
        model.date = [YOSWidget dateStringWithTimeStamp:[NSString stringWithFormat:@"%lli", message.timestamp] Format:@"MM-dd"];
    } else {
        model.date = [YOSWidget dateStringWithTimeStamp:[NSString stringWithFormat:@"%lli", message.timestamp] Format:@"HH:mm:ss"];
    }
    
    BOOL status = [[YOSEaseMobManager sharedManager] isFriendWithUser:userInfoModel.hx_user];
    
    if (status) {
        model.status = @"";
    } else {
        model.status = @"未添加";
    }
    
    return model;
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

@end
