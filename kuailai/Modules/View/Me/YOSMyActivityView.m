//
//  YOSMyReleaseActivityView.m
//  kuailai
//
//  Created by yangyang on 15/6/30.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSMyActivityView.h"

#import "EDColor.h"

#import "UIView+YOSAdditions.h"
#import "Masonry.h"

@implementation YOSMyActivityView {
    UIImageView *_imageView;
    UILabel *_titleLabel;
    UIImageView *_subImageView0;
    UIImageView *_subImageView1;
    UIImageView *_subImageView2;
    
    UILabel *_subTitle0;
    UILabel *_subTitle1;
    UILabel *_subTitle2;
    
    UIView *_topLineView;
    UIView *_bottomLineView;
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
    _imageView = [UIImageView new];
    _imageView.layer.cornerRadius = 3;
    _imageView.layer.masksToBounds = YES;
    [self addSubview:_imageView];
    _imageView.image = [UIImage imageNamed:@"发布活动"];
    
    _titleLabel = [UILabel new];
    _titleLabel.textColor = YOSColorFontBlack;
    _titleLabel.font = YOSFontBig;
    [self addSubview:_titleLabel];
    _titleLabel.text = @"这是一个活动这是一个活动这是一个活动这是一个活动这是一个活动";
    
    _subImageView0 = [UIImageView new];
    _subImageView0.image = [UIImage imageNamed:@"活动地点"];
    [self addSubview:_subImageView0];
    
    _subImageView1 = [UIImageView new];
    _subImageView1.image = [UIImage imageNamed:@"活动时间"];
    [self addSubview:_subImageView1];
    
    _subImageView2 = [UIImageView new];
    _subImageView2.image = [UIImage imageNamed:@"报名费"];
    _subImageView1.backgroundColor = YOSColorRandom;
    _subImageView2.backgroundColor = YOSColorRandom;
    [self addSubview:_subImageView2];
    
    _subTitle0 = [UILabel new];
    _subTitle0.textColor = YOSColorFontGray;
    _subTitle0.font = YOSFontSmall;
    
    _subTitle1 = [_subTitle0 yos_copySelf];
    _subTitle2 = [_subTitle0 yos_copySelf];
    
    _subTitle0.text = @"朝阳区 乌龟街道";
    _subTitle1.text = @"2014-10-11 一 2014-11-11";
    _subTitle2.text = @"¥ 1500";
    
    [self addSubview:_subTitle0];
    [self addSubview:_subTitle1];
    [self addSubview:_subTitle2];
    
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(15);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
    
    CGFloat maxWidth = 210;
    if (YOSIsIphone6P) {
        maxWidth = 230;
    }
    
    if (YOSIsIphone6) {
        maxWidth = 220;
    }
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(maxWidth);
        make.top.mas_equalTo(_imageView);
        make.left.mas_equalTo(_imageView.mas_right).offset(10);
    }];
    
    [_subImageView0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_titleLabel).offset(-2);
        make.top.mas_equalTo(_titleLabel.mas_bottom).offset(5);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
    
    [_subTitle0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(maxWidth);
        make.left.mas_equalTo(_subImageView0.mas_right).offset(3);
        make.centerY.mas_equalTo(_subImageView0);
    }];
    
    [_subImageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_subImageView0);
        make.size.mas_equalTo(_subImageView0);
        make.top.mas_equalTo(_subImageView0.mas_bottom).offset(5);
    }];
    

    [_subTitle1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(maxWidth);
        make.left.mas_equalTo(_subTitle0);
        make.centerY.mas_equalTo(_subImageView1);
    }];
    
    [_subImageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_subImageView0);
        make.size.mas_equalTo(CGSizeMake(15, 15));
        make.top.mas_equalTo(_subImageView1.mas_bottom).offset(5);
    }];
    
    [_subTitle2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(maxWidth);
        make.left.mas_equalTo(_subTitle0);
        make.centerY.mas_equalTo(_subImageView2);
    }];

}

@end
