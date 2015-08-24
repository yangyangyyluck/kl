//
//  YOSMessageCell.m
//  kuailai
//
//  Created by yangyang on 15/7/16.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSMessageCell.h"
#import "YOSUserInfoViewController.h"

#import "YOSMessageModel.h"
#import "YOSUserInfoModel.h"

#import "EDColor.h"
#import "Masonry.h"
#import "UIView+YOSAdditions.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "KYCuteView.h"
#import "YOSEaseMobManager.h"
#import "EaseMob.h"
#import "YOSWidget.h"

@implementation YOSMessageCell {
    
    UIView *_topLineView;
    UIView *_bottomLineView;
    
    UIButton *_headImageButton;
    UILabel *_countLabel;
    
    UILabel *_topLabel;
    UILabel *_bottomLabel;
    
    UILabel *_timeLabel;
    UILabel *_statusLabel;
    
    UIImageView *_accessoryImageView;
    
    KYCuteView *_cuteView;
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

    _bottomLineView = [UIView new];
    _bottomLineView.backgroundColor = YOSColorLineGray;
    [self.contentView addSubview:_bottomLineView];
    
    _headImageButton = [UIButton new];
    _headImageButton.layer.cornerRadius = 25;
    _headImageButton.layer.masksToBounds = YES;
    [_headImageButton addTarget:self action:@selector(tappedAvatarButton) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_headImageButton];

    _countLabel = [UILabel new];
    _countLabel.text = @" 99+ ";

    _countLabel.font = [UIFont systemFontOfSize:11.0f];
    _countLabel.textAlignment = NSTextAlignmentCenter;
    _countLabel.textColor = [UIColor whiteColor];
    _countLabel.backgroundColor = [UIColor redColor];
    _countLabel.layer.cornerRadius = 9;
    _countLabel.layer.masksToBounds = YES;
    _countLabel.layer.borderColor = [UIColor whiteColor].CGColor;
    _countLabel.layer.borderWidth = 1;
    [_headImageButton addSubview:_countLabel];
    
    _accessoryImageView = [UIImageView new];
    _accessoryImageView.image = [UIImage imageNamed:@"小箭头"];
    [self.contentView addSubview:_accessoryImageView];
    
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
    
    _timeLabel = [UILabel new];
    _timeLabel.font = YOSFontSmall;
    _timeLabel.textColor = YOSColorFontGray;
    _timeLabel.text = @"2015-7-12";
    _timeLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_timeLabel];
    
    _statusLabel = [UILabel new];
    _statusLabel.font = YOSFontNormal;
    _statusLabel.textColor = YOSColorGreen;
    _statusLabel.text = @"未添加";
    [self.contentView addSubview:_statusLabel];
    
    [_topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(YOSScreenWidth, 0.5));
        make.top.and.left.mas_equalTo(0);
    }];
    
    [_bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(_topLineView);
        make.bottom.and.left.mas_equalTo(0);
    }];
    
    [_headImageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 50));
        make.left.and.top.mas_equalTo(10);
    }];
    
    CGSize size = [_countLabel sizeThatFits:_countLabel.frame.size];
    
    if (size.width < 16) {
        size.width = 18;
    }
    
    if (size.height < 16) {
        size.height = 18;
    }
    
    [_countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(-3);
        make.right.mas_equalTo(3);
        make.size.mas_equalTo(size);
    }];
    
    [_topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_headImageButton).offset(3);
        make.left.mas_equalTo(_headImageButton.mas_right).offset(10).priorityHigh();
        make.right.mas_equalTo(_timeLabel.mas_left).offset(-10);
    }];
    
    [_bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_headImageButton).offset(-3);
        make.size.mas_equalTo(_topLabel);
        make.left.mas_equalTo(_topLabel);
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.centerY.mas_equalTo(_topLabel);
        make.width.mas_equalTo(60);
    }];
    
    [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_bottomLabel);
        make.right.mas_equalTo(-10);
    }];
    
    [_timeLabel sizeToFit];
    [_topLabel sizeToFit];
    [_bottomLabel sizeToFit];
    [_statusLabel sizeToFit];
    
    [_accessoryImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(-10);
    }];
    
    _topLineView.hidden = YES;
    _accessoryImageView.hidden = YES;
    _statusLabel.hidden = YES;
    
    MASAttachKeys(_topLineView,
                _bottomLineView,
                  
                _headImageButton,
                _countLabel,
                  
                _topLabel,
                _bottomLabel,
                  
                _timeLabel,
                _statusLabel,_accessoryImageView);
    
}

- (void)setupCuteView {
    _cuteView = [[KYCuteView alloc]initWithPoint:CGPointMake(43, 6) superView:self];
    _cuteView.viscosity  = 10;
    _cuteView.bubbleWidth = 20;
    _cuteView.bubbleColor = [UIColor redColor];
    [_cuteView setUp];
    
    //注意：设置 'bubbleLabel.text' 一定要放在 '-setUp' 方法之后
    //Tips:When you set the 'bubbleLabel.text',you must set it after '-setUp'
    _cuteView.bubbleLabel.text = @"12";
    _cuteView.bubbleLabel.font = [UIFont systemFontOfSize:11.0f];
    [_cuteView addGesture];
    _cuteView.frontView.hidden = YES;
    
    _cuteView.yos_superView = self.fatherVC;
    
}

#pragma mark - event response 

- (void)tappedAvatarButton {
    NSLog(@"%s", __func__);
    
    YOSUserInfoViewController *userVC = [YOSUserInfoViewController new];
    userVC.userInfoModel = self.userInfoModel;
    
    [self.yos_viewController.navigationController pushViewController:userVC animated:YES];
}

#pragma mark - getter & setter 

- (void)setMessageModel:(YOSMessageModel *)messageModel {
    _messageModel = messageModel;
    
    // 特殊处理 "想认识我的人"
    if ([messageModel.avatar isEqualToString:@"想认识我的人"]) {
        
        [_headImageButton setImage:[UIImage imageNamed:@"想认识我的人"] forState:UIControlStateNormal];
        _headImageButton.userInteractionEnabled = NO;
        self.showCountLabel = NO;
        self.showTimeLabel = NO;
        self.showStatusLabel = NO;
        self.showAccessoryView = YES;
        _topLabel.text = @"想认识我的人";
        
        if ([messageModel.message isEqualToString:@"[暂无好友申请]"]) {
            _bottomLabel.textColor = YOSColorFontGray;
        } else {
            _bottomLabel.textColor = [UIColor orangeColor];
        }
        
        _bottomLabel.text = messageModel.message;
        
        return;
    }else {
        _headImageButton.userInteractionEnabled = YES;
    }
    
    self.showAccessoryView = NO;
    
    if (messageModel.avatar) {
        [_headImageButton sd_setImageWithURL:[NSURL URLWithString:messageModel.avatar] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"默认头像"]];
    } else {
        [_headImageButton setImage:[UIImage imageNamed:@"默认头像"] forState:UIControlStateNormal];
    }
    
    _topLabel.text = messageModel.name;
    
    _bottomLabel.text = messageModel.message;
    _bottomLabel.textColor = YOSColorFontGray;
    
    _timeLabel.text = messageModel.date;
    self.showTimeLabel = YES;
    
    if (messageModel.status) {
        _statusLabel.text = messageModel.status;
        self.showStatusLabel = YES;
    } else {
        self.showStatusLabel = NO;
    }
    
    NSUInteger count = [messageModel.count integerValue];
    _countLabel.hidden = YES;
    
    if (!_cuteView) {
        [self setupCuteView];
    }
    
    // 预读一次回话
    [[YOSEaseMobManager sharedManager] conversationForChatter:self.messageModel.hx_user];
    
    _cuteView.hx_user = self.messageModel.hx_user;
    
    if (count) {
        NSString *str = nil;
        if (count >= 99) {
            str = @"99+";
        } else {
            str = messageModel.count;
        }
        
        _cuteView.bubbleLabel.text = str;
        [_cuteView resetBubble];
        
    } else {
        _cuteView.frontView.hidden = YES;
    }
    
    /*
    if (count) {
        NSString *str = nil;
        if (count >= 99) {
            str = @" 99+ ";
        } else {
            str = messageModel.count;
        }
        
        _countLabel.hidden = NO;
        _countLabel.text = str;
    } else {
        _countLabel.hidden = YES;
    }
    
    // layout
    CGSize size = [_countLabel sizeThatFits:_countLabel.frame.size];
    
    if (size.width < 16) {
        size.width = 18;
    }
    
    if (size.height < 16) {
        size.height = 18;
    }
    
    [_countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.removeExisting = YES;
        
        make.top.mas_equalTo(-3);
        make.right.mas_equalTo(3);
        make.size.mas_equalTo(size);
    }];
     */
    
}

- (void)setShowTopLine:(BOOL)showTopLine {
    _showTopLine = showTopLine;
    _topLineView.hidden = !showTopLine;
}

- (void)setShowBottomLine:(BOOL)showBottomLine {
    _showBottomLine = showBottomLine;
//    _bottomLineView.hidden = !showBottomLine;
}

- (void)setShowCountLabel:(BOOL)showCountLabel {
    _showCountLabel = showCountLabel;
    _countLabel.hidden = !showCountLabel;
}

- (void)setShowTimeLabel:(BOOL)showTimeLabel {
    _showTimeLabel = showTimeLabel;
    _timeLabel.hidden = !showTimeLabel;
}

- (void)setShowStatusLabel:(BOOL)showStatusLabel {
    _showStatusLabel = showStatusLabel;
    _statusLabel.hidden = !showStatusLabel;
}

- (void)setShowAccessoryView:(BOOL)showAccessoryView {
    _showAccessoryView = showAccessoryView;
    _accessoryImageView.hidden = !showAccessoryView;
}

@end
