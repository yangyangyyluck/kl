//
//  YOSAuditCell.m
//  kuailai
//
//  Created by yangyang on 15/8/6.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSAuditCell.h"

#import "YOSAuditModel.h"

#import "EDColor.h"
#import "UIImageView+WebCache.h"
#import "Masonry.h"


@implementation YOSAuditCell {
    UIImageView *_headImageView;
    UILabel *_nameLabel;
    UILabel *_jobTitleLabel;
    UILabel *_companyLabel;
    UILabel *_auditLabel;
    
    UIView *_topLineView;
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
    _headImageView = [UIImageView new];
    _headImageView.layer.cornerRadius = 20;
    _headImageView.layer.masksToBounds = YES;
    
    [self.contentView addSubview:_headImageView];
    
    _nameLabel = [UILabel new];
    _nameLabel.font = YOSFontBig;
    _nameLabel.textColor = YOSColorFontBlack;
    
    [self.contentView addSubview:_nameLabel];
    
    _jobTitleLabel = [UILabel new];
    _jobTitleLabel.font = YOSFontSmall;
    _jobTitleLabel.textColor = YOSColorFontGray;
    [self.contentView addSubview:_jobTitleLabel];
    
    _companyLabel = [UILabel new];
    _companyLabel.font = [UIFont systemFontOfSize:14.0f];
    _companyLabel.textColor = YOSColorFontGray;
    [self.contentView addSubview:_companyLabel];
    
    _topLineView = [UIView new];
    _topLineView.backgroundColor = YOSColorLineGray;
    
    [self.contentView addSubview:_topLineView];
    
    _bottomLineView = [UIView new];
    _bottomLineView.backgroundColor = YOSColorLineGray;
    
    [self.contentView addSubview:_bottomLineView];
    
    _auditLabel = [UILabel new];
    _auditLabel.font = YOSFontSmall;
    _auditLabel.text = @"已通过";
    
    [self.contentView addSubview:_auditLabel];
    
    [_topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(YOSScreenWidth, 0.5));
        make.left.and.top.mas_equalTo(0);
    }];
    
    [_bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(_topLineView);
        make.left.and.bottom.mas_equalTo(0);
    }];
    
    _topLineView.hidden = YES;
    _bottomLineView.hidden = NO;
    _auditLabel.hidden = YES;
}

#pragma mark -getter & setter


- (void)setAuditModel:(YOSAuditModel *)auditModel {
    _auditModel = auditModel;
    
    if (auditModel.avatar) {
        [_headImageView sd_setImageWithURL:[NSURL URLWithString:auditModel.avatar] placeholderImage:[UIImage imageNamed:@"默认头像"]];
    } else {
        _headImageView.image = [UIImage imageNamed:@"默认头像"];
    }
    
    _nameLabel.text = auditModel.nickname;
    _jobTitleLabel.text = (auditModel.position.length ? auditModel.position : @"暂无职位信息");
    _companyLabel.text = (auditModel.company.length ? auditModel.company : @"暂无公司信息");
    
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.removeExisting = YES;
        
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(self.contentView);
    }];
    
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.removeExisting = YES;
        
        make.left.mas_equalTo(_headImageView.mas_right).offset(8);
        make.top.mas_equalTo(_headImageView).offset(0);
        make.size.mas_equalTo(CGSizeMake(150, 19));
    }];
    
    [_jobTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.removeExisting = YES;
        
        make.centerY.mas_equalTo(_nameLabel);
        make.left.mas_equalTo(_nameLabel.mas_right).offset(8);
        make.size.mas_equalTo(CGSizeMake(120, 16));
    }];
    
    [_companyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.removeExisting = YES;
        
        make.bottom.mas_equalTo(_headImageView).offset(2);
        make.left.mas_equalTo(_nameLabel);
        make.size.mas_equalTo(CGSizeMake(150, 18));
    }];
    
    [_auditLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.removeExisting = YES;
        
        make.centerY.mas_equalTo(_companyLabel);
        make.left.mas_equalTo(_jobTitleLabel);
    }];
    
    // magic number 0 未审核
    //              1 通过
    //              2 拒绝
    _auditLabel.hidden = YES;
    
    if (auditModel.status && [auditModel.status integerValue] == 0) {
        _auditLabel.text = @"未审核";
        _auditLabel.textColor = YOSColorFontBlack;
        _auditLabel.hidden = NO;
    }
    
    if ([auditModel.status integerValue] == 1) {
        _auditLabel.text = @"已通过";
        _auditLabel.textColor = YOSColorGreen;
        _auditLabel.hidden = NO;
    }
    
    if ([auditModel.status integerValue] == 2) {
        _auditLabel.text = @"已拒绝";
        _auditLabel.textColor = YOSColorMainRed;
        _auditLabel.hidden = NO;
    }
    
}

- (void)setShowTopLine:(BOOL)showTopLine {
    _showTopLine = showTopLine;
    
    _topLineView.hidden = !showTopLine;
}

- (void)setShowBottomLine:(BOOL)showBottomLine {
    _showBottomLine = showBottomLine;
    
    _bottomLineView.hidden = !showBottomLine;
}

@end
