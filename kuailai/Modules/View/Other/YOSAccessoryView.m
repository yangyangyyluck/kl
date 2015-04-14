//
//  YOSAccessoryView.m
//  kuailai
//
//  Created by yangyang on 15/4/10.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSAccessoryView.h"
#import "Masonry.h"

@implementation YOSAccessoryView {
    NSMutableDictionary *_targets;
    NSMutableDictionary *_buttons;
    void (^_defaultPlaceBlock)(void);
}

- (instancetype)initWithDefaultPlaceBlock:(void(^)(void))defaultPlaceBlock {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _defaultPlaceBlock = [defaultPlaceBlock copy];
    _targets = [NSMutableDictionary dictionary];
    _buttons = [NSMutableDictionary dictionary];
    
    self.frame = CGRectMake(0, 0, YOSScreenWidth, 44);
    self.backgroundColor = [UIColor clearColor];
    
    return self;
}

- (UIButton *)buttonWithTitle:(NSString *)title target:(__weak id)target method:(SEL)sel position:(YOSAccessoryViewPosition)position {
    
    UIButton *btn = _buttons[@(position)];
    
    if (!btn) {
        btn = [UIButton new];
        _buttons[@(position)] = btn;
    }
    
    _targets[@(position)] = target;
    
    btn.backgroundColor = YOSColorGreen;
    btn.layer.cornerRadius = 3.0f;
    btn.layer.masksToBounds = YES;
    
    [self setupTitle:title target:target method:sel position:position];
    
    [self addSubview:btn];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.mas_equalTo(0);
        
        if (position == YOSAccessoryViewPositionLeft) {
            make.left.mas_equalTo(0);
        }
        
        if (position == YOSAccessoryViewPositionRight) {
            make.right.mas_equalTo(0);
        }
        
        make.width.mas_equalTo(100);
    }];
    
    return btn;
}

- (void)setupTitle:(NSString *)title target:(__weak id)target method:(SEL)sel position:(YOSAccessoryViewPosition)position {
    [_buttons[@(position)] setTitle:title forState:UIControlStateNormal];
    [_buttons[@(position)] removeTarget:_targets[@(position)] action:NULL forControlEvents:UIControlEventTouchUpInside];
    [_buttons[@(position)] addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    _targets[@(position)] = target;
}

- (void)setupDefaultPlaceBlock:(void (^)(void))defaultPlaceBlock {
    _defaultPlaceBlock = [defaultPlaceBlock copy];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (_defaultPlaceBlock) {
        _defaultPlaceBlock();
    }
}

@end
