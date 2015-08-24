//
//  YOSUserInfoViewController.m
//  kuailai
//
//  Created by yangyang on 15/8/15.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSAddRequestViewController.h"
#import "YOSSendMessagesViewController.h"
#import "YOSHeadDetailButton.h"
#import "YOSAuditIndividualCell.h"

#import "YOSUserInfoModel.h"

#import "YOSWidget.h"
#import "EDColor.h"
#import "Masonry.h"
#import "UIImage+YOSAdditions.h"
#import "SVProgressHUD+YOSAdditions.h"
#import "YOSEaseMobManager.h"
#import "YOSDBManager.h"

@interface YOSAddRequestViewController() <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) NSMutableArray *cellHeights;

@end

@implementation YOSAddRequestViewController {
    UIScrollView *_scrollView;
    UIView *_contentView;
    
    YOSHeadDetailButton *_headDetailButton;
    
    UIView *_demandTitleContentView;
    UILabel *_demandTitleLabel;
    UILabel *_demandLabel;
    
    UIView *_titleContentView;
    UILabel *_titleLabel;
    
    UIButton *_leftButton;
    UIButton *_rightButton;
}

#pragma mark - life cycles 

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavTitle:@"名片"];
    
    [self setupBackArrow];
    
    [self setupSubviews];
}

- (void)clickLeftItem:(UIButton *)item {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)setupSubviews {
    self.view.backgroundColor = [UIColor whiteColor];
    
    _scrollView = [UIScrollView new];
    [self.view addSubview:_scrollView];
    
    _contentView = [UIView new];
    [_scrollView addSubview:_contentView];
    
    _headDetailButton = [YOSHeadDetailButton new];
    _headDetailButton.showRightAccessory = NO;
    _headDetailButton.userInfoModel = self.userInfoModel;
    
    [_contentView addSubview:_headDetailButton];
    
    _demandTitleContentView = [UIView new];
    _demandTitleContentView.backgroundColor = YOSColorBackgroundGray;
    [_contentView addSubview:_demandTitleContentView];
    
    _demandTitleLabel = [UILabel new];
    _demandTitleLabel.text = @"述求";
    _demandTitleLabel.textColor = YOSColorFontGray;
    _demandTitleLabel.font = YOSFontNormal;
    [_demandTitleContentView addSubview:_demandTitleLabel];
    
    _demandLabel = [UILabel new];
    _demandLabel.numberOfLines = 0;
    _demandLabel.text = (self.userInfoModel.demand.length ? self.userInfoModel.demand : @"暂未填写");
    _demandLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    [_contentView addSubview:_demandLabel];
    
    _titleContentView = [UIView new];
    _titleContentView.backgroundColor = YOSColorBackgroundGray;
    [_contentView addSubview:_titleContentView];
    
    _titleLabel = [UILabel new];
    _titleLabel.text = @"信息";
    _titleLabel.textColor = YOSColorFontGray;
    _titleLabel.font = YOSFontNormal;
    [_titleContentView addSubview:_titleLabel];
    
    _tableView = [UITableView new];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.allowsSelection = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.tableFooterView = [UIView new];
    _tableView.bounces = NO;
    [_contentView addSubview:_tableView];
    
    _leftButton = [UIButton new];
    [_leftButton setTitle:@"同意" forState:UIControlStateNormal];
    [_leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _leftButton.titleLabel.font = YOSFontBig;
    [_leftButton setBackgroundImage:[UIImage yos_imageWithColor:YOSColorGreen size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
    [_leftButton addTarget:self action:@selector(tappedLeftButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_leftButton];
    
    _rightButton = [UIButton new];
    [_rightButton setTitle:@"拒绝" forState:UIControlStateNormal];
    [_rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _rightButton.titleLabel.font = YOSFontBig;
    [_rightButton setBackgroundImage:[UIImage yos_imageWithColor:YOSColorMainRed size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
    [_rightButton addTarget:self action:@selector(tappedRightButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_rightButton];
    
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero).priorityLow();
        make.width.mas_equalTo(YOSScreenWidth);
    }];
    
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero).priorityLow();
        make.bottom.mas_equalTo(_tableView.mas_bottom);
    }];
    
    [_headDetailButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(YOSScreenWidth, 110));
    }];
    
    [_demandTitleContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_headDetailButton.mas_bottom);
        make.left.and.right.mas_equalTo(0);
        make.height.mas_equalTo(30);
    }];
    
    [_demandTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(30);
    }];
    
    NSString *demand = self.userInfoModel.demand;
    
    if (!demand.length) {
        demand = @"暂无诉求";
    }
    
    CGSize size = [demand boundingRectWithSize:CGSizeMake(YOSScreenWidth - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : _demandLabel.font} context:nil].size;
    
    size = CGSizeMake(ceil(size.width), ceil(size.height));
    
    [_demandLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_demandTitleContentView.mas_bottom).offset(10);
        make.left.mas_equalTo(10);
        make.size.mas_equalTo(size);
    }];
    
    [_titleContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_demandLabel.mas_bottom).offset(10);
        make.left.and.right.mas_equalTo(0);
        make.height.mas_equalTo(30);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(30);
    }];
    
    __block CGFloat height = 0.0f;
    [self.cellHeights enumerateObjectsUsingBlock:^(NSNumber *obj, NSUInteger idx, BOOL *stop) {
        height += [obj floatValue];
    }];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero).priorityLow();
        make.width.mas_equalTo(YOSScreenWidth);
        make.top.mas_equalTo(_titleLabel.mas_bottom);
        make.height.mas_equalTo(height);
    }];
    
    if (self.hideButtons) {
        _leftButton.hidden = YES;
        _rightButton.hidden = YES;
        
        return;
    }
    
    BOOL isFriend = [[YOSEaseMobManager sharedManager] isFriendWithUser:self.userInfoModel.hx_user];
    
    NSUInteger isPublic = [self.userInfoModel.is_public integerValue];
    
    // 是朋友, 或者可以接受陌生人消息
    if (isFriend) {
        [_leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.and.bottom.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(YOSScreenWidth, 44));
        }];
        
        _rightButton.hidden = YES;
    } else if (isPublic == 1) {
        [_leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.bottom.mas_equalTo(0);
            make.size.mas_equalTo(_rightButton);
            make.right.mas_equalTo(_rightButton.mas_left);
            make.height.mas_equalTo(44);
        }];
        
        [_rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.and.bottom.mas_equalTo(0);
            make.size.mas_equalTo(_leftButton);
        }];
    } else {
        [_rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.and.bottom.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(YOSScreenWidth, 44));
        }];
        
        _leftButton.hidden = YES;
    }
    
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSNumber *number = self.cellHeights[indexPath.row];
    return [number floatValue];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YOSAuditIndividualCell *cell = [YOSAuditIndividualCell cellWithTableView:tableView];
    
    cell.string = self.dataSource[indexPath.row];
    
    return cell;
}

#pragma mark - event response

- (void)tappedLeftButton {
    NSLog(@"%s", __func__);
    
    BOOL status = [[YOSEaseMobManager sharedManager] acceptBuddy:self.userInfoModel.hx_user];
    
    if (status) {
        [[YOSEaseMobManager sharedManager] getBuddyListSync];
        
        [[YOSDBManager sharedManager] deleteBuddyRequestWithCurrentUser:[YOSWidget getCurrentUserInfoModel].hx_user buddy:self.userInfoModel.hx_user];
        
        [SVProgressHUD showInfoWithStatus:@"已同意~" maskType:SVProgressHUDMaskTypeClear];
        
        YOSPostNotification(YOSNotificationUpdateBuddyRequest);
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popToRootViewControllerAnimated:YES];
        });
    }
}

- (void)tappedRightButton {
    NSLog(@"%s", __func__);
    
    BOOL status = [[YOSEaseMobManager sharedManager] rejuctBuddy:self.userInfoModel.hx_user reason:@""];
    
    if (status) {
        
        [[YOSDBManager sharedManager] deleteBuddyRequestWithCurrentUser:[YOSWidget getCurrentUserInfoModel].hx_user buddy:self.userInfoModel.hx_user];
        
        [SVProgressHUD showInfoWithStatus:@"已拒绝~" maskType:SVProgressHUDMaskTypeClear];
        
        YOSPostNotification(YOSNotificationUpdateBuddyRequest);
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popToRootViewControllerAnimated:YES];
        });
    }
}

#pragma mark - getter & setter

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    
    return _dataSource;
}

- (NSMutableArray *)cellHeights {
    if (!_cellHeights) {
        _cellHeights = [NSMutableArray array];
    }
    
    return _cellHeights;
}

- (void)setUserInfoModel:(YOSUserInfoModel *)userInfoModel {
    _userInfoModel = userInfoModel;
    
    [self.dataSource removeAllObjects];
    
    BOOL isFriend = [[YOSEaseMobManager sharedManager] isFriendWithUser:self.userInfoModel.hx_user];
    
    YOSUserInfoModel *meUserInfoModel = [YOSWidget getCurrentUserInfoModel];
    
    BOOL status = [meUserInfoModel.hx_user isEqualToString:self.userInfoModel.hx_user];
    
    if (isFriend || status) {
        BOOL status0 = userInfoModel.username.length;
        [self.dataSource addObject:[NSString stringWithFormat:@"手机: %@", (status0 ? userInfoModel.username : @"暂未填写")]];
        
        BOOL status1 = userInfoModel.phone.length;
        [self.dataSource addObject:[NSString stringWithFormat:@"座机: %@", (status1 ? userInfoModel.phone : @"暂未填写")]];
        
        BOOL status2 = userInfoModel.email.length;
        [self.dataSource addObject:[NSString stringWithFormat:@"邮箱: %@", (status2 ? userInfoModel.email : @"暂未填写")]];
        
        BOOL status3 = userInfoModel.website.length;
        [self.dataSource addObject:[NSString stringWithFormat:@"网址: %@", (status3 ? userInfoModel.website : @"暂未填写")]];
    } else {
        [self.dataSource addObject:@"手机: 加好友可见"];
        [self.dataSource addObject:@"座机: 加好友可见"];
        [self.dataSource addObject:@"邮箱: 加好友可见"];
        [self.dataSource addObject:@"网址: 加好友可见"];
    }
    
    [self.dataSource enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
        CGSize size = [obj boundingRectWithSize:CGSizeMake(YOSScreenWidth - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : YOSFontNormal} context:nil].size;
        
        size = CGSizeMake(ceil(YOSScreenWidth - 20), ceil(size.height));
        [self.cellHeights addObject:@(size.height + 20)];
    }];
    
}


@end
