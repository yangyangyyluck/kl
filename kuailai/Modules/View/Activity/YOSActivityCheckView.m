//
//  YOSActivityTypeView.m
//  kuailai
//
//  Created by yangyang on 15/5/30.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSActivityCheckView.h"
#import "EDColor.h"
#import "Masonry.h"

@implementation YOSActivityCheckView {
    UIView *_topView;
    UILabel *_titleLabel;
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
    _topView = [UIView new];
    [self addSubview:_topView];
    
    _titleLabel = [UILabel new];
    _titleLabel.font = YOSFontNormal;
    _titleLabel.textColor = YOSColorFontBlack;
    _titleLabel.text = @"审核报名";
    
    _swh = [UISwitch new];
    _swh.onTintColor = YOSRGB(76, 197, 158);
    [_swh setOn:YES];
    [_swh addTarget:self action:@selector(tappedSwitch:) forControlEvents:UIControlEventValueChanged];
    
    [_topView addSubview:_titleLabel];
    [_topView addSubview:_swh];
    
    UILabel *titleLabel2 = [UILabel new];
    titleLabel2.text = @"报名所需资料:";
    titleLabel2.font = YOSFontNormal;
    titleLabel2.textColor = YOSColorFontGray;
    [self addSubview:titleLabel2];
    
    
    
    // setup constraints
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.right.left.mas_equalTo(0);
        make.height.mas_equalTo(44);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.centerY.mas_equalTo(_topView);
    }];
    
    [_swh mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 35));
        make.centerY.mas_equalTo(_topView);
        make.right.mas_equalTo(-4);
    }];
    
    [titleLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_topView.mas_bottom);
        make.leading.mas_equalTo(_titleLabel);
        make.size.mas_equalTo(CGSizeMake(YOSScreenWidth - 8, 44));
    }];
}

- (void)tappedSwitch:(UISwitch *)swh {
    if (swh.on) {
        _titleLabel.textColor = YOSColorFontBlack;
    } else {
        _titleLabel.textColor = YOSColorFontGray;
    }
}

#pragma mark - public methods

- (CGFloat)currentHeight {
    return 44 + 44 + 25 * 2 + 15 + 20;
}

@end
