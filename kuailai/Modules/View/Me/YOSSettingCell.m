//
//  YOSSettingCell.m
//  kuailai
//
//  Created by yangyang on 15/8/5.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSSettingCell.h"

#import "Masonry.h"
#import "EDColor.h"

@implementation YOSSettingCell {
    UIView *_topLineView;
    UIView *_bottomLineView;
    UIImageView *_rightAccessoryImageView;
    
    UILabel *_leftLabel;
    UILabel *_rightLabel;
    UISwitch *_switch;
    
    voidBlock _selectedBlock;
    voidBlock _unSelectedBlock;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (!self) {
        return nil;
    }
    
    [self setupSubviews];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return self;
}

- (void)setupSubviews {
    _topLineView = [UIView new];
    _topLineView.backgroundColor = YOSColorLineGray;
    [self.contentView addSubview:_topLineView];
    
    _bottomLineView = [UIView new];
    _bottomLineView.backgroundColor = YOSColorLineGray;
    [self.contentView addSubview:_bottomLineView];
    
    _rightAccessoryImageView = [UIImageView new];
    _rightAccessoryImageView.image = [UIImage imageNamed:@"小箭头"];
    [self.contentView addSubview:_rightAccessoryImageView];
    
    _leftLabel = [UILabel new];
    _leftLabel.font = YOSFontBold;
    _leftLabel.textColor = YOSColorFontBlack;
    [self.contentView addSubview:_leftLabel];
    
    _rightLabel = [UILabel new];
    _rightLabel.font = YOSFontNormal;
    _rightLabel.textColor = YOSColorFontGray;
    [self.contentView addSubview:_rightLabel];
    
    _switch = [UISwitch new];
    _switch.onTintColor = YOSRGB(76, 197, 158);
    _switch.on = YES;
    [_switch addTarget:self action:@selector(valueChanged) forControlEvents:UIControlEventValueChanged];
    [self.contentView addSubview:_switch];
    
    [_topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(YOSScreenWidth, 0.5));
        make.top.and.left.mas_equalTo(0);
    }];
    
    [_bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(_topLineView);
        make.bottom.and.left.mas_equalTo(0);
    }];
    
    [_rightAccessoryImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.centerY.mas_equalTo(self);
    }];
    
    [_leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.centerY.mas_equalTo(self);
    }];
    
    [_rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_rightAccessoryImageView.mas_left).offset(-10);
        make.centerY.mas_equalTo(self);
    }];
    
    [_switch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.centerY.mas_equalTo(self);
    }];
    
    _topLineView.hidden = YES;
    _switch.hidden = YES;
}

#pragma mark - public methods

- (void)showSwitchWithSelectedBlock:(voidBlock)selectedBlock unSelectedBlock:(voidBlock)unSelectedBlock {
    _selectedBlock = selectedBlock;
    _unSelectedBlock = unSelectedBlock;
    
    _switch.hidden = NO;
    _rightAccessoryImageView.hidden = YES;
}

#pragma mark - private methods

- (void)valueChanged {
    if (_switch.on) {
        
        if (_selectedBlock) {
            _selectedBlock();
        }
        
    } else {
        
        if (_unSelectedBlock) {
            _unSelectedBlock();
        }
        
    }
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

- (void)setShowRightAccessoryArrow:(BOOL)showRightAccessoryArrow {
    _showRightAccessoryArrow = showRightAccessoryArrow;
    _rightAccessoryImageView.hidden = !showRightAccessoryArrow;
}

- (void)setShowSwitch:(BOOL)showSwitch {
    _showSwitch = showSwitch;
    _switch.hidden = !showSwitch;
}

@end
