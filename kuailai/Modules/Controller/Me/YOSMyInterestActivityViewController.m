//
//  YOSMyInterestActivityViewController.m
//  kuailai
//
//  Created by yangyang on 15/8/15.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSMyInterestActivityViewController.h"
#import "YOSActivityDetailViewController.h"
#import "YOSInterestActivityCell.h"

#import "YOSActivityListModel.h"

#import "YOSInterestGetActiveListRequest.h"

#import "Masonry.h"
#import "MJRefresh.h"
#import "SVProgressHUD+YOSAdditions.h"
#import "GVUserDefaults+YOSProperties.h"

@interface YOSMyInterestActivityViewController () <UITableViewDataSource, UITableViewDelegate>

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

@implementation YOSMyInterestActivityViewController

#pragma mark - life cycles

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavTitle:@"我感兴趣的"];
    
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

#pragma mark - network

- (void)sendNetworkRequestWithType:(YOSRefreshType)type {
    
    NSUInteger requestPage = 1;
    if (type == YOSRefreshTypeFooter) {
        requestPage = self.currentPage + 1;
    }
    
    NSString *uid = [GVUserDefaults standardUserDefaults].currentLoginID;
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    YOSInterestGetActiveListRequest *request = [[YOSInterestGetActiveListRequest alloc] initWithUid:uid andPage:YOSInt2String(requestPage)];
    
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
                self.activityListModels = [YOSActivityListModel arrayOfModelsFromDictionaries:request.yos_data[@"data"]];
            } else {
                NSArray *array = [YOSActivityListModel arrayOfModelsFromDictionaries:request.yos_data[@"data"]];
                
                [array enumerateObjectsUsingBlock:^(YOSActivityListModel *obj, NSUInteger idx, BOOL *stop) {
                    
                    if (![self.activityListModels containsObject:obj]) {
                        [self.activityListModels addObject:obj];
                    }
                    
                }];
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
    YOSActivityListModel *model = self.activityListModels[indexPath.section];
    
    YOSActivityDetailViewController *activityDetailVC = [[YOSActivityDetailViewController alloc] initWithActivityId:model.ID];
    
    [self.navigationController pushViewController:activityDetailVC animated:YES];
}


#pragma mark - getter & setter

- (NSMutableArray *)activityListModels {
    if (!_activityListModels) {
        _activityListModels = [NSMutableArray array];
    }
    
    return _activityListModels;
}



@end
