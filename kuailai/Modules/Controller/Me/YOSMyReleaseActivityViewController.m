//
//  YOSMyReleaseActivityViewController.m
//  kuailai
//
//  Created by yangyang on 15/6/30.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSMyReleaseActivityViewController.h"
#import "YOSMyActivityView.h"
#import "YOSMyReleaseCell.h"

#import "YOSActivityListModel.h"

#import "YOSUserGetMyActiveListRequest.h"

#import "GVUserDefaults+YOSProperties.h"
#import "SVProgressHUD+YOSAdditions.h"
#import "MJRefresh.h"
#import "Masonry.h"

@interface YOSMyReleaseActivityViewController () <UITableViewDataSource, UITableViewDelegate>

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

@property (nonatomic, strong) UISegmentedControl *segmented;

@end

@implementation YOSMyReleaseActivityViewController

#pragma mark - life cycles

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupBackArrow];
    
    [self setupSegmented];
    
    self.currentPage = 0;
    self.isNoMoreData = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self sendNetworkRequestWithType:YOSRefreshTypeHeader];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 110 + 44;
    self.tableView.backgroundColor = YOSColorBackgroundGray;
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero).priorityLow();
        make.width.mas_equalTo(YOSScreenWidth);
    }];
    
    YOSWSelf(weakSelf);
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf sendNetworkRequestWithType:YOSRefreshTypeHeader];
    }];
    
    [self.tableView addLegendFooterWithRefreshingBlock:^{
        [weakSelf sendNetworkRequestWithType:YOSRefreshTypeFooter];
    }];
    
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.activityListModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YOSMyReleaseCell *cell = [YOSMyReleaseCell cellWithTableView:tableView];
    
    cell.activityListModel = self.activityListModels[indexPath.section];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.01f;
    } else {
        return 5.0f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == (self.activityListModels.count - 1)) {
        return 0.01f;
    } else {
        return 5.0f;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%s", __func__);
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
    YOSUserGetMyActiveListRequest *request = [[YOSUserGetMyActiveListRequest alloc] initWithUid:[GVUserDefaults standardUserDefaults].currentLoginID andPage:[NSString stringWithFormat:@"%zi", self.currentPage] andStatus:[NSString stringWithFormat:@"%zi", self.segmented.selectedSegmentIndex]];
    
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
                self.activityListModels = [YOSActivityListModel arrayOfModelsFromDictionaries:request.yos_data[@"data"]];
            } else {
                NSArray *array = [YOSActivityListModel arrayOfModelsFromDictionaries:request.yos_data[@"data"]];
                
                [array enumerateObjectsUsingBlock:^(YOSActivityListModel *obj, NSUInteger idx, BOOL *stop) {
                    
                    if (![self.activityListModels containsObject:obj]) {
                        [self.activityListModels addObject:obj];
                    }
                    
                }];
            }
            
            NSLog(@"activity list : %@", self.activityListModels);
            
            [_tableView reloadData];
        }
    } failure:^(YTKBaseRequest *request) {
        [SVProgressHUD dismiss];
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        [request yos_checkResponse];
    }];
}

#pragma mark - private method list

- (void)setupSegmented {
    
    UISegmentedControl *segmented = [[UISegmentedControl alloc] initWithItems:@[@"已审核", @"未审核"]];
    segmented.frame = CGRectMake(0, 0, 180, 30);
    segmented.selectedSegmentIndex = 0;
    segmented.tintColor = [UIColor whiteColor];
    [segmented addTarget:self action:@selector(segmentedValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    self.segmented = segmented;
    self.navigationItem.titleView = segmented;
}

- (void)segmentedValueChanged:(UISegmentedControl *)segmented {
    // 已审核
    if (segmented.selectedSegmentIndex == 0) {
        YOSLog(@"已审核");
        [self sendNetworkRequestWithType:YOSRefreshTypeHeader];
    }
    
    // 未审核
    if (segmented.selectedSegmentIndex == 1) {
        YOSLog(@"未审核");
        [self sendNetworkRequestWithType:YOSRefreshTypeHeader];
    }
}

@end
