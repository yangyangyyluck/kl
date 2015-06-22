//
//  YOSCellButton.m
//  kuailai
//
//  Created by yangyang on 15/6/22.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSCellButton.h"

#import "EDColor.h"
#import "Masonry.h"

@implementation YOSCellButton {
    NSString *_image;
    NSString *_title;
    
    UIImageView *_imageView;
    UILabel *_label;
    
    UIImageView *_rightAccessoryImageView;
    UIView *_topLineView;
    UIView *_bottomLineView;
}

- (instancetype)initWithImage:(NSString *)image title:(NSString *)title {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _image = image;
    _title = title;
    
    self.backgroundColor = [UIColor whiteColor];
    
    [self setupSubviews];
    
    return self;
}

- (void)setupSubviews {
    _imageView = [UIImageView new];
    _imageView.image = [UIImage imageNamed:_image];
    [self addSubview:_imageView];
    
    _label = [UILabel new];
    _label.font = YOSFontBig;
    _label.textColor = YOSColorFontBlack;
    _label.text = _title;
    [self addSubview:_label];
    
    _rightAccessoryImageView = [UIImageView new];
    _rightAccessoryImageView.image = [UIImage imageNamed:@"小箭头"];
    [self addSubview:_rightAccessoryImageView];
    
    _topLineView = [UIView new];
    _topLineView.backgroundColor = YOSColorLineGray;
    [self addSubview:_topLineView];
    
    _bottomLineView = [UIView new];
    _bottomLineView.backgroundColor = YOSColorLineGray;
    [self addSubview:_bottomLineView];
    
    [_imageView sizeToFit];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(self);
    }];
    
    [_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_imageView.mas_right).offset(15);
        make.centerY.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(220, 16));
    }];
    
    [_rightAccessoryImageView sizeToFit];
    [_rightAccessoryImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(-10);
    }];
    
    [_topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(YOSScreenWidth, 0.5));
    }];
    
    [_bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.bottom.mas_equalTo(0);
        make.size.mas_equalTo(_topLineView);
    }];
    
    _topLineView.hidden = YES;
}

#pragma mark - getter & setter

- (void)setShowTopLine:(BOOL)showTopLine {
    _showBottomLine = showTopLine;
    
    _topLineView.hidden = !showTopLine;
}

- (void)setShowBottomLine:(BOOL)showBottomLine {
    _showBottomLine = showBottomLine;
    
    _bottomLineView.hidden = !showBottomLine;
}

- (void)setShowRightAccessory:(BOOL)showRightAccessory {
    _showRightAccessory = showRightAccessory;
    
    _rightAccessoryImageView.hidden = !showRightAccessory;
}


@end
