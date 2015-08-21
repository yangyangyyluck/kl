//
//  YOSHobbyViewController.m
//  kuailai
//
//  Created by yangyang on 15/8/14.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSHobbyViewController.h"
#import "YOSInterestCategoryViewController.h"
#import "YOSActivityDetailViewController.h"
#import "YOSHobbyButton.h"
#import "YOSInterestActivityCell.h"

#import "YOSActivityListModel.h"

#import "YOSGetActiveListRequest.h"

#import "Masonry.h"
#import "EDColor.h"
#import "MJRefresh.h"
#import "SVProgressHUD+YOSAdditions.h"
#import "GVUserDefaults+YOSProperties.h"
#import "UIImage+YOSAdditions.h"

@interface YOSHobbyViewController() <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>

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

@property (nonatomic, strong) UIView *hudView;

@property (nonatomic, strong) MASConstraint *heightConstraint;

@end

@implementation YOSHobbyViewController {
    UIView *_contentView;
    UIView *_bottomContentView;
    UIImageView *_kuaiLaiImageView;
    
    UISearchBar *_searchBar;
    
    YOSHobbyButton *_btn0;
    YOSHobbyButton *_btn1;
    YOSHobbyButton *_btn2;
    YOSHobbyButton *_btn3;
    YOSHobbyButton *_btn4;
    YOSHobbyButton *_btn5;
    
    NSMutableArray *_btns;
}

#pragma mark - life cycles

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavTitle:@"兴趣"];
    
    [self setupSearchBar];
    
    [self setupSubviews];
    
    [self setupTableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupSearchBar {
    _searchBar = [UISearchBar new];
    _searchBar.placeholder = @"搜索你想要的一切: )";
    _searchBar.returnKeyType = UIReturnKeySearch;
    _searchBar.delegate = self;
    _searchBar.barTintColor = YOSColorLineGray;
    [self.view addSubview:_searchBar];
    
    _searchBar.backgroundImage = [UIImage yos_imageWithColor:YOSColorGray size:CGSizeMake(1, 1)];

    [_searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(YOSScreenWidth, 44));
    }];
}

- (void)setupSubviews {
    
    _contentView = [UIView new];
    [self.view addSubview:_contentView];
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero).priorityLow();
        make.top.mas_equalTo(_searchBar.mas_bottom);
    }];
    
    _btns = [NSMutableArray array];
    
    _btn0 = [[YOSHobbyButton alloc] initWithImageName:@"商务市场" title:@"商务市场"];
    [_contentView addSubview:_btn0];
    
    _btn1 = [[YOSHobbyButton alloc] initWithImageName:@"黑马创业" title:@"黑马创业"];
    [_contentView addSubview:_btn1];
    
    _btn2 = [[YOSHobbyButton alloc] initWithImageName:@"产品分享" title:@"产品分享"];
    [_contentView addSubview:_btn2];
    
    _btn3 = [[YOSHobbyButton alloc] initWithImageName:@"技术交流" title:@"技术交流"];
    [_contentView addSubview:_btn3];
    
    _btn4 = [[YOSHobbyButton alloc] initWithImageName:@"沙龙小聚" title:@"沙龙小聚"];
    [_contentView addSubview:_btn4];
    
    _btn5 = [[YOSHobbyButton alloc] initWithImageName:@"户外休闲" title:@"户外休闲"];
    [_contentView addSubview:_btn5];
    
    [_btns addObjectsFromArray:@[_btn0, _btn1, _btn2, _btn3, _btn4, _btn5]];
    
    [_btns enumerateObjectsUsingBlock:^(YOSHobbyButton *obj, NSUInteger idx, BOOL *stop) {
        
        obj.tag = idx + 1;
        [obj addTarget:self action:@selector(tappedHobbyButton:) forControlEvents:UIControlEventTouchUpInside];
        
        // left
        if (idx % 2 == 0) {
            NSUInteger num = idx / 2;
            
            [obj mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(YOSScreenWidth / 2, 75));
                make.left.mas_equalTo(0);
                make.top.mas_equalTo(num * 75);
            }];
            
            if (num == 0) {
                obj.showTopLine = NO;
                obj.showLeftLine = NO;
                obj.showBottomLine = YES;
                obj.showRightLine = YES;
            } else {
                obj.showTopLine = NO;
                obj.showLeftLine = NO;
                obj.showBottomLine = YES;
                obj.showRightLine = YES;
            }
            
        } else {    // right
            CGFloat f = idx / 2.0;
            NSUInteger num = ceil(f);
            
            [obj mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(_btn0);
                make.right.mas_equalTo(0);
                make.top.mas_equalTo((num - 1) * 75);
            }];
            
            if (num == 0) {
                obj.showTopLine = YES;
                obj.showLeftLine = NO;
                obj.showBottomLine = YES;
                obj.showRightLine = NO;
            } else {
                obj.showTopLine = NO;
                obj.showLeftLine = NO;
                obj.showBottomLine = YES;
                obj.showRightLine = NO;
            }
        }
        
    }];
    
    _bottomContentView = [UIView new];
    
    [_contentView addSubview:_bottomContentView];
    
    [_bottomContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.bottom.right.mas_equalTo(0);
        make.top.mas_equalTo(_btn5.mas_bottom);
    }];
    
    _kuaiLaiImageView = [UIImageView new];
    _kuaiLaiImageView.image = [UIImage imageNamed:@"快来水印"];
    [_bottomContentView addSubview:_kuaiLaiImageView];
    
    [_kuaiLaiImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(_bottomContentView);
    }];
}

- (void)setupTableView {
    self.view.backgroundColor = [UIColor whiteColor];
    
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
    [self.view bringSubviewToFront:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(44);
        self.heightConstraint = make.height.mas_equalTo(YOSScreenHeight - 64 - 44 - 216);
        make.edges.mas_equalTo(UIEdgeInsetsZero).priorityLow();
    }];
    
    _tableView.hidden = YES;
}

#pragma mark - network

- (void)sendNetworkRequestWithType:(YOSRefreshType)type {
    
    NSUInteger requestPage = 1;
    if (type == YOSRefreshTypeFooter) {
        requestPage = self.currentPage + 1;
    }
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    YOSGetActiveListRequest *request = [[YOSGetActiveListRequest alloc] initWithCity:0 page:requestPage start_time:0 type:1];
    
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

#pragma mark - UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    NSLog(@"%s", __func__);
    
    self.hudView.hidden = NO;
    
    [searchBar setShowsCancelButton:YES animated:YES];
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"%s", __func__);
    
    self.hudView.hidden = YES;
    self.tableView.hidden = YES;
    
    [searchBar setShowsCancelButton:NO animated:YES];
    
    [searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"%s", __func__);
    
    self.hudView.hidden = YES;
    self.tableView.hidden = NO;
    
    NSString *name = searchBar.text;
    name = [name stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (!name.length) {
        return;
    }
    
    [self sendNetworkRequestWithType:YOSRefreshTypeHeader];
}

#pragma mark - event response 

- (void)tappedHobbyButton:(UIButton *)button {
    NSLog(@"%s", __func__);
    
    YOSActivityType type = button.tag;

    NSString *title = nil;
    switch (type) {
        case YOSActivityTypeSWJL: {
            title = @"商务交流";
            break;
        }
        case YOSActivityTypeHMCY: {
            title = @"黑马创业";
            break;
        }
        case YOSActivityTypeCPFX: {
            title = @"产品分享";
            break;
        }
        case YOSActivityTypeJSJL: {
            title = @"技术交流";
            break;
        }
        case YOSActivityTypeSLXJ: {
            title = @"沙龙小聚";
            break;
        }
        case YOSActivityTypeHWXX: {
            title = @"户外休闲";
            break;
        }
        default: {
            title = @"";
            break;
        }
    }
    
    YOSInterestCategoryViewController *categoryVC = [[YOSInterestCategoryViewController alloc] initWithTitle:title category:type];
    
    [self.navigationController pushViewController:categoryVC animated:YES];

}

- (void)tappedHUDView {
    self.hudView.hidden = YES;
    [_searchBar setShowsCancelButton:NO animated:YES];
    [_searchBar resignFirstResponder];
}

- (void)keyboardWillChangeFrame:(NSNotification *)noti {
    NSDictionary *dict = noti.userInfo;
    
    NSValue *value = ((NSValue *)dict[UIKeyboardFrameEndUserInfoKey]);
    
    CGRect rect = [value CGRectValue];
    
    NSLog(@"frame : %@", dict);
    
    CGFloat height = YOSScreenHeight - 44 - 64 - rect.size.height;
    
    [self.heightConstraint setOffset:height];
}

#pragma mark - getter & setter 

- (UIView *)hudView {
    if (!_hudView) {
        _hudView = [UIView new];
        _hudView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedHUDView)];
        
        [_hudView addGestureRecognizer:tap];
        
        [_contentView addSubview:_hudView];
        
        [_hudView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero).priorityLow();
        }];
    }
    
    return _hudView;
}

@end
