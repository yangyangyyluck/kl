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
    UIButton *_btn;
    id _target;
    void (^_defaultPlaceBlock)(void);
}

- (instancetype)initWithTitle:(NSString *)title target:(id)target method:(SEL)sel position:(YOSAccessoryViewPosition)position {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.backgroundColor = [UIColor clearColor];
    
    UIButton *btn = [UIButton new];
    btn.backgroundColor = YOSColorGreen;
    [btn setTitle:title forState:UIControlStateNormal];
    btn.layer.cornerRadius = 3.0f;
    btn.layer.masksToBounds = YES;
    [btn addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    _btn = btn;
    _target = target;
    
    [self addSubview:btn];
    
    self.frame = CGRectMake(0, 0, YOSScreenWidth, 44);
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.mas_equalTo(0);
        if (position == YOSAccessoryViewPositionLeft) {
            make.left.mas_equalTo(0);
        } else {
            make.right.mas_equalTo(0);
        }
        make.width.mas_equalTo(100);
    }];
    
    return self;
}

- (void)setupTitle:(NSString *)title target:(id)target method:(SEL)sel {
    [_btn setTitle:title forState:UIControlStateNormal];
    [_btn removeTarget:_target action:NULL forControlEvents:UIControlEventTouchUpInside];
    [_btn addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    _target = target;
}

- (void)setupDefaultPlaceBlock:(void (^)(void))defaultPlaceBlock {
    _defaultPlaceBlock = defaultPlaceBlock;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (_defaultPlaceBlock) {
        _defaultPlaceBlock();
    }
}

@end
