//
//  YOSHomeSwitchDetailView.m
//  kuailai
//
//  Created by yangyang on 15/8/19.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSHomeSwitchDetailView.h"

#import "Masonry.h"
#import "EDColor.h"
#import "UIImage+YOSAdditions.h"

@implementation YOSHomeSwitchDetailView {
    NSArray *_titles;
    NSUInteger _btnCountsPerRow;
    __weak UIView *_superView;
    
    UIView *_whiteView;
    NSMutableArray *_btns;
    UIButton *_hudView;
    
    MASConstraint *_topConstraint;
    CGFloat _whiteHeight;
}

- (instancetype)initWithTitles:(NSArray *)titles btnCountsPerRow:(NSUInteger)btnCountsPerRow superView:(UIView *)superView {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _titles = titles;
    _btnCountsPerRow = btnCountsPerRow;
    _btns = [NSMutableArray array];
    _superView = superView;

    [self setupSubviews];
    
    return self;
}

- (void)dealloc {
    NSLog(@"------ YOSHomeSwitchDetailView dealloc ------");
}

- (void)setupSubviews {
    _hudView = [UIButton new];
    _hudView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    _hudView.clipsToBounds = YES;
    [_hudView addTarget:self action:@selector(tappedHudView) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_hudView];
    
    _whiteView = [UIView new];
    _whiteView.backgroundColor = [UIColor whiteColor];
    [_hudView addSubview:_whiteView];
    
    CGFloat width = 0;
    if (_btnCountsPerRow == 3) {
        width = 90;
        _whiteHeight = 130.0;
    } else if (_btnCountsPerRow == 4) {
        width = 70;
        _whiteHeight = 130.0;
    } else if (_btnCountsPerRow == 5) {
        width = 50;
        _whiteHeight = 100.0;
    }
    
    [_hudView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero).priorityLow();
    }];
    
    [_whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(YOSScreenWidth, _whiteHeight));
        make.left.mas_equalTo(0);
        _topConstraint = make.top.mas_equalTo(-_whiteHeight + 1);
    }];
    
    CGFloat height = 25.0f;
    CGFloat marginX = (YOSScreenWidth - width * _btnCountsPerRow) / (_btnCountsPerRow + 1);
    NSUInteger row = ceil(_titles.count / (_btnCountsPerRow * 1.0));
    
#warning 临时这么做 本来显示5条 去掉了 "全部"
    if (_btnCountsPerRow == 5) {
        width = 70;
        marginX = (YOSScreenWidth - width * 4) / (4 + 1);
    }
    
    CGFloat marginTop = 0;
    CGFloat marginY = 0;
    if (row == 1) {
        marginTop = 37.5;
        marginY = 0;
    } else {
        marginTop = 30;
        marginY = 20;
    }
    
    [_titles enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
        UIButton *btn = [self buttonWithTitle:obj];
        btn.tag = idx + 1;
        
        NSInteger index = self.selectedIndex - 1;
        
        [_btns addObject:btn];
        [_whiteView addSubview:btn];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(width, height));
            make.left.mas_equalTo((idx % _btnCountsPerRow) * (width + marginX) + marginX);
            make.top.mas_equalTo((marginTop + (idx / _btnCountsPerRow) * (height + marginY)));
        }];
    }];

    self.backgroundColor = [UIColor clearColor];
    _hudView.alpha = 0.0;
}

- (UIButton *)buttonWithTitle:(NSString *)title {
    UIButton *btn = [UIButton new];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.layer.borderWidth = 0.5f;
    btn.layer.borderColor = YOSColorLineGray.CGColor;
    [btn setBackgroundImage:[UIImage yos_imageWithColor:YOSColorMainRed size:CGSizeMake(1, 1)] forState:UIControlStateSelected];
    [btn setTitleColor:YOSColorFontGray forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    btn.titleLabel.font = YOSFontSmall;
    [btn addTarget:self action:@selector(tappedButton:) forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

#pragma mark - event response 

- (void)tappedButton:(UIButton *)button {
    NSLog(@"%s", __func__);
    
    NSUInteger index = button.tag;
    
    [_btns enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL *stop) {
        if (obj == button) {
            obj.selected = !obj.selected;
        } else {
            obj.selected = NO;
        }
        
    }];
    
    if (button.selected) {
        if ([self.delegate respondsToSelector:@selector(homeSwitchDetailView:index:selected:)]) {
            [self.delegate homeSwitchDetailView:self index:index selected:YES];
        }
    } else {
        if ([self.delegate respondsToSelector:@selector(homeSwitchDetailView:index:selected:)]) {
            [self.delegate homeSwitchDetailView:self index:index selected:NO];
        }
    }
    
    [self hideDetailView];
    
}

- (void)tappedHudView {
    NSLog(@"%s", __func__);
    
    if (self.hudBlock) {
        self.hudBlock();
    }
    
    [self hideDetailView];
}

#pragma mark - public methods 

- (void)showWhiteWithAnimation {
    
    [_topConstraint setOffset:0];
    YOSWSelf(weakSelf);
    [UIView animateWithDuration:0.3f animations:^{
        [weakSelf layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
    
}
- (void)hideWhiteWithAnimation {
    [_topConstraint setOffset:-_whiteHeight];
    YOSWSelf(weakSelf);
    [UIView animateWithDuration:0.3f animations:^{
        [weakSelf layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
    
}
- (void)showDetailView {
    [_superView addSubview:self];
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero).priorityLow();
        make.top.mas_equalTo(64);
    }];
    
    [self layoutIfNeeded];
    
    YOSWObject(_hudView, weakObject);
    YOSWSelf(weakSelf);
    [UIView animateWithDuration:0.3f animations:^{
        weakObject.alpha = 1.0;
        [weakSelf showWhiteWithAnimation];
    } completion:^(BOOL finished) {
        
    }];
}
- (void)hideDetailView {
    YOSWObject(_hudView, weakObject);
    YOSWSelf(weakSelf);
    
    [UIView animateWithDuration:0.3f animations:^{
        weakObject.alpha = 0.0;
        [weakSelf hideWhiteWithAnimation];
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
}

#pragma mark - setter & getter 

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    _selectedIndex = selectedIndex;
    
    [_btns enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL *stop) {
        if (idx == selectedIndex - 1) {
            obj.selected = YES;
        }
    }];
}

@end
