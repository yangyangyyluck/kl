//
//  YOSHobbyButton.m
//  kuailai
//
//  Created by yangyang on 15/8/14.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSHobbyButton.h"

#import "Masonry.h"
#import "EDColor.h"

@implementation YOSHobbyButton {
    NSString *_imageName;
    NSString *_title;
    
    UIView *_topLineView;
    UIView *_bottomLineView;
    UIView *_leftLineView;
    UIView *_rightLineView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (!self) {
        return nil;
    }
    
    return self;
}

- (instancetype)initWithImageName:(NSString *)imageName title:(NSString *)title {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _imageName = imageName;
    _title = title;
    
    [self setupSubviews];
    
    return self;
}

- (void)setupSubviews {
    
    [self setTitle:_title forState:UIControlStateNormal];
    self.titleLabel.font = YOSFontBold;
    [self setImage:[UIImage imageNamed:_imageName] forState:UIControlStateNormal];
    [self setTitleColor:YOSColorFontBlack forState:UIControlStateNormal];
    
    self.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    
    _topLineView = [UIView new];
    _topLineView.backgroundColor = YOSColorLineGray;
    [self addSubview:_topLineView];
    
    _leftLineView = [UIView new];
    _leftLineView.backgroundColor = YOSColorLineGray;
    [self addSubview:_leftLineView];
    
    _bottomLineView = [UIView new];
    _bottomLineView.backgroundColor = YOSColorLineGray;
    [self addSubview:_bottomLineView];
    
    _rightLineView = [UIView new];
    _rightLineView.backgroundColor = YOSColorLineGray;
    [self addSubview:_rightLineView];
    
    [_leftLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.bottom.mas_equalTo(0);
        make.width.mas_equalTo(0.5);
    }];
    
    [_rightLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.and.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(0.5);
    }];
    
    [_topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.top.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    
    [_bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.bottom.and.right.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    
}

#pragma mark - getter & setter 

- (void)setShowTopLine:(BOOL)showTopLine {
    _showTopLine = showTopLine;
    
    _topLineView.hidden = !showTopLine;
}

- (void)setShowBottomLine:(BOOL)showBottomLine {
    _showBottomLine = showBottomLine;
    
    _bottomLineView.hidden = !showBottomLine;
}

- (void)setShowLeftLine:(BOOL)showLeftLine {
    _showLeftLine = showLeftLine;
    
    _leftLineView.hidden = !showLeftLine;
}

- (void)setShowRightLine:(BOOL)showRightLine {
    _showRightLine = showRightLine;
    
    _rightLineView.hidden = !showRightLine;
}

@end
