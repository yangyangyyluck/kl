//
//  YOSMyFriendsViewController.m
//  kuailai
//
//  Created by yangyang on 15/8/5.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSMyFriendsViewController.h"
#import "YOSFriendCell.h"

#import "YOSUserInfoModel.h"

#import "YOSUserGetUserByHxRequest.h"

#import "Masonry.h"
#import "YOSEaseMobManager.h"
#import "EMBuddy.h"

@interface YOSMyFriendsViewController() <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *userInfoModels;

@end

@implementation YOSMyFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupBackArrow];
    
    [self setupNavTitle:@"我的好友"];
    
    [self setupSubviews];
    
    [self sendNetworkRequest];
}

- (void)setupSubviews {
    self.view.backgroundColor = [UIColor whiteColor];
    
    _tableView = [UITableView new];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.rowHeight = 70.0f;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero).priorityLow();
        make.width.mas_equalTo(YOSScreenWidth);
    }];
    
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.userInfoModels.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YOSFriendCell *cell = [YOSFriendCell cellWithTableView:tableView];
    
    cell.userInfoModel = self.userInfoModels[indexPath.row];
    
    if (indexPath.row == 0) {
        cell.showTopLine = YES;
    } else {
        cell.showTopLine = NO;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%s", __func__);
}

#pragma mark - network

- (void)sendNetworkRequest {
    NSArray *buddyList = [[YOSEaseMobManager sharedManager] getNewestBuddyList];
    
    NSMutableArray *hx_users = [NSMutableArray array];
    [buddyList enumerateObjectsUsingBlock:^(EMBuddy *obj, NSUInteger idx, BOOL *stop) {
        [hx_users addObject:obj.username];
    }];
    
    // 没有新信息
    if (!hx_users.count) {
        [self.tableView reloadData];
        self.tableView.hidden = YES;
        [self showDefaultMessage:@"目前还没有好友哦~" tappedBlock:nil];
        return;
    } else {
        [self hideDefaultMessage];
    }
    
    YOSUserGetUserByHxRequest *request = [[YOSUserGetUserByHxRequest alloc] initWithHXUsers:hx_users];
    
    [request startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        if ([request yos_checkResponse]) {
            NSLog(@"%s", __func__);
            
            self.userInfoModels = [YOSUserInfoModel arrayOfModelsFromDictionaries:request.yos_data];
            
            [self.tableView reloadData];
        }
    } failure:^(YTKBaseRequest *request) {
        [request yos_checkResponse];
    }];

}

#pragma mark - getter & setter 



@end
