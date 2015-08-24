//
//  YOSSettingViewController.m
//  kuailai
//
//  Created by yangyang on 15/8/5.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSSettingViewController.h"
#import "YOSTestViewController.h"
#import "YOSFeedbackViewController.h"
#import "YOSChangePassViewController.h"
#import "YOSAboutUsViewController.h"
#import "YOSSettingCell.h"

#import "YOSUserUpPublicRequest.h"

#import "UIView+YOSAdditions.h"
#import "UIImage+YOSAdditions.h"
#import "Masonry.h"
#import "GVUserDefaults+YOSProperties.h"
#import "SVProgressHUD+YOSAdditions.h"
#import "YOSEaseMobManager.h"
#import "YOSWidget.h"
#import "SDImageCache.h"

typedef NS_ENUM(NSUInteger, kRightAccessoryType) {
    kRightAccessoryTypeNone,
    kRightAccessoryTypeArrow,
    kRightAccessoryTypeSwitch,
};

@interface YOSSettingViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation YOSSettingViewController {
    UIScrollView *_scrollView;
    UIView *_contentView;
    
    UIButton *_logoutButton;
}

#pragma mark - life cycles

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupBackArrow];
    
    [self setupNavTitle:@"设置"];
    
    [self setupSubviews];
}

- (void)setupSubviews {
    self.view.backgroundColor = [UIColor whiteColor];
    
    _scrollView = [UIScrollView new];
    [self.view addSubview:_scrollView];
    
    _contentView = [UIView new];
    [_scrollView addSubview:_contentView];
    
    _tableView = [UITableView new];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_contentView addSubview:_tableView];
    
    _logoutButton = [UIButton new];
    [_logoutButton setBackgroundImage:[UIImage yos_imageWithColor:YOSColorMainRed size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
    [_logoutButton addTarget:self action:@selector(tappedLogoutButton) forControlEvents:UIControlEventTouchUpInside];
    _logoutButton.layer.cornerRadius = 4.0f;
    _logoutButton.titleLabel.font = YOSFontBold;
    [_logoutButton setTitle:@"退出登录" forState:UIControlStateNormal];
    _logoutButton.layer.masksToBounds = YES;
    [_contentView addSubview:_logoutButton];
    
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero).priorityLow();
        make.width.mas_equalTo(YOSScreenWidth);
    }];
    
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero).priorityLow();
        make.width.mas_equalTo(YOSScreenWidth);
        make.height.mas_equalTo(YOSScreenHeight * 2);
    }];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.mas_equalTo(0);
        make.width.mas_equalTo(YOSScreenWidth);
        make.height.mas_equalTo(self.dataSource.count * 44);
    }];
    
    [_logoutButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_tableView.mas_bottom).offset(40);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(44);
    }];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YOSSettingCell *cell = [YOSSettingCell cellWithTableView:tableView];
    
    NSDictionary *dict = self.dataSource[indexPath.row];
    
    kRightAccessoryType rightType = (kRightAccessoryType)([dict[@"rightType"] integerValue]);
    
    if (rightType == kRightAccessoryTypeNone) {
        cell.showRightAccessoryArrow = NO;
        cell.showSwitch = NO;
    }
    
    if (rightType == kRightAccessoryTypeSwitch) {
        YOSWSelf(weakSelf);
        [cell showSwitchWithSelectedBlock:^{
            YOSLog(@"selected");
            [weakSelf sendNetworkRequestWithIsPublic:1];
        } unSelectedBlock:^{
            YOSLog(@"unselected");
            [weakSelf sendNetworkRequestWithIsPublic:2];
        }];
        
        NSUInteger isPublic = [GVUserDefaults standardUserDefaults].isPublic;
        
        if (isPublic == 1) {
            [cell setSwitchOn:YES];
        } else {
            [cell setSwitchOn:NO];
        }
        
        cell.showRightAccessoryArrow = NO;
    }
    
    if (rightType == kRightAccessoryTypeArrow) {
        cell.showSwitch = NO;
        cell.showRightAccessoryArrow = YES;
    }
    
    cell.leftLabel.text = dict[@"title"];
    cell.rightLabel.text = dict[@"message"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dict = self.dataSource[indexPath.row];
    
    kRightAccessoryType rightType = (kRightAccessoryType)([dict[@"rightType"] integerValue]);
    
    if (rightType != kRightAccessoryTypeArrow) {
        return;
    }
    
    NSLog(@"%s", __func__);
    
    if (indexPath.row == 0) {
        YOSChangePassViewController *changeVC = [YOSChangePassViewController viewControllerFromStoryboardWithSBName:@"Register"];
        [self.navigationController pushViewController:changeVC animated:YES];
    }
    
    if (indexPath.row == 1) {
        YOSFeedbackViewController *feedbackVC = [YOSFeedbackViewController new];
        [self.navigationController pushViewController:feedbackVC animated:YES];
    }
    
    if (indexPath.row == 2) {
//        YOSTestViewController *testVC = [YOSTestViewController new];
//        [self.navigationController pushViewController:testVC animated:YES];
        YOSAboutUsViewController *aboutVC = [YOSAboutUsViewController new];
        [self.navigationController pushViewController:aboutVC animated:YES];
    }
    
    if (indexPath.row == 4) {
        
        SDImageCache *cache = [SDImageCache sharedImageCache];
        
        NSUInteger cacheSize = [cache getSize];
        
        CGFloat mb = cacheSize / (1024.0 * 1024.0);

        NSLog(@"清楚缓存 %zi, %f", cacheSize, mb);

        YOSWSelf(weakSelf);
        [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
            weakSelf.dataSource = nil;
            [weakSelf.tableView reloadData];
            [SVProgressHUD showInfoWithStatus:@"已清除所有缓存~" maskType:SVProgressHUDMaskTypeClear];
        }];
        
    }
    
}

#pragma mark - network

- (void)sendNetworkRequestWithIsPublic:(NSUInteger)isPublic {
    NSString *uid = [GVUserDefaults standardUserDefaults].currentLoginID;
    YOSUserUpPublicRequest *request = [[YOSUserUpPublicRequest alloc] initWithUid:uid isPublic:YOSInt2String(isPublic)];
    
    [request startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        if ([request yos_checkResponse]) {
            
            [GVUserDefaults standardUserDefaults].isPublic = isPublic;
            
            NSDictionary *dict = [GVUserDefaults standardUserDefaults].currentUserInfoDictionary;
            
            NSMutableDictionary *mDict = [dict mutableCopy];
            
            mDict[@"is_public"] = YOSInt2String(isPublic);
            [GVUserDefaults standardUserDefaults].currentUserInfoDictionary = mDict;
            
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        }
    } failure:^(YTKBaseRequest *request) {
        [request yos_checkResponse];
    }];
}

#pragma mark - event response

- (void)tappedLogoutButton {
    NSLog(@"%s", __func__);
    
    [[GVUserDefaults standardUserDefaults] logout];
    YOSPostNotification(YOSNotificationLogout);
    
    [[YOSEaseMobManager sharedManager] logoffWithUnbindDeviceToken:YES];
    
    [SVProgressHUD showInfoWithStatus:@"已退出登录~" maskType:SVProgressHUDMaskTypeClear];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popToRootViewControllerAnimated:YES];
    });
}

#pragma mark - getter & setter 

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
        [_dataSource addObject:@{
                                 @"title" : @"修改密码",
                                 @"message" : @"",
                                 @"rightType" : @(kRightAccessoryTypeArrow)
                                 }];
        
        [_dataSource addObject:@{
                                 @"title" : @"意见反馈",
                                 @"message" : @"",
                                 @"rightType" : @(kRightAccessoryTypeArrow)
                                 }];
        
        [_dataSource addObject:@{
                                 @"title" : @"关于快来吧",
                                 @"message" : @"",
                                 @"rightType" : @(kRightAccessoryTypeArrow)
                                 }];
        
        [_dataSource addObject:@{
                                 @"title" : @"版本更新",
                                 @"message" : [NSString stringWithFormat:@"V%@", [YOSWidget currentAppVersion]],
                                 @"rightType" : @(kRightAccessoryTypeNone)
                                 }];
        
        SDImageCache *cache = [SDImageCache sharedImageCache];
        
        NSUInteger cacheSize = [cache getSize];
        
        CGFloat mb = cacheSize / (1024.0 * 1024.0);
        
        NSLog(@"清楚缓存 %zi, %f", cacheSize, mb);
        
        [_dataSource addObject:@{
                                 @"title" : @"清除缓存",
                                 @"message" : [NSString stringWithFormat:@"%.1fMB", mb],
                                 @"rightType" : @(kRightAccessoryTypeArrow)
                                 }];
        
        [_dataSource addObject:@{
                                 @"title" : @"接受陌生人对话",
                                 @"message" : @"",
                                 @"rightType" : @(kRightAccessoryTypeSwitch)
                                 }];
    }
    
    return _dataSource;
}

@end
