//
//  YOSActivityAuditIndividualView.m
//  kuailai
//
//  Created by yangyang on 15/7/2.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSActivityAuditIndividualView.h"
#import "YOSHeadDetailButton.h"
#import "YOSAuditIndividualCell.h"

#import "YOSUserInfoModel.h"

#import "YOSUserAuditRegisterRequest.h"

#import "YOSWidget.h"
#import "EDColor.h"
#import "Masonry.h"
#import "UIImage+YOSAdditions.h"
#import "SVProgressHUD+YOSAdditions.h"

@interface YOSActivityAuditIndividualView() <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIImageView *placeholderImageView;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) NSMutableArray *cellHeights;

@end

@implementation YOSActivityAuditIndividualView {
    YOSHeadDetailButton *_headDetailButton;
    UIImageView *_stampImageView;
    
    UIView *_titleContentView;
    UILabel *_titleLabel;
    
    UIButton *_leftButton;
    UIButton *_rightButton;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (!self) {
        return nil;
    }
    
    [self setupSubviews];
    
    return self;
}

- (void)setupSubviews {
    self.backgroundColor = [UIColor whiteColor];
    
    _headDetailButton = [YOSHeadDetailButton new];
    _headDetailButton.showRightAccessory = NO;
    
    [self addSubview:_headDetailButton];
    
    _stampImageView = [UIImageView new];
    [self addSubview:_stampImageView];
    
    _titleContentView = [UIView new];
    _titleContentView.backgroundColor = YOSColorBackgroundGray;
    [self addSubview:_titleContentView];
    
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
    [self addSubview:_tableView];
    
    _placeholderImageView = [UIImageView new];
    _placeholderImageView.image = [UIImage imageNamed:@"快来水印"];
    [self addSubview:_placeholderImageView];
    
    _leftButton = [UIButton new];
    [_leftButton setTitle:@"拒绝" forState:UIControlStateNormal];
    [_leftButton setTitleColor:YOSColorFontBlack forState:UIControlStateNormal];
    _leftButton.titleLabel.font = YOSFontBig;
    [_leftButton setBackgroundImage:[UIImage yos_imageWithColor:YOSRGB(215, 211, 211) size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
    [_leftButton addTarget:self action:@selector(tappedLeftButton) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_leftButton];
    
    _rightButton = [UIButton new];
    [_rightButton setTitle:@"审核通过" forState:UIControlStateNormal];
    [_rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _rightButton.titleLabel.font = YOSFontBig;
    [_rightButton setBackgroundImage:[UIImage yos_imageWithColor:YOSColorGreen size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
    [_rightButton addTarget:self action:@selector(tappedRightButton) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_rightButton];
    
    [_headDetailButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(YOSScreenWidth, 110));
    }];
    
    [_stampImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(85, 85));
        make.centerY.mas_equalTo(_headDetailButton);
        make.right.mas_equalTo(0);
    }];
    
    [_titleContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_headDetailButton.mas_bottom);
        make.left.and.right.mas_equalTo(0);
        make.height.mas_equalTo(30);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(30);
    }];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero).priorityLow();
        make.top.mas_equalTo(_titleLabel.mas_bottom);
        make.bottom.mas_equalTo(-44);
    }];
    
    [_placeholderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(_tableView);
    }];
    
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
    
    _stampImageView.hidden = YES;
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

- (void)tappedRightButton {
    NSLog(@"%s", __func__);
    
    [self sendNetworkRequestWithStatus:YOSUserAuditRegisterTypePass];
}

- (void)tappedLeftButton {
    NSLog(@"%s", __func__);
    
    [self sendNetworkRequestWithStatus:YOSUserAuditRegisterTypeRefuse];
}

#pragma mark - network

- (void)sendNetworkRequestWithStatus:(YOSUserAuditRegisterType)status {
    YOSUserAuditRegisterRequest *request = [[YOSUserAuditRegisterRequest alloc] initWithID:self.userInfoModel.ID andStatus:status];
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    [request startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        if ([request yos_checkResponse]) {
            NSLog(@"%s", __func__);
        }
    } failure:^(YTKBaseRequest *request) {
        [SVProgressHUD dismiss];
        [request yos_checkResponse];
    }];
}

#pragma mark - getter & setter

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
//        [_dataSource addObject:@"和额啊阿拉山口大家来。你叫啥啊?"];
//        [_dataSource addObject:@"和额啊阿拉山口大家来。这是谁啊。哦，呀呀呀，来吗啊，的，的，你叫啥啊?你叫啥啊?你叫啥啊?你叫啥啊?你叫啥啊?你叫啥啊?你叫啥啊?你叫啥啊?你叫啥啊?你叫啥啊?"];
//        [_dataSource addObject:@"和额啊阿拉山口大家来。这是谁啊。哦，呀呀呀，来吗啊，的，的，你叫啥啊?你叫啥啊?你叫啥啊?你叫啥啊?你叫啥啊?你叫啥啊?你叫啥啊?"];
//        [_dataSource addObject:@"和额啊阿拉山口大家啥啊?你叫啥啊?你叫啥啊?"];
//        [_dataSource addObject:@"和额啊阿拉山口大家来。这是谁啊。哦，呀呀呀，来吗啊，的，的，你叫啥啊?你叫啥啊?你叫啥啊?你叫啥啊?你叫啥啊?你叫啥啊?你叫啥啊?你叫啥啊?你叫啥啊?你叫啥啊?"];
//        [_dataSource addObject:@"和额啊阿"];
//        [_dataSource addObject:@"和额啊阿拉山口大家来。这是谁啊。哦，呀呀呀，来吗啊，的，的，你叫啥啊?你叫啥啊?你叫啥啊?你叫啥啊?你叫啥啊?你"];
//        [_dataSource addObject:@"和额啊阿拉山口大家来。这是谁啊。哦，呀呀呀，来吗啊，的，的，你叫啥啊?你叫啥啊?你叫啥啊?你叫啥啊?你叫啊?你叫啥啊?你叫啥啊?你叫啥啊?你叫啥啊?"];
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

    if (userInfoModel.phone.length) {
        [self.dataSource addObject:[NSString stringWithFormat:@"手机号: %@", userInfoModel.phone]];
    }
    
    if (userInfoModel.work_experience_name.length) {
        [self.dataSource addObject:[NSString stringWithFormat:@"工作年限: %@", userInfoModel.work_experience_name]];
    }
    
    if (userInfoModel.degree_name.length) {
        [self.dataSource addObject:[NSString stringWithFormat:@"学历: %@", userInfoModel.degree_name]];
    }
    
    [self.dataSource enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
        CGSize size = [obj boundingRectWithSize:CGSizeMake(YOSScreenWidth - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : YOSFontNormal} context:nil].size;
        
        size = CGSizeMake(ceil(YOSScreenWidth - 20), ceil(size.height));
        [self.cellHeights addObject:@(size.height + 20)];
    }];
    
    [self.tableView reloadData];
    self.tableView.hidden = !self.dataSource.count;
    
    // 未审核
    if ([userInfoModel.status integerValue] == 0) {
        _stampImageView.hidden = YES;
        _leftButton.enabled = YES;
        _rightButton.enabled = YES;
    }
    
    // 通过审核
    if ([userInfoModel.status integerValue] == 1) {
        _stampImageView.image = [UIImage imageNamed:@"已通过印章"];
        _stampImageView.hidden = NO;
        _leftButton.enabled = NO;
        _rightButton.enabled = NO;
    }
    
    // 已拒绝
    if ([userInfoModel.status integerValue] == 2) {
        _stampImageView.image = [UIImage imageNamed:@"已拒绝印章"];
        _stampImageView.hidden = NO;
        _leftButton.enabled = NO;
        _rightButton.enabled = NO;
    }
    
    _headDetailButton.userInfoModel = userInfoModel;

}


@end
