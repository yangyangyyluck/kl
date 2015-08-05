//
//  YOSSettingViewController.m
//  kuailai
//
//  Created by yangyang on 15/8/5.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSSettingViewController.h"
#import "YOSSettingCell.h"

#import "UIView+YOSAdditions.h"
#import "UIImage+YOSAdditions.h"
#import "Masonry.h"
#import "GVUserDefaults+YOSProperties.h"

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
        [cell showSwitchWithSelectedBlock:^{
            YOSLog(@"selected");
        } unSelectedBlock:^{
            YOSLog(@"unselected");
        }];
        
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
    
    if (rightType == kRightAccessoryTypeArrow) {
        NSLog(@"%s", __func__);
    }
    
}

#pragma mark - event response

- (void)tappedLogoutButton {
    NSLog(@"%s", __func__);
    
    [[GVUserDefaults standardUserDefaults] logout];
    
    YOSPostNotification(YOSNotificationLogout);
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
                                 @"title" : @"关于快来",
                                 @"message" : @"",
                                 @"rightType" : @(kRightAccessoryTypeArrow)
                                 }];
        
        [_dataSource addObject:@{
                                 @"title" : @"版本更新",
                                 @"message" : @"V1.0",
                                 @"rightType" : @(kRightAccessoryTypeNone)
                                 }];
        
        [_dataSource addObject:@{
                                 @"title" : @"清除缓存",
                                 @"message" : @"1.0MB",
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
