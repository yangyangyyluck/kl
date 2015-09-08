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
#import "YOSGuideViewController.h"
#import "YOSInputView.h"
#import "YOSTextField.h"
#import "YOSHomeCell.h"
#import "YOSTextView.h"
#import "YOSHomeSwitchView.h"

#import "YOSUserSendCodeRequest.h"
#import "YOSGetActiveListRequest.h"
#import "YOSUserLoginRequest.h"
#import "YOSUserGetVersionRequest.h"

#import "YOSUserInfoModel.h"
#import "YOSActivityListModel.h"

#import "YOSWidget.h"
#import "Masonry.h"
#import "IQKeyboardManager.h"
#import "YOSDBManager.h"
#import "XXNibConvention.h"
#import "MJRefresh.h"

#import "GVUserDefaults+YOSProperties.h"
#import "IQUIView+IQKeyboardToolbar.h"
#import "UIImage+YOSAdditions.h"
#import "UIImage-Helpers.h"
#import "SVProgressHUD+YOSAdditions.h"
#import "UIView+YOSAdditions.h"
#import "YOSLocalNotificationManager.h"
#import "YOSWidget.h"

@interface YOSHomeViewController () <UITableViewDataSource, UITableViewDelegate, YOSHomeSwitchViewDelegate, UIAlertViewDelegate>

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

@property (nonatomic, assign) NSUInteger selectedTime;

@property (nonatomic, assign) NSUInteger selectedType;

@property (nonatomic, assign) NSUInteger selectedPosition;

@property (nonatomic, copy) NSString *updateUrl;

@end

@implementation YOSHomeViewController {
    YOSTextView *_textView;
    YOSHomeSwitchView *_switchView;
}

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self setupHomeView];
}

- (void)viewWillDisappear:(BOOL)animated {
    _switchView.hidden = YES;
    [super viewWillDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated {
    _switchView.hidden = NO;
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[YOSLocalNotificationManager sharedManager] dealWithCurrentNotification];
}

- (void)setupHomeView {
    [self setupSubviews];
    
    [self setupKuaiLai];
    
    [self setupNavigationRightButtons];
    
    self.currentPage = 0;
    self.isNoMoreData = NO;
    
    [self sendNetworkRequestWithType:YOSRefreshTypeHeader];
    
    [self sendNetworkWithWhetherUpdateApp];
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

- (void)setupNavigationRightButtons {
    
    _switchView = [YOSHomeSwitchView new];
    
    [self.navigationController.navigationBar addSubview:_switchView];
    
    _switchView.frame = CGRectMake(YOSScreenWidth - 120 - 20, 0, 120, 44);
    _switchView.delegate = self;
    
}

- (void)setupNavigationRightButtons2 {
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 120, 25)];
    
    toolbar.barStyle = UIBarStyleDefault;

    //定义两个flexibleSpace的button，放在toolBar上，这样完成按钮就会在最右边
    UIBarButtonItem * flexibleItem0 =[[UIBarButtonItem  alloc]initWithBarButtonSystemItem:                                        UIBarButtonSystemItemFixedSpace target:self action:nil];
    flexibleItem0.width =8;
    
    UIBarButtonItem * flexibleItem1 = [[UIBarButtonItem  alloc]initWithBarButtonSystemItem:                                        UIBarButtonSystemItemFixedSpace target:self action:nil];
    flexibleItem1.width =8;
    
    UIBarButtonItem * flexibleItem2 = [[UIBarButtonItem  alloc]initWithBarButtonSystemItem:                                        UIBarButtonSystemItemFixedSpace target:self action:nil];
    flexibleItem2.width =8;

    
    UIButton *btn0 = [UIButton new];
    btn0.frame = CGRectMake(0, 0, 25, 25);
    [btn0 setImage:[UIImage imageNamed:@"时间"] forState:UIControlStateNormal];
    btn0.imageView.contentMode = UIViewContentModeScaleAspectFit;
    btn0.backgroundColor = YOSColorRandom;
    
    UIButton *btn1 = [UIButton new];
    btn1.frame = CGRectMake(0, 0, 25, 25);
    [btn1 setImage:[UIImage imageNamed:@"兴趣-1"] forState:UIControlStateNormal];
    btn1.imageView.contentMode = UIViewContentModeScaleAspectFit;
    btn1.backgroundColor = YOSColorRandom;
    
    UIButton *btn2 = [UIButton new];
    btn2.frame = CGRectMake(0, 0, 25, 25);
    btn2.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [btn2 setImage:[UIImage imageNamed:@"位置"] forState:UIControlStateNormal];
    btn2.imageView.contentMode = UIViewContentModeScaleAspectFit;
    btn2.backgroundColor = YOSColorRandom;
    

    
    UIBarButtonItem *item0 = [[UIBarButtonItem alloc] initWithCustomView:btn0];
    
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithCustomView:btn1];
    
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithCustomView:btn2];
    
    toolbar.items = @[item0, flexibleItem1, item1, flexibleItem0, item2, flexibleItem2];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:toolbar];
    
    self.navigationItem.rightBarButtonItem = item;
    
    
}

#pragma mark - event response



#pragma mark - network

- (void)sendNetworkRequestWithType:(YOSRefreshType)type {
    
    NSUInteger requestPage = 1;
    if (type == YOSRefreshTypeFooter) {
        requestPage = self.currentPage + 1;
    }
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    YOSGetActiveListRequest *request = [[YOSGetActiveListRequest alloc] initWithCity:self.selectedPosition page:requestPage start_time:self.selectedTime type:self.selectedType];
    
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
                [self showDefaultMessage:@"该类别暂无活动哦~" tappedBlock:nil isShowHUD:NO];
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

- (void)sendNetworkWithWhetherUpdateApp {
    YOSUserGetVersionRequest *request = [[YOSUserGetVersionRequest alloc] initWithIOS];
    
    [request startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
       
        [request yos_checkResponse:NO];
        
        NSDictionary *dict = request.yos_data;
        
        NSString *version = dict[@"version"];
        NSString *url = dict[@"url"];
        self.updateUrl = url;
        
        NSString *currentVersion = [YOSWidget currentAppVersion];
        NSComparisonResult result = [YOSWidget compareAppVersion1:currentVersion andAppVersion2:version];
        
        // current < version
        if (result == NSOrderedAscending) {
            
            BOOL status = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:self.updateUrl]];
            
            if (!status) {
                return;
            }
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"有新版本哦,赶紧去跟新吧~" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            
            [alertView show];
        }
        
    } failure:^(YTKBaseRequest *request) {
        
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

#pragma mark - YOSHomeSwitchViewDelegate

- (void)homeSwitchView:(YOSHomeSwitchView *)homeSwitchView selectedIndex:(NSUInteger)selectedIndex selectedSubIndex:(NSUInteger)selectedSubIndex {
    if (selectedIndex == 0) {
        self.selectedTime = selectedSubIndex;
    }
    
    if (selectedIndex == 1) {
        self.selectedType = selectedSubIndex;
    }
    
    if (selectedIndex == 2) {
        self.selectedPosition = selectedSubIndex;
    }
    
    _switchView.selectedPosition = self.selectedPosition;
    _switchView.selectedTime = self.selectedTime;
    _switchView.selectedType = self.selectedType;
    
    NSLog(@"time : %zi type : %zi position : %zi", self.selectedTime, self.selectedType, self.selectedPosition);
    
    [self sendNetworkRequestWithType:YOSRefreshTypeHeader];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.updateUrl]];
        
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
