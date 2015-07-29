//
//  YOSMessageCell.m
//  kuailai
//
//  Created by yangyang on 15/7/16.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSBuddyRequestCell.h"

#import "YOSMessageModel.h"

#import "EDColor.h"
#import "Masonry.h"
#import "UIView+YOSAdditions.h"
#import "UIImageView+WebCache.h"

@implementation YOSBuddyRequestCell {
    UIView *_topLineView;
    UIView *_bottomLineView;
    
    UIImageView *_headImageView;
    
    UILabel *_topLabel;
    UILabel *_bottomLabel;
    
    UIButton *_agreeButton;
    UIButton *_refuseButton;
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
    _topLineView = [UIView new];
    _topLineView.backgroundColor = YOSColorLineGray;
    [self.contentView addSubview:_topLineView];
    
    _bottomLineView = [_topLineView yos_copySelf];
    [self.contentView addSubview:_bottomLineView];
    
    _headImageView = [UIImageView new];
    _headImageView.image = [UIImage imageNamed:@"默认头像"];
    _headImageView.layer.cornerRadius = 25;
    _headImageView.layer.masksToBounds = YES;
    _headImageView.clipsToBounds = NO;
    [self.contentView addSubview:_headImageView];
    
    _topLabel = [UILabel new];
    _topLabel.font = [UIFont boldSystemFontOfSize:14.0];
    _topLabel.textColor = YOSColorFontBlack;
    _topLabel.text = @"这是一个帅锅";
    [self.contentView addSubview:_topLabel];
    
    _bottomLabel = [UILabel new];
    _bottomLabel.font = YOSFontSmall;
    _bottomLabel.textColor = YOSColorFontGray;
    _bottomLabel.text = @"你特么别到时候再看，肯定没问题.你特么别到时候再看，肯定没问题.你特么别到时候再看，肯定没问题.";
    [self.contentView addSubview:_bottomLabel];
    
    _agreeButton = [UIButton new];
    [_agreeButton setTitle:@"同意" forState:UIControlStateNormal];
    _agreeButton.titleLabel.font = [UIFont systemFontOfSize:13.0];
    [_agreeButton setTitleColor:YOSColorGreen forState:UIControlStateNormal];
    _agreeButton.layer.borderColor = YOSColorGreen.CGColor;
    _agreeButton.layer.borderWidth = 0.5f;
    [_agreeButton addTarget:self action:@selector(tappedAgreeButton) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_agreeButton];
    
    _refuseButton = [UIButton new];
    [_refuseButton setTitle:@"拒绝" forState:UIControlStateNormal];
    _refuseButton.titleLabel.font = [UIFont systemFontOfSize:13.0];
    [_refuseButton setTitleColor:YOSColorMainRed forState:UIControlStateNormal];
    _refuseButton.layer.borderColor = YOSColorMainRed.CGColor;
    _refuseButton.layer.borderWidth = 0.5f;
    [_refuseButton addTarget:self action:@selector(tappedRefuseButton) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_refuseButton];
    
    [_topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(YOSScreenWidth, 0.5));
        make.top.and.left.mas_equalTo(0);
    }];
    
    [_bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(_topLineView);
        make.bottom.and.left.mas_equalTo(0);
    }];
    
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 50));
        make.left.and.top.mas_equalTo(10);
    }];
    
    [_topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_headImageView).offset(3);
        make.left.mas_equalTo(_headImageView.mas_right).offset(10);
        make.right.mas_equalTo(_agreeButton.mas_left).offset(-10);
    }];
    
    [_bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_headImageView).offset(-3);
        make.size.mas_equalTo(_topLabel);
        make.left.mas_equalTo(_topLabel);
    }];
    
    [_agreeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(45, 23));
        make.right.mas_equalTo(_refuseButton.mas_left).offset(-10);
        make.centerY.mas_equalTo(self);
    }];
    
    [_refuseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(_agreeButton);
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(-10);
    }];
    
    _topLineView.hidden = YES;
}

#pragma mark - event response 

- (void)tappedRefuseButton {
    NSLog(@"%s", __func__);
}

- (void)tappedAgreeButton {
    NSLog(@"%s", __func__);
}

#pragma mark - getter & setter 

- (void)setMessageModel:(YOSMessageModel *)messageModel {
    _messageModel = messageModel;
    
    if (messageModel.avatar) {
        [_headImageView sd_setImageWithURL:[NSURL URLWithString:messageModel.avatar] placeholderImage:[UIImage imageNamed:@"默认头像"]];
    } else {
        _headImageView.image = [UIImage imageNamed:@"默认头像"];
    }
    
    _topLabel.text = messageModel.name;
    
    _bottomLabel.text = messageModel.message;
    _bottomLabel.textColor = YOSColorFontGray;
    
    
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
