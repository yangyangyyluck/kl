//
//  YOSAttentionUserViewController.m
//  kuailai
//
//  Created by yangyang on 15/6/22.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSAttentionUserViewController.h"
#import "YOSUserInfoViewController.h"
#import "YOSAddBuddyCell.h"

#import "YOSUserInfoModel.h"

#import "YOSActiveGetCollectRequest.h"

#import "Masonry.h"
#import "MJRefresh.h"
#import "SVProgressHUD+YOSAdditions.h"
#import "YOSEaseMobManager.h"
#import "EMBuddy.h"

@interface YOSAttentionUserViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *userInfoModels;

/** 总数据量 */
@property (nonatomic, assign) NSUInteger count;

/** 总页数 */
@property (nonatomic, assign) NSUInteger totalPage;

/** 当前页数量 */
@property (nonatomic, assign) NSUInteger currentPage;

@property (nonatomic, assign) BOOL isNoMoreData;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation YOSAttentionUserViewController {
    NSString *_aid;
}

- (instancetype)initWithAid:(NSString *)aid {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _aid = aid;
    
    return self;
}

#pragma mark - life cycles

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavTitle:@"关注该活动的人"];
    [self setupBackArrow];
    
    self.currentPage = 0;
    self.isNoMoreData = NO;
    
    [self setupSubviews];
    
    [self sendNetworkRequestWithType:YOSRefreshTypeHeader];
}

- (void)setupSubviews {
    _tableView = [UITableView new];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 60;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero).priorityLow();
        make.width.mas_equalTo(YOSScreenWidth);
    }];
    
    YOSWSelf(weakSelf);
    [_tableView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf sendNetworkRequestWithType:YOSRefreshTypeHeader];
    }];
    
    [_tableView addLegendFooterWithRefreshingBlock:^{
        [weakSelf sendNetworkRequestWithType:YOSRefreshTypeFooter];
    }];
}

#pragma mark - network

- (void)sendNetworkRequestWithType:(YOSRefreshType)type {
    
    if (type == YOSRefreshTypeHeader) {
        self.currentPage = 1;
        self.isNoMoreData = NO;
    } else {
        
        if (!self.isNoMoreData) {
            self.currentPage++;
        }
        
    }
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    YOSActiveGetCollectRequest *request = [[YOSActiveGetCollectRequest alloc] initWithAid:_aid page:[NSString stringWithFormat:@"%zi", self.currentPage]];
    
    [request startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        [SVProgressHUD dismiss];
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        
        if ([request yos_checkResponse]) {
            
            self.totalPage = ((NSString *)request.yos_data[@"total_page"]).integerValue;
            
            self.count = ((NSString *)request.yos_data[@"count"]).integerValue;
            
            NSArray *array = request.yos_data[@"data"];
            
            if (self.totalPage == self.currentPage) {
                [self.tableView.footer noticeNoMoreData];
            }
            
            if (!array.count) {
                self.isNoMoreData = YES;
                [self.tableView.footer noticeNoMoreData];
                return;
            }
            
            if (type == YOSRefreshTypeHeader) {
                self.userInfoModels = [YOSUserInfoModel arrayOfModelsFromDictionaries:request.yos_data[@"data"]];
            } else {
                NSArray *array = [YOSUserInfoModel arrayOfModelsFromDictionaries:request.yos_data[@"data"]];
                
                [array enumerateObjectsUsingBlock:^(YOSUserInfoModel *obj, NSUInteger idx, BOOL *stop) {
                    
                    if (![self.userInfoModels containsObject:obj]) {
                        [self.userInfoModels addObject:obj];
                    }
                    
                }];
                
                NSArray *buddyList = [[YOSEaseMobManager sharedManager] getNewestBuddyList];
                
                [self.userInfoModels enumerateObjectsUsingBlock:^(YOSUserInfoModel *obj1, NSUInteger idx, BOOL *stop) {
                    [buddyList enumerateObjectsUsingBlock:^(EMBuddy *obj2, NSUInteger idx, BOOL *stop) {
                        if ([obj2.username isEqualToString:obj1.hx_user]) {
                            
                            if (obj2.followState == eEMBuddyFollowState_FollowedBoth) {
                                YOSLog(@"eEMBuddyFollowState_FollowedBoth");
                                obj1.friendType = YOSFriendTypeBoth;
                            }
                            
                        }
                    }];
                    
                }];
                
            }
            
            NSLog(@"activity list : %@", self.userInfoModels);
            
            [_tableView reloadData];
        }
    } failure:^(YTKBaseRequest *request) {
        [SVProgressHUD dismiss];
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        [request yos_checkResponse];
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
    YOSAddBuddyCell *cell = [YOSAddBuddyCell cellWithTableView:tableView];
    
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
    YOSUserInfoViewController *userVC = [YOSUserInfoViewController new];
    userVC.userInfoModel = self.userInfoModels[indexPath.row];
    
    [self.navigationController pushViewController:userVC animated:YES];
}


#pragma mark - getter & setter

- (NSMutableArray *)userInfoModels {
    if (!_userInfoModels) {
        _userInfoModels = [NSMutableArray array];
    }
    
    return _userInfoModels;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
