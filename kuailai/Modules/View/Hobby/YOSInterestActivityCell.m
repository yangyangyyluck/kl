//
//  YOSInterestActivityCell.m
//  kuailai
//
//  Created by yangyang on 15/8/15.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSInterestActivityCell.h"

#import "YOSActivityListModel.h"

#import "Masonry.h"
#import "EDColor.h"
#import "UIImageView+WebCache.h"

NSString static * const kHomeCellDefaultImage = @"首页默认图";

@implementation YOSInterestActivityCell {
    UIImageView *_imageView;
    UILabel *_titleLabel;
    UILabel *_categoryLabel;
    UILabel *_positionLabel;
    
    UILabel *_statusLabel;
    
    UIView *_bottomLineView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (!self) {
        return nil;
    }
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self setupSubviews];
    
    return self;
}

- (void)setupSubviews {
    _imageView = [UIImageView new];
    [self.contentView addSubview:_imageView];
    
    _titleLabel = [UILabel new];
    _titleLabel.font = YOSFontNormal;
    _titleLabel.textColor = YOSColorFontBlack;
    [self.contentView addSubview:_titleLabel];
    
    _categoryLabel = [UILabel new];
    _categoryLabel.font = YOSFontNormal;
    _categoryLabel.textColor = YOSColorFontGray;
    [self.contentView addSubview:_categoryLabel];
    
    _positionLabel = [UILabel new];
    _positionLabel.font = YOSFontNormal;
    _positionLabel.textColor = YOSColorFontGray;
    [self.contentView addSubview:_positionLabel];
    
    _statusLabel = [UILabel new];
    _statusLabel.font = [UIFont boldSystemFontOfSize:12.0f];
    _statusLabel.textColor = YOSColorGreen;
    _statusLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_statusLabel];
    
    _bottomLineView = [UIView new];
    _bottomLineView.backgroundColor = YOSColorLineGray;
    [self.contentView addSubview:_bottomLineView];
    
    [self setupConstraints];
}

- (void)setupConstraints {
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(100);
        make.left.and.top.mas_equalTo(10);
        make.bottom.mas_equalTo(-10);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_imageView).offset(3);
        make.left.mas_equalTo(_imageView.mas_right).offset(10);
        make.right.mas_equalTo(_statusLabel.mas_left).offset(-10);
    }];
    
    [_categoryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_imageView);
        make.left.and.right.mas_equalTo(_titleLabel);
    }];
    
    [_positionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_imageView.mas_bottom).offset(-3);
        make.left.and.right.mas_equalTo(_titleLabel);
    }];
    
    [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.centerY.mas_equalTo(_titleLabel);
    }];
    
    [_bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.bottom.and.right.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
}

- (void)setActivityListModel:(YOSActivityListModel *)activityListModel {
    _activityListModel = activityListModel;
    
    _titleLabel.text = activityListModel.title;
    if (activityListModel.thumb.length) {
        [_imageView sd_setImageWithURL:[NSURL URLWithString:activityListModel.thumb] placeholderImage:[UIImage imageNamed:@"活动默认图"]];
    } else {
        _imageView.image = [UIImage imageNamed:@"活动默认图"];
    }
    
    _categoryLabel.text = [NSString stringWithFormat:@"类别: %@", activityListModel.typeName];
    
    _positionLabel.text = [NSString stringWithFormat:@"地点: %@%@", YOSFliterNil2String(activityListModel.cityName), YOSFliterNil2String(activityListModel.areaName)];
    
    NSTimeInterval start_time = [activityListModel.start_time doubleValue];
    
    NSTimeInterval end_time = [activityListModel.end_time doubleValue];
    
    NSTimeInterval now_time = [[NSDate date] timeIntervalSince1970];
    
    if (start_time > now_time) {
        _statusLabel.text = @"未开始";
        _statusLabel.textColor = YOSColorGreen;
    }
    
    if (start_time < now_time && now_time < end_time) {
        _statusLabel.text = @"进行中";
        _statusLabel.textColor = YOSColorMainRed;
    }
    
    if (now_time > end_time) {
        _statusLabel.text = @"已过期";
        _statusLabel.textColor = YOSColorFontGray;
    }
    
}

@end
