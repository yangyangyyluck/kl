//
//  YOSActivityAuditViewController.m
//  kuailai
//
//  Created by yangyang on 15/7/1.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSActivityAuditViewController.h"
#import "YOSActivityAuditIndividualViewController.h"
#import "YOSFriendCell.h"

#import "YOSActivityListModel.h"
#import "YOSFriendModel.h"
#import "YOSUserInfoModel.h"

#import "YOSActiveGetSignUpRequest.h"

#import "Masonry.h"
#import "YOSMyActivityView.h"
#import "SVProgressHUD+YOSAdditions.h"
#import "MJRefresh.h"

@interface YOSActivityAuditViewController() <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) YOSActivityListModel *activityListModel;

/** userInfoModels */
@property (nonatomic, strong) NSMutableArray *userInfoModels;

/** currentIndexPath */
@property (nonatomic, strong) NSIndexPath *currentIndexPath;

/** 报名活动的用户 */
@property (nonatomic, strong) NSMutableArray *friends;

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

@implementation YOSActivityAuditViewController {
    UIScrollView *_scrollView;
    UIView *_contentView;
    YOSMyActivityView *_myActivityView;
    
    UILabel *_leftLabel;
    UIButton *_rightButton;
}

#pragma mark - life cycles

- (instancetype)initWithActivityListModel:(YOSActivityListModel *)activityListModel {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _activityListModel = activityListModel;
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavTitle:@"报名审核"];
    [self setupBackArrow];
    self.view.backgroundColor = YOSColorBackgroundGray;
    
    self.currentPage = 0;
    self.isNoMoreData = NO;
    
    [self setupSubviews];
    
    [self sendNetworkRequestWithType:YOSRefreshTypeHeader];
}

- (void)setupSubviews {
    _scrollView = [UIScrollView new];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    
    [self.view addSubview:_scrollView];
    
    _contentView = [UIView new];
    [_scrollView addSubview:_contentView];
    
    _myActivityView = [YOSMyActivityView new];
    _myActivityView.activityListModel = _activityListModel;
    [_contentView addSubview:_myActivityView];
    
    _leftLabel = [UILabel new];
    _leftLabel.font = YOSFontNormal;
    _leftLabel.text = @"报名人数: 人";
    [_contentView addSubview:_leftLabel];
    
    _rightButton = [UIButton new];
    [_rightButton setTitle:@"一键全通过" forState:UIControlStateNormal];
    [_rightButton setTitleColor:YOSColorGreen forState:UIControlStateNormal];
    _rightButton.titleLabel.font = YOSFontNormal;
    [_rightButton addTarget:self action:@selector(tappedAllSignButton) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:_rightButton];
    
    _tableView = [UITableView new];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.rowHeight = 60;
    [_contentView addSubview:_tableView];
    
    YOSWSelf(weakSelf);
    [_tableView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf sendNetworkRequestWithType:YOSRefreshTypeHeader];
    }];
    
    [_tableView addLegendFooterWithRefreshingBlock:^{
        [weakSelf sendNetworkRequestWithType:YOSRefreshTypeFooter];
    }];
    
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero).priorityLow();
        make.width.mas_equalTo(YOSScreenWidth);
    }];
    
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero).priorityLow();
        make.width.mas_equalTo(YOSScreenWidth);
        make.height.mas_equalTo(YOSScreenHeight - 64);
    }];
    
    [_myActivityView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(YOSScreenWidth, 110));
        make.left.and.top.mas_equalTo(0);
    }];
    
    [_leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(_myActivityView.mas_bottom);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(200);
    }];
    
    [_rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(_leftLabel);
        make.size.mas_equalTo(CGSizeMake(85, 30));
    }];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(YOSScreenWidth);
        make.left.bottom.mas_equalTo(0);
        make.top.mas_equalTo(_rightButton.mas_bottom);
    }];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.friends.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YOSFriendCell *cell = [YOSFriendCell cellWithTableView:tableView];
    cell.friendModel = self.friends[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%s", __func__);
    
    self.currentIndexPath = [NSIndexPath indexPathForItem:(indexPath.item % 2) inSection:(self.currentPage - 1)];
    
    YOSActivityAuditIndividualViewController *auditVC = [YOSActivityAuditIndividualViewController new];
    auditVC.currentIndexPath = self.currentIndexPath;
    auditVC.userInfoModels = self.userInfoModels;
    auditVC.aid = self.activityListModel.ID;
    
    [self.navigationController pushViewController:auditVC animated:YES];
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
    YOSActiveGetSignUpRequest *request = [[YOSActiveGetSignUpRequest alloc] initWithAid:self.activityListModel.ID andPage:[NSString stringWithFormat:@"%zi", self.currentPage]];
    
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
                self.friends = [YOSFriendModel arrayOfModelsFromDictionaries:request.yos_data[@"data"]];
            } else {
                NSArray *array = [YOSFriendModel arrayOfModelsFromDictionaries:request.yos_data[@"data"]];
                
                [array enumerateObjectsUsingBlock:^(YOSFriendModel *obj, NSUInteger idx, BOOL *stop) {
                    
                    if (![self.friends containsObject:obj]) {
                        [self.friends addObject:obj];
                    }
                    
                }];
            }
            
            if (type == YOSRefreshTypeHeader) {
                [self.userInfoModels removeAllObjects];
                NSUInteger i = 1;
                while (i <= self.totalPage) {
                    NSMutableArray *temp = [NSMutableArray array];
                    if (i == self.currentPage) {
                        NSArray *userInfoModels = [YOSUserInfoModel arrayOfModelsFromDictionaries:request.yos_data[@"data"]];
                        [temp addObjectsFromArray:userInfoModels];
                    }
                    [self.userInfoModels addObject:temp];
                    i++;
                }
            } else {
                NSArray *subUserInfoModels = [YOSUserInfoModel arrayOfModelsFromDictionaries:request.yos_data[@"data"]];
                
                if (self.currentPage != 2) {
                    self.userInfoModels[self.currentPage - 1] = subUserInfoModels;
                }
                
            }

            
            
            NSLog(@"activity list, firends : %@, userInfoModels : %@", self.friends, self.userInfoModels);
            
            [_tableView reloadData];
        }
    } failure:^(YTKBaseRequest *request) {
        [SVProgressHUD dismiss];
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        [request yos_checkResponse];
    }];
}

#pragma mark - event response 

- (void)tappedAllSignButton {
    NSLog(@"%s", __func__);
    
    YOSActivityAuditIndividualViewController *auditVC = [YOSActivityAuditIndividualViewController new];
    
    auditVC.userInfoModels = self.userInfoModels;
    
    [self.navigationController pushViewController:auditVC animated:YES];
}

#pragma mark - getter & setter 

- (void)setCount:(NSUInteger)count {
    _count = count;
    
    _leftLabel.text = [NSString stringWithFormat:@"报名人数: %zi人", count];
}

- (NSMutableArray *)userInfoModels {
    if (!_userInfoModels) {
        _userInfoModels = [NSMutableArray array];
    }
    
    return _userInfoModels;
}

@end
