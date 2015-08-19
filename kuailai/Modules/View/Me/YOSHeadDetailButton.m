//
//  YOSHeadDetailButton.m
//  kuailai
//
//  Created by yangyang on 15/6/22.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSHeadDetailButton.h"

#import "YOSUserInfoModel.h"

#import "Masonry.h"
#import "UIImageView+WebCache.h"
#import "YOSWidget.h"
#import "UIImage+Blur.h"

@implementation YOSHeadDetailButton {
    // UI
    UIImageView *_imageView;
    UILabel *_nameLabel;
    UILabel *_jobTitleLabel;
    UILabel *_companyLabel;
    
    UIImageView *_rightAccessaryImageView;
    UIImageView *_headBackgroundImageView;
}

- (instancetype)initWithUserInfoModel:(YOSUserInfoModel *)userInfoModel {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _userInfoModel = userInfoModel;
    _showRightAccessory = YES;
    
    [self setupSubviews];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUserInfo) name:YOSNotificationUpdateUserInfo object:nil];
    
    return self;
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
    _headBackgroundImageView = [UIImageView new];
    [self addSubview:_headBackgroundImageView];
    
    _imageView = [UIImageView new];
    _imageView.layer.cornerRadius = 35;
    _imageView.layer.masksToBounds = YES;
    _imageView.layer.borderWidth = 2;
    _imageView.layer.borderColor = [UIColor whiteColor].CGColor;
    [self addSubview:_imageView];
    
    _nameLabel = [UILabel new];
    _nameLabel.textColor = [UIColor blackColor];
    _nameLabel.font = [UIFont systemFontOfSize:16.0f];
    [self addSubview:_nameLabel];
    
    _jobTitleLabel = [UILabel new];
    _jobTitleLabel.textColor = [UIColor blackColor];
    _jobTitleLabel.font = YOSFontSmall;
    [self addSubview:_jobTitleLabel];
    
    _companyLabel = [UILabel new];
    _companyLabel.textColor = [UIColor blackColor];
    _companyLabel.font = YOSFontSmall;
    [self addSubview:_companyLabel];
    
    _rightAccessaryImageView = [UIImageView new];
    [self addSubview:_rightAccessaryImageView];
    
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(17);
        make.centerY.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(70, 70));
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_imageView.mas_right).offset(17);
        make.top.mas_equalTo(_imageView.mas_top).offset(6);
        make.size.mas_equalTo(CGSizeMake(180, 18));
    }];
    
    [_jobTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_nameLabel);
        make.top.mas_equalTo(_nameLabel.mas_bottom).offset(7);
        make.size.mas_equalTo(CGSizeMake(180, 13));
    }];
    
    _companyLabel.preferredMaxLayoutWidth = 180;
    _companyLabel.numberOfLines = 0;
    [_companyLabel sizeToFit];
    [_companyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_nameLabel);
        make.top.mas_equalTo(_jobTitleLabel.mas_bottom).offset(7);
    }];
    
    [_rightAccessaryImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-12);
        make.centerY.mas_equalTo(self);
    }];
    
    [_headBackgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self);
        make.top.and.left.mas_equalTo(0);
    }];
    
    [self setupUserInfo];
}

- (void)setupUserInfo {
    self.clipsToBounds = YES;
    
    _headBackgroundImageView.image = [UIImage imageNamed:@"首页默认图"];
    _headBackgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    if (_userInfoModel.avatar && ![_userInfoModel.avatar isEqualToString:@""]) {
        NSURL *url = [NSURL URLWithString:_userInfoModel.avatar];
        
        [_imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"默认头像"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image) {
                CGFloat quality = 0.001f;
                CGFloat blurred = 0.9f;
                NSData *imageData = UIImageJPEGRepresentation(image, quality);
                UIImage *blurredImage = [[UIImage imageWithData:imageData] blurredImage:blurred];
                
                _headBackgroundImageView.image = blurredImage;
            }
        }];
        
    } else {
        _imageView.image = [UIImage imageNamed:@"默认头像"];
    }
    
    _nameLabel.text = _userInfoModel.nickname;
    _jobTitleLabel.text = YOSIsEmpty(_userInfoModel.position) ? @"还未填写职位信息" : _userInfoModel.position;
    _companyLabel.text = YOSIsEmpty(_userInfoModel.company) ? @"还未填写公司信息" : _userInfoModel.company;
    
    _rightAccessaryImageView.image = [UIImage imageNamed:@"小箭头"];
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)updateUserInfo {
    
    _userInfoModel = [YOSWidget getCurrentUserInfoModel];

    [self setupUserInfo];
}

- (void)setShowRightAccessory:(BOOL)showRightAccessory {
    _showRightAccessory = showRightAccessory;
    
    _rightAccessaryImageView.hidden = !showRightAccessory;
}

- (void)setUserInfoModel:(YOSUserInfoModel *)userInfoModel {
    _userInfoModel = userInfoModel;
    
    [self setupUserInfo];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
