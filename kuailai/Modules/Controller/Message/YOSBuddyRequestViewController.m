//
//  YOSBuddyRequestViewController.m
//  kuailai
//
//  Created by yangyang on 15/7/28.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSBuddyRequestViewController.h"
#import "YOSAddRequestViewController.h"
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

@property (nonatomic, strong) NSMutableArray *userInfoModels;

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
    
    YOSAddRequestViewController *addVC = [YOSAddRequestViewController new];
    addVC.userInfoModel = self.userInfoModels[indexPath.row];
    
    [self.navigationController pushViewController:addVC animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSMutableArray *)messageModels {
    if (!_messageModels) {
        _messageModels = [NSMutableArray array];
    }
    
    return _messageModels;
}

#pragma mark - network

- (void)sendNetworkRequest {

    self.buddyMessages = [[YOSDBManager sharedManager] getBuddyListWithUsername:[YOSWidget getCurrentUserInfoModel].hx_user];
    
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
            
            self.userInfoModels = [userInfoModels mutableCopy];
            
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
