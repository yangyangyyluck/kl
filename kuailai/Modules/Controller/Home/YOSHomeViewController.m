//
//  YOSHomeViewController.m
//  kuailai
//
//  Created by yangyang on 15/4/8.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSHomeViewController.h"
#import "YOSRegisterViewController.h"
#import "YOSEditViewController.h"
#import "YOSActivityDetailViewController.h"
#import "YOSInputView.h"
#import "YOSTextField.h"
#import "YOSHomeCell.h"
#import "YOSTextView.h"

#import "YOSUserSendCodeRequest.h"
#import "YOSGetActiveListRequest.h"
#import "YOSUserLoginRequest.h"

#import "YOSUserInfoModel.h"
#import "YOSActivityListModel.h"

#import "YOSWidget.h"
#import "Masonry.h"
#import "IQKeyboardManager.h"
#import "YOSDBManager.h"
#import "XXNibConvention.h"
#import "MJRefresh.h"

#import "IQUIView+IQKeyboardToolbar.h"
#import "UIImage+YOSAdditions.h"
#import "UIImage-Helpers.h"
#import "SVProgressHUD+YOSAdditions.h"
#import "GVUserDefaults+YOSProperties.h"

@interface YOSHomeViewController () <UITableViewDataSource, UITableViewDelegate>

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

@implementation YOSHomeViewController {
    YOSTextView *_textView;
}

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubviews];
    
    [self setupRightButtonWithTitle:@"点击"];
    
    self.currentPage = 0;
    self.isNoMoreData = NO;
    self.hidesBottomBarWhenPushed = NO;
    
    [self sendNetworkRequestWithType:YOSRefreshTypeHeader];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)setupSubviews {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 100, 100) style:UITableViewStyleGrouped];
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 170.0f;
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
    }];
}

#pragma mark - event response

- (void)clickRightItem:(UIButton *)item {
    NSLog(@"%s", __func__);
    NSString *string = @"2";
    
    if ([string isEqualToString:@"1"]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController pushViewController:[YOSRegisterViewController viewControllerFromStoryboardWithSBName:@"Register"] animated:YES];
        });
    }
    
    if ([string isEqualToString:@"2"]) {
        YOSGetActiveListRequest *request = [[YOSGetActiveListRequest alloc] initWithCity:YOSCityTypeBJ page:(self.currentPage + 1) start_time:0 type:0];
        
        [request startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
            if ([request yos_checkResponse]) {
                
                self.activityListModels = [YOSActivityListModel arrayOfModelsFromDictionaries:request.yos_data[@"data"]];
                
//                self.currentPage++;
                
                self.totalPage = ((NSString *)request.yos_data[@"total_page"]).integerValue;
                
                self.count = ((NSString *)request.yos_data[@"count"]).integerValue;
                
                NSLog(@"activity list : %@", self.activityListModels);
                
                [_tableView reloadData];
            }
        } failure:^(YTKBaseRequest *request) {
            [request yos_checkResponse];
        }];
    }
    
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"%s", __func__);
    NSString *string = @"2";
    
    if ([string isEqualToString:@"1"]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController pushViewController:[YOSRegisterViewController viewControllerFromStoryboardWithSBName:@"Register"] animated:YES];
        });
    }
    
    if ([string isEqualToString:@"2"]) {
        YOSGetActiveListRequest *request = [[YOSGetActiveListRequest alloc] initWithCity:YOSCityTypeBJ page:0 start_time:0 type:0];
        
        [request startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
            if ([request yos_checkResponse]) {
                self.activityListModels = [YOSActivityListModel arrayOfModelsFromDictionaries:request.yos_data];
                
                NSLog(@"activity list : %@", self.activityListModels);
                
                [_tableView reloadData];
            }
        } failure:^(YTKBaseRequest *request) {
            [request yos_checkResponse];
        }];
    }
    
//    if ([string isEqualToString:@"3"]) {
//        YOSUserLoginRequest *request = [[YOSUserLoginRequest alloc] initWithUserName:@"18600950783" pwd:@"123123" models:[[UIDevice currentDevice] model]];
//        
//        [request startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
//            if ([request yos_checkResponse]) {
//                
//                [YOSWidget setUserDefaultWithKey:YOSUserDefaultKeyCurrentUserInfoDictionary value:request.yos_data];
//                
//                YOSUserInfoModel *model = [[YOSUserInfoModel alloc] initWithDictionary:request.yos_data error:nil];
//                
//                if (model.ID) {
//                    [YOSWidget setUserDefaultWithKey:YOSUserDefaultKeyCurrentLoginID value:model.ID];
//                    YOSLog(@"\r\n\r\n had set LoginID");
//                }
//                
//                if (model.username) {
//                    [YOSWidget setUserDefaultWithKey:YOSUserDefaultKeyCurrentLoginMobileNumber value:model.username];
//                    YOSLog(@"\r\n\r\n had set LoginMobile");
//                }
//                
//            }
//        } failure:^(YTKBaseRequest *request) {
//            [request yos_checkResponse];
//        }];
//    }
    
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
    YOSGetActiveListRequest *request = [[YOSGetActiveListRequest alloc] initWithCity:YOSCityTypeBJ page:self.currentPage start_time:0 type:0];
    
    [request startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        
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
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        [request yos_checkResponse];
    }];
}


#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.activityListModels.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YOSHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YOSHomeCell class])];
    
    if (!cell) {
        cell = [YOSHomeCell xx_instantiateFromNib];
    }
    
    cell.model = self.activityListModels[indexPath.section];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 10.0f;
    } else {
        return 5.0f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == (self.activityListModels.count - 1)) {
        return 10.0f;
    } else {
        return 5.0f;
    }
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
