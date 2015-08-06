//
//  YOSAddBuddyViewController.m
//  kuailai
//
//  Created by yangyang on 15/7/27.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSAddBuddyViewController.h"
#import "YOSAddBuddyCell.h"

#import "YOSUserInfoModel.h"

#import "YOSInterestGetUserListRequest.h"
#import "YOSUserGetUserListRequest.h"

#import "Masonry.h"
#import "MJRefresh.h"
#import "SVProgressHUD+YOSAdditions.h"
#import "GVUserDefaults+YOSProperties.h"
#import "YOSEaseMobManager.h"
#import "EaseMob.h"
#import "YOSWidget.h"
#import "YOSUserInfoModel.h"

@interface YOSAddBuddyViewController () <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>

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

@property (nonatomic, strong) UISegmentedControl *segmented;

@end

@implementation YOSAddBuddyViewController {
    UISearchBar *_searchBar;
}

#pragma mark - life cycles

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupBackArrow];
    
    [self setupSegmented];
    
    [self setupSearchBar];
    
    [self setupTableView];
    
    YOSLog(@"\r\n\r\n\r\n 现在登录的事: %@\r\n\r\n\r\n", [YOSWidget getCurrentUserInfoModel].hx_user);
    
}

- (void)setupSearchBar {
    _searchBar = [UISearchBar new];
    _searchBar.frame = CGRectMake(0, 0, YOSScreenWidth, 44);
    _searchBar.placeholder = @"搜索你感兴趣的人/职位/公司";
    
    _searchBar.returnKeyType = UIReturnKeySearch;
    _searchBar.delegate = self;
}

- (void)setupTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 100, 100) style:UITableViewStylePlain];
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 60.0f;
    _tableView.sectionHeaderHeight = 44.0f;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero).priorityLow();
    }];
}

- (void)setupSegmented {
    
    UISegmentedControl *segmented = [[UISegmentedControl alloc] initWithItems:@[@"搜索好友", @"感兴趣的人"]];
    segmented.frame = CGRectMake(0, 0, 180, 30);
    segmented.selectedSegmentIndex = 0;
    segmented.tintColor = [UIColor whiteColor];
    [segmented addTarget:self action:@selector(segmentedValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    self.segmented = segmented;
    self.navigationItem.titleView = segmented;
}

#pragma mark - event response

- (void)segmentedValueChanged:(UISegmentedControl *)segmented {
    // 已审核
    if (segmented.selectedSegmentIndex == 0) {
        YOSLog(@"搜索好友");
        [self removeRefresh];
        [self.userInfoModels removeAllObjects];
        [self.tableView reloadData];
        return;
    }
    
    // 未审核
    if (segmented.selectedSegmentIndex == 1) {
        YOSLog(@"感兴趣的人");
        [self addRefresh];
        [self sendNetworkRequestWithType:YOSRefreshTypeHeader isSearch:NO];
        return;
    }
    
}

#pragma mark - network

- (void)sendNetworkRequestWithType:(YOSRefreshType)type isSearch:(BOOL)isSearch {
    
    NSUInteger requestPage = 1;
    if (type == YOSRefreshTypeFooter) {
        requestPage = self.currentPage + 1;
    } else {
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    }
    
    YTKRequest *request = nil;
    
    if (isSearch) {
        NSString *name = _searchBar.text;
        name = [name stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        if (!name.length) {
            return;
        }
        
        [SVProgressHUD dismiss];
        
        request = [[YOSUserGetUserListRequest alloc] initWithName:name andPage:YOSInt2String(requestPage)];
    } else {
        request = [[YOSInterestGetUserListRequest alloc] initWithUid:[GVUserDefaults standardUserDefaults].currentLoginID andPage:YOSInt2String(requestPage)];
    }
    
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
                self.userInfoModels = [YOSUserInfoModel arrayOfModelsFromDictionaries:request.yos_data[@"data"]];
            } else {
                NSArray *array = [YOSUserInfoModel arrayOfModelsFromDictionaries:request.yos_data[@"data"]];
                
                [array enumerateObjectsUsingBlock:^(YOSUserInfoModel *obj, NSUInteger idx, BOOL *stop) {
                    
                    if (![self.userInfoModels containsObject:obj]) {
                        [self.userInfoModels addObject:obj];
                    }
                    
                }];
            }
            
            NSArray *buddyList = [[YOSEaseMobManager sharedManager] getNewestBuddyList];
            
            NSArray *usernames = [buddyList valueForKeyPath:@"username"];
            
            YOSLog(@"usernames %@",usernames);
            
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
            
            [_tableView reloadData];
        }
    } failure:^(YTKBaseRequest *request) {
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        [request yos_checkResponse];
    }];
}

#pragma mark - private methods

- (void)addRefresh {
    YOSWSelf(weakSelf);
    [_tableView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf sendNetworkRequestWithType:YOSRefreshTypeHeader isSearch:NO];
    }];
    
    [_tableView addLegendFooterWithRefreshingBlock:^{
        [weakSelf sendNetworkRequestWithType:YOSRefreshTypeFooter isSearch:NO];
    }];
    
    self.tableView.footer.automaticallyRefresh = NO;
}

- (void)removeRefresh {
    [_tableView removeHeader];
    [_tableView removeFooter];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YOSAddBuddyCell *cell = [YOSAddBuddyCell cellWithTableView:tableView];
    
    cell.userInfoModel = self.userInfoModels[indexPath.row];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.userInfoModels.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%s", __func__);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (self.segmented.selectedSegmentIndex) {
        return nil;
    } else {
        return _searchBar;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.segmented.selectedSegmentIndex) {
        return 0.0f;
    } else {
        return 44.0f;
    }
}

#pragma mark - UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    NSLog(@"%s", __func__);
    
    [searchBar setShowsCancelButton:YES animated:YES];
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"%s", __func__);
    
    [searchBar setShowsCancelButton:NO animated:YES];
    
    [searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"%s", __func__);
    
    [searchBar setShowsCancelButton:NO animated:YES];
    
    [searchBar resignFirstResponder];
    
    NSString *name = searchBar.text;
    name = [name stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (!name.length) {
        return;
    }
    
    [self sendNetworkRequestWithType:YOSRefreshTypeHeader isSearch:YES];
}


@end
