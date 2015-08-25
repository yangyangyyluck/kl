//
//  YOSHomeSwitchView.m
//  kuailai
//
//  Created by yangyang on 15/8/19.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSHomeSwitchView.h"
#import "YOSHomeSwitchDetailView.h"

#import "Masonry.h"
#import "UIView+YOSAdditions.h"

@interface YOSHomeSwitchView () <YOSHomeSwitchDetailViewDelegate>

@property (nonatomic, strong) UIButton *btn0;
@property (nonatomic, strong) UIButton *btn1;
@property (nonatomic, strong) UIButton *btn2;

@end

@implementation YOSHomeSwitchView {
    YOSHomeSwitchDetailView *_detailView;
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
    
    _btn0 = [self buttonWithImage:@"时间" selectedImage:@"时间-点击" tag:0];
    [self addSubview:_btn0];
    
    _btn1 = [self buttonWithImage:@"兴趣-1" selectedImage:@"兴趣-点击-1" tag:1];
    [self addSubview:_btn1];
    
    _btn2 = [self buttonWithImage:@"位置" selectedImage:@"位置-点击" tag:2];
    [self addSubview:_btn2];
    
    [_btn0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(25, 25));
        make.left.mas_equalTo(0);
        make.centerY.mas_equalTo(self);
    }];
    
    [_btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(_btn0);
        make.center.mas_equalTo(self);
    }];
    
    [_btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(_btn0);
        make.right.mas_equalTo(0);
        make.centerY.mas_equalTo(self);
    }];
}

- (UIButton *)buttonWithImage:(NSString *)image selectedImage:(NSString *)selectedImage tag:(NSUInteger)tag {
    UIButton *btn = [UIButton new];
    btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:selectedImage] forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(tappedButton:) forControlEvents:UIControlEventTouchUpInside];
    btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    btn.tag = tag;
    
    return btn;
}

- (void)tappedButton:(UIButton *)btn {
    NSLog(@"%s", __func__);
    
    NSUInteger index = btn.tag;
    
    if (_btn0 != btn) {
        _btn0.selected = NO;
    }
    
    if (_btn1 != btn) {
        _btn1.selected = NO;
    }
    
    if (_btn2 != btn) {
        _btn2.selected = NO;
    }
    
    NSArray *arr = nil;
    NSUInteger count = 0;
    NSUInteger selectedIndex = 0;
    if (index == 0) {
        count = 5;
        arr = @[@"今天", @"明天", @"近一周", @"周末"];
        _btn1.selected = NO;
        _btn2.selected = NO;
        selectedIndex = self.selectedTime;
    }
    
    if (index == 1) {
        count = 3;
        arr = @[@"商务市场", @"黑马创业", @"产品分享", @"技术交流", @"沙龙小聚", @"户外休闲"];
        _btn0.selected = NO;
        _btn2.selected = NO;
        selectedIndex = self.selectedType;
    }
    
    if (index == 2) {
        count = 4;
        arr = @[@"北京", @"上海", @"广州", @"深圳", @"杭州", @"南京"];
        _btn0.selected = NO;
        _btn1.selected = NO;
        selectedIndex = self.selectedPosition;
    }
    
    [_detailView hideDetailView];
    _detailView = nil;

    self.selectedIndex = btn.tag;
    YOSWSelf(weakSelf);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _detailView = [[YOSHomeSwitchDetailView alloc] initWithTitles:arr btnCountsPerRow:count superView:self.yos_viewController.view];
        _detailView.selectedIndex = selectedIndex;
        _detailView.delegate = self;
        _detailView.hudBlock = ^{
            weakSelf.btn0.selected = NO;
            weakSelf.btn1.selected = NO;
            weakSelf.btn2.selected = NO;
        };
        
        [_detailView showDetailView];
    });
    
}

- (void)homeSwitchDetailView:(YOSHomeSwitchDetailView *)detailView index:(NSUInteger)index selected:(BOOL)selected {
    
    NSUInteger subIndex = (selected ? index : 0);
    
    if ([self.delegate respondsToSelector:@selector(homeSwitchView:selectedIndex:selectedSubIndex:)]) {
        [self.delegate homeSwitchView:self selectedIndex:self.selectedIndex selectedSubIndex:subIndex];
    }
    
}

@end
