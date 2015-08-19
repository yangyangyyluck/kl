//
//  YOSAddBuddyCell.m
//  kuailai
//
//  Created by yangyang on 15/6/18.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSAddBuddyCell.h"

#import "YOSUserInfoModel.h"

#import "EDColor.h"
#import "UIImageView+WebCache.h"
#import "Masonry.h"
#import "YOSEaseMobManager.h"


@implementation YOSAddBuddyCell {
    UIImageView *_headImageView;
    UILabel *_nameLabel;
    UILabel *_jobTitleLabel;
    UILabel *_companyLabel;
    UIButton *_rightButton;
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
    
    _rightButton = [UIButton new];
    [_rightButton addTarget:self action:@selector(tappedRightButton) forControlEvents:UIControlEventTouchUpInside];
    [_rightButton setTitle:@"添加" forState:UIControlStateNormal];
    _rightButton.titleLabel.font = YOSFontBold;
    [_rightButton setTitleColor:YOSColorGreen forState:UIControlStateNormal];
    _rightButton.layer.borderColor = YOSColorGreen.CGColor;
    _rightButton.layer.borderWidth = 0.5f;
    _rightButton.layer.masksToBounds = YES;
    _rightButton.adjustsImageWhenHighlighted = YES;
    [self.contentView addSubview:_rightButton];
    
    _auditLabel = [UILabel new];
    _auditLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    _auditLabel.textColor = YOSColorGreen;
    _auditLabel.text = @"已添加";
    [self.contentView addSubview:_auditLabel];
    
    [_rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 30));
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(-12);
    }];
    
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
}

#pragma mark - event response

- (void)tappedRightButton {
    NSLog(@"%s", __func__);
    
    BOOL status = [[YOSEaseMobManager sharedManager] addBuddy:self.userInfoModel.hx_user message:@"请求添加您为好友"];
    
    if (status) {
        self.userInfoModel.isTappedAddButton = YES;
        
        _rightButton.hidden = YES;
        _auditLabel.hidden = NO;
        _auditLabel.text = @"等待验证";
        _auditLabel.textColor = YOSColorMainRed;
    }
}

#pragma mark -getter & setter

- (void)setUserInfoModel:(YOSUserInfoModel *)userInfoModel {
    _userInfoModel = userInfoModel;
    
    if (userInfoModel.avatar) {
        [_headImageView sd_setImageWithURL:[NSURL URLWithString:userInfoModel.avatar] placeholderImage:[UIImage imageNamed:@"默认头像"]];
    } else {
        _headImageView.image = [UIImage imageNamed:@"默认头像"];
    }
    
    _nameLabel.text = userInfoModel.nickname;
    _jobTitleLabel.text = (userInfoModel.position.length ? userInfoModel.position : @"暂无职位信息");
    _companyLabel.text = (userInfoModel.company.length ? userInfoModel.company : @"暂无公司信息");
    
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
        make.size.mas_equalTo(CGSizeMake(100, 19));
    }];
    
    [_jobTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.removeExisting = YES;
        
        make.centerY.mas_equalTo(_nameLabel);
        make.left.mas_equalTo(_nameLabel.mas_right).offset(8);
        make.size.mas_equalTo(CGSizeMake(75, 16));
    }];
    
    [_companyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.removeExisting = YES;
        
        make.bottom.mas_equalTo(_headImageView).offset(2);
        make.left.mas_equalTo(_nameLabel);
        make.size.mas_equalTo(CGSizeMake(150, 18));
    }];
    
    [_auditLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.removeExisting = YES;
        
        make.center.mas_equalTo(_rightButton);
    }];
    
    _auditLabel.hidden = YES;
    
    if (userInfoModel.friendType == YOSFriendTypeBoth) {
        _auditLabel.hidden = NO;
        _auditLabel.text = @"已添加";
        _auditLabel.textColor = YOSColorGreen;
        _rightButton.hidden = YES;
    } else {
        _auditLabel.hidden = YES;
        _rightButton.hidden = NO;
    }
    
    if (userInfoModel.isTappedAddButton) {
        _rightButton.hidden = YES;
        _auditLabel.hidden = NO;
        _auditLabel.text = @"等待验证";
        _auditLabel.textColor = YOSColorMainRed;
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
