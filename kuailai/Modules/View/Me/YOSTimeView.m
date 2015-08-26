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
#import "YOSWidget.h"
#import "YOSLocalNotificationManager.h"

@interface YOSTimeView ()

@property (nonatomic, strong, readwrite) UISwitch *swh;

@end

@implementation YOSTimeView {
    UILabel *_leftLabel;
    UILabel *_rightLabel;
    UILabel *_bottomLabel;
    
    UIView *_topLineView;
    UIView *_bottomLineView;
    
    NSTimer *_timer;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    
    self.backgroundColor = [UIColor whiteColor];
    
    _timer = [NSTimer timerWithTimeInterval:40 target:self selector:@selector(updateAlertDate) userInfo:nil repeats:YES];
    
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    
    [self setupSubviews];
    
    return self;
}

- (void)dealloc {
    [_timer invalidate];
    _timer = nil;
}

- (void)setupSubviews {
    _leftLabel = [UILabel new];
    _leftLabel.textColor = YOSColorMainRed;
    _leftLabel.font = [UIFont boldSystemFontOfSize:22.0f];
    [self addSubview:_leftLabel];
    _leftLabel.text = @"00:00AM";
    
    _rightLabel = [UILabel new];
    _rightLabel.textColor = YOSColorMainRed;
    _rightLabel.font = YOSFontNormal;
    [self addSubview:_rightLabel];
    _rightLabel.text = @"0000-00-00";
    
    _bottomLabel = [UILabel new];
    _bottomLabel.textColor = YOSColorFontGray;
    _bottomLabel.font = YOSFontSmall;
    [self addSubview:_bottomLabel];
    _bottomLabel.text = @"0天0小时0分钟后响铃";
    
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
    
    if (self.idBlock) {
        self.idBlock(swh);
    }
    
}

- (void)setAlertDate:(NSDate *)alertDate {
    NSLog(@"%s", __func__);
    
    if (!alertDate) {
        return;
    }
    
    _alertDate = alertDate;
    
    _leftLabel.text = [YOSWidget dateStringWithDate:alertDate Format:@"h:mm a"];
    _rightLabel.text = [YOSWidget dateStringWithDate:alertDate Format:@"yyyy-MM-dd"];
    
    NSTimeInterval interval = [alertDate timeIntervalSince1970] - [[NSDate date] timeIntervalSince1970];
    
    NSUInteger day =  interval / (24 * 3600);
    NSUInteger hour = (interval - day * (24 * 3600)) / 3600;
    NSUInteger minute = ceil((interval - day * (24 * 3600) - 3600 * hour) / 60);
    
    _bottomLabel.text = [NSString stringWithFormat:@"%zi天%zi小时%zi分钟后响铃", day, hour, minute];
}

- (void)updateAlertDate {
    NSLog(@"%s", __func__);
    
    NSTimeInterval interval0 = [self.alertDate timeIntervalSince1970];
    NSTimeInterval interval1 = [[NSDate date] timeIntervalSince1970];
    
    NSInteger interval = interval0 - interval1;
    
    if (interval <= 0) {
        [_timer invalidate];
        _timer = nil;
    } else {
        self.alertDate = self.alertDate;
    }
    
}

- (void)expireTime {
    self.swh.enabled = NO;
    
    _rightLabel.hidden = YES;
    _bottomLabel.hidden = YES;
    _leftLabel.text = @"活动已过期";
    
    [_leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.removeExisting = YES;
        
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(10);
    }];
}

@end
