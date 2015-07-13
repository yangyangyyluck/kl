//
//  YOSTimeView.m
//  kuailai
//
//  Created by yangyang on 15/7/13.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSTimeView.h"

#import "EDColor.h"
#import "Masonry.h"

@implementation YOSTimeView {
    UILabel *_leftLabel;
    UILabel *_rightLabel;
    UILabel *_bottomLabel;
    
    UIView *_topLineView;
    UIView *_bottomLineView;
    
    UISwitch *_swh;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    
    self.backgroundColor = [UIColor whiteColor];
    
    [self setupSubviews];
    
    return self;
}

- (void)setupSubviews {
    _leftLabel = [UILabel new];
    _leftLabel.textColor = YOSColorMainRed;
    _leftLabel.font = [UIFont boldSystemFontOfSize:22.0f];
    [self addSubview:_leftLabel];
    _leftLabel.text = @"10:30AM";
    
    _rightLabel = [UILabel new];
    _rightLabel.textColor = YOSColorMainRed;
    _rightLabel.font = YOSFontNormal;
    [self addSubview:_rightLabel];
    _rightLabel.text = @"2014-10-17";
    
    _bottomLabel = [UILabel new];
    _bottomLabel.textColor = YOSColorFontGray;
    _bottomLabel.font = YOSFontSmall;
    [self addSubview:_bottomLabel];
    _bottomLabel.text = @"5天13小时47分钟后响铃";
    
    _swh = [UISwitch new];
    _swh.onTintColor = YOSRGB(76, 197, 158);
    [_swh setOn:YES];
    [_swh addTarget:self action:@selector(tappedSwitch:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:_swh];
    
    _topLineView = [UIView new];
    _topLineView.backgroundColor = YOSColorLineGray;
    [self addSubview:_topLineView];
    
    _bottomLineView = [UIView new];
    _bottomLineView.backgroundColor = YOSColorLineGray;
    [self addSubview:_bottomLineView];
    
    [_leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.mas_equalTo(10);
    }];
    
    [_rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_leftLabel.mas_right).offset(30);
        make.centerY.mas_equalTo(_leftLabel);
    }];
    
    [_bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.bottom.mas_equalTo(-10);
    }];
    
    [_swh mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(-10);
    }];
    
    [_topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(YOSScreenWidth, 0.5));
        make.top.and.left.mas_equalTo(0);
    }];
    
    [_bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(_topLineView);
        make.left.and.bottom.mas_equalTo(0);
    }];
}

- (void)tappedSwitch:(UISwitch *)swh {
    NSLog(@"%s", __func__);
}

@end
