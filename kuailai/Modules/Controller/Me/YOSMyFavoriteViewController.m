//
//  YOSMyFavoriteViewController.m
//  kuailai
//
//  Created by yangyang on 15/8/19.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSMyFavoriteViewController.h"
#import "YOSActivityDetailViewController.h"
#import "YOSInterestActivityCell.h"

#import "YOSActivityListModel.h"

#import "YOSUserGetMyCollectListRequest.h"
#import "YOSActiveCancelCollectRequest.h"

#import "Masonry.h"
#import "MJRefresh.h"
#import "SVProgressHUD+YOSAdditions.h"
#import "GVUserDefaults+YOSProperties.h"

@interface YOSMyFavoriteViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *activityListModels;

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

@implementation YOSMyFavoriteViewController

#pragma mark - life cycles

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavTitle:@"我的收藏"];
    
    [self setupBackArrow];
    
    [self setupSubviews];
    
    self.currentPage = 0;
    self.isNoMoreData = NO;
    
    [self sendNetworkRequestWithType:YOSRefreshTypeHeader];
}

- (void)setupSubviews {
    _tableView = [UITableView new];
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 85.0f;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    YOSWSelf(weakSelf);
    [_tableView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf sendNetworkRequestWithType:YOSRefreshTypeHeader];
    }];
    
    [_tableView addLegendFooterWithRefreshingBlock:^{
        [weakSelf sendNetworkRequestWithType:YOSRefreshTypeFooter];
    }];
    
    self.tableView.footer.automaticallyRefresh = NO;
    
    [self.view addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero).priorityLow();
        make.width.mas_equalTo(YOSScreenWidth);
    }];
}

- (void)clickLeftItem:(UIButton *)item {
    // 有删除样式的时候 回退必然崩溃 这样可以解决
    [self.tableView reloadData];
    
    [super clickLeftItem:item];
}

#pragma mark - network

- (void)sendNetworkRequestWithType:(YOSRefreshType)type {
    
    NSUInteger requestPage = 1;
    if (type == YOSRefreshTypeFooter) {
        requestPage = self.currentPage + 1;
    }
    
    NSString *uid = [GVUserDefaults standardUserDefaults].currentLoginID;
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    YOSUserGetMyCollectListRequest *request = [[YOSUserGetMyCollectListRequest alloc] initWithUid:uid andPage:YOSInt2String(requestPage)];
    
    [request startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        
        if ([request yos_checkResponse]) {
            
            if (type == YOSRefreshTypeHeader) {
                self.isNoMoreData = NO;
            }
            self.currentPage = requestPage;
            
            self.totalPage = ((NSString *)request.yos_data[@"total_page"]).integerValue;
            
            self.count = ((NSString *)request.yos_data[@"count"]).integerValue;
            
            if (self.totalPage == self.currentPage) {
                [self.tableView.footer noticeNoMoreData];
            }
            
            if (type == YOSRefreshTypeHeader) {
                self.activityListModels = [YOSActivityListModel arrayOfModelsFromDictionaries:request.yos_data[@"data"]];
            } else {
                NSArray *array = [YOSActivityListModel arrayOfModelsFromDictionaries:request.yos_data[@"data"]];
                
                [array enumerateObjectsUsingBlock:^(YOSActivityListModel *obj, NSUInteger idx, BOOL *stop) {
                    
                    if (![self.activityListModels containsObject:obj]) {
                        [self.activityListModels addObject:obj];
                    }
                    
                }];
            }
            
            if (!self.activityListModels.count) {
                self.isNoMoreData = YES;
                [self.tableView.footer noticeNoMoreData];
                [self showDefaultMessage:@"还没收藏的活动哦~" tappedBlock:nil isShowHUD:NO];
            } else {
                [self hideDefaultMessage];
            }
            
            [_tableView reloadData];
        }
    } failure:^(YTKBaseRequest *request) {
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
    return self.activityListModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YOSInterestActivityCell *cell = [YOSInterestActivityCell cellWithTableView:tableView];
    
    cell.activityListModel = self.activityListModels[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YOSActivityListModel *model = self.activityListModels[indexPath.row];
    
    YOSActivityDetailViewController *activityDetailVC = [[YOSActivityDetailViewController alloc] initWithActivityId:model.ID];
    
    YOSWSelf(weakSelf);
    activityDetailVC.vBlock = ^{
        [weakSelf.activityListModels removeObjectAtIndex:indexPath.row];
        [weakSelf.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    };
    
    [self.navigationController pushViewController:activityDetailVC animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        YOSActivityListModel *activiteListModel = self.activityListModels[indexPath.row];
        
        YOSActiveCancelCollectRequest *request = [[YOSActiveCancelCollectRequest alloc] initWithUid:[GVUserDefaults standardUserDefaults].currentLoginID aid:activiteListModel.ID];
        
        [request startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
            
            if ([request yos_checkResponse]) {
                [SVProgressHUD showSuccessWithStatus:@"已取消收藏~" maskType:SVProgressHUDMaskTypeClear];
                [self.activityListModels removeObjectAtIndex:indexPath.row];
                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
            
        } failure:^(YTKBaseRequest *request) {
            [request yos_checkResponse];
        }];
        
    }
}


#pragma mark - getter & setter

- (NSMutableArray *)activityListModels {
    if (!_activityListModels) {
        _activityListModels = [NSMutableArray array];
    }
    
    return _activityListModels;
}


@end
