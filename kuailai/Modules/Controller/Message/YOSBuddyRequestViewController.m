//
//  YOSBuddyRequestViewController.m
//  kuailai
//
//  Created by yangyang on 15/7/28.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSBuddyRequestViewController.h"
#import "YOSBuddyRequestCell.h"

#import "YOSUserInfoModel.h"
#import "YOSMessageModel.h"

#import "YOSUserGetUserByHxRequest.h"

#import "Masonry.h"
#import "YOSDBManager.h"
#import "YOSWidget.h"

@interface YOSBuddyRequestViewController () <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *buddyMessages;

@property (nonatomic, strong) NSMutableArray *messageModels;

/** 总数据量 */
@property (nonatomic, assign) NSUInteger count;

/** 总页数 */
@property (nonatomic, assign) NSUInteger totalPage;

/** 当前页数量 */
@property (nonatomic, assign) NSUInteger currentPage;

@property (nonatomic, assign) BOOL isNoMoreData;

// UI
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation YOSBuddyRequestViewController

#pragma mark - life cycles

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupBackArrow];
    
    [self setupNavTitle:@"好友请求"];
    
    [self setupTableView];
    
    [self sendNetworkRequest];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateBuddyRequest) name:YOSNotificationUpdateBuddyRequest object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 100, 100) style:UITableViewStylePlain];
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 70.0f;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero).priorityLow();
    }];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YOSBuddyRequestCell *cell = [YOSBuddyRequestCell cellWithTableView:tableView];
    
    cell.messageModel = self.messageModels[indexPath.row];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messageModels.count;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    YOSMessageModel *messageModel = self.messageModels[indexPath.row];
    return [YOSBuddyRequestCell cellHeightWithMessageModel:messageModel];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%s", __func__);
}

#pragma mark - UITableViewDataSource

- (NSMutableArray *)messageModels {
    if (!_messageModels) {
        _messageModels = [NSMutableArray array];
        
        YOSMessageModel *model = [YOSMessageModel new];
        model.avatar = @"想认识我的人";
        model.name = @"想认识我的人";
        model.message = @"[12位想认识我的人]";
        
        [_messageModels addObject:model];
        
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
            
            for (int i = 0; i < (arc4random_uniform(40) + 25); ++i) {
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
        
    }
    
    return _messageModels;
}

#pragma mark - network

- (void)sendNetworkRequest {

    self.buddyMessages = [[YOSDBManager sharedManager] getBuddyListWithUsername:[YOSWidget getCurrentUserInfoModel].username];
    
    [self.messageModels removeAllObjects];
    
    [self.buddyMessages enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
        YOSMessageModel *messageModel = [YOSMessageModel new];
        messageModel.message = obj[@"message"];
        messageModel.hx_user = obj[@"hx_user"];
        
        [self.messageModels addObject:messageModel];
    }];
    
    NSArray *arr = [self.buddyMessages valueForKeyPath:@"hx_user"];
    
    // 没有新信息
    if (!arr.count) {
        [self.tableView reloadData];
        [self showDefaultMessage:@"目前没有好友请求哦~" tappedBlock:nil isShowHUD:NO];
        return;
    } else {
        [self hideDefaultMessage];
    }
    
    YOSUserGetUserByHxRequest *request = [[YOSUserGetUserByHxRequest alloc] initWithHXUsers:arr];
    
    [request startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        if ([request yos_checkResponse]) {
            NSLog(@"%s", __func__);
            
            NSArray *userInfoModels = [YOSUserInfoModel arrayOfModelsFromDictionaries:request.yos_data];
            
            [self.messageModels enumerateObjectsUsingBlock:^(YOSMessageModel *obj, NSUInteger idx, BOOL *stop) {
                
                [userInfoModels enumerateObjectsUsingBlock:^(YOSUserInfoModel *obj2, NSUInteger idx, BOOL *stop) {
                    
                    if ([obj2.hx_user isEqualToString:obj.hx_user]) {
                        obj.name = obj2.nickname;
                        obj.avatar = obj2.avatar;
                        
                        *stop = YES;
                    }
                    
                }];
                
            }];
            
            [self.tableView reloadData];
        }
    } failure:^(YTKBaseRequest *request) {
        [request yos_checkResponse];
    }];
    
}

#pragma mark - event response


#pragma mark - deal notification

- (void)updateBuddyRequest {
    [self sendNetworkRequest];
}

@end
