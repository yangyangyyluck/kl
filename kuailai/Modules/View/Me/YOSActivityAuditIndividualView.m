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

#import "YOSWidget.h"
#import "EDColor.h"
#import "Masonry.h"
#import "UIImage+YOSAdditions.h"

@interface YOSActivityAuditIndividualView() <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) NSMutableArray *cellHeights;

@end

@implementation YOSActivityAuditIndividualView {
    YOSHeadDetailButton *_headDetailButton;
    UILabel *_titleLabel;
    
    UIButton *_leftButton;
    UIButton *_rightButton;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (!self) {
        return nil;
    }
    
    self.backgroundColor = YOSColorBackgroundGray;
    
    [self.dataSource enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
        CGSize size = [obj boundingRectWithSize:CGSizeMake(YOSScreenWidth - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : YOSFontNormal} context:nil].size;
        
        size = CGSizeMake(ceil(YOSScreenWidth - 20), ceil(size.height));
        [self.cellHeights addObject:@(size.height + 20)];
    }];
    
    [self setupSubviews];
    
    return self;
}

- (void)setupSubviews {
    _headDetailButton = [[YOSHeadDetailButton alloc] initWithUserInfoModel:[YOSWidget getCurrentUserInfoModel]];
    _headDetailButton.showRightAccessory = NO;
    
    [self addSubview:_headDetailButton];
    
    _titleLabel = [UILabel new];
    _titleLabel.text = @"信息";
    _titleLabel.textColor = YOSColorFontGray;
    _titleLabel.font = YOSFontNormal;
    [self addSubview:_titleLabel];
    
    _tableView = [UITableView new];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.allowsSelection = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.tableFooterView = [UIView new];
    [self addSubview:_tableView];
    
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
    [_rightButton setBackgroundImage:[UIImage yos_imageWithColor:YOSColorMainRed size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
    [_rightButton addTarget:self action:@selector(tappedRightButton) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_rightButton];
    
    [_headDetailButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(YOSScreenWidth, 110));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(_headDetailButton.mas_bottom);
        make.height.mas_equalTo(30);
    }];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero).priorityLow();
        make.top.mas_equalTo(_titleLabel.mas_bottom);
        make.bottom.mas_equalTo(-44);
    }];
    
    [_leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.bottom.mas_equalTo(0);
//        make.size.mas_equalTo(CGSizeMake(YOSScreenWidth / 2, 44));
        make.size.mas_equalTo(_rightButton);
        make.right.mas_equalTo(_rightButton.mas_left);
        make.height.mas_equalTo(44);
    }];
    
    [_rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.and.bottom.mas_equalTo(0);
        make.size.mas_equalTo(_leftButton);
    }];
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
}

- (void)tappedLeftButton {
    NSLog(@"%s", __func__);
}

#pragma mark - getter & setter

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
        [_dataSource addObject:@"和额啊阿拉山口大家来。你叫啥啊?"];
        [_dataSource addObject:@"和额啊阿拉山口大家来。这是谁啊。哦，呀呀呀，来吗啊，的，的，你叫啥啊?你叫啥啊?你叫啥啊?你叫啥啊?你叫啥啊?你叫啥啊?你叫啥啊?你叫啥啊?你叫啥啊?你叫啥啊?"];
        [_dataSource addObject:@"和额啊阿拉山口大家来。这是谁啊。哦，呀呀呀，来吗啊，的，的，你叫啥啊?你叫啥啊?你叫啥啊?你叫啥啊?你叫啥啊?你叫啥啊?你叫啥啊?"];
        [_dataSource addObject:@"和额啊阿拉山口大家啥啊?你叫啥啊?你叫啥啊?"];
        [_dataSource addObject:@"和额啊阿拉山口大家来。这是谁啊。哦，呀呀呀，来吗啊，的，的，你叫啥啊?你叫啥啊?你叫啥啊?你叫啥啊?你叫啥啊?你叫啥啊?你叫啥啊?你叫啥啊?你叫啥啊?你叫啥啊?"];
        [_dataSource addObject:@"和额啊阿"];
        [_dataSource addObject:@"和额啊阿拉山口大家来。这是谁啊。哦，呀呀呀，来吗啊，的，的，你叫啥啊?你叫啥啊?你叫啥啊?你叫啥啊?你叫啥啊?你"];
        [_dataSource addObject:@"和额啊阿拉山口大家来。这是谁啊。哦，呀呀呀，来吗啊，的，的，你叫啥啊?你叫啥啊?你叫啥啊?你叫啥啊?你叫啊?你叫啥啊?你叫啥啊?你叫啥啊?你叫啥啊?"];
    }
    
    return _dataSource;
}

- (NSMutableArray *)cellHeights {
    if (!_cellHeights) {
        _cellHeights = [NSMutableArray array];
    }
    
    return _cellHeights;
}


@end
