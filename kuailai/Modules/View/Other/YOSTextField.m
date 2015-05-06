//
//  YOSTextField.m
//  kuailai
//
//  Created by yangyang on 15/5/6.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSTextField.h"
#import "Masonry.h"

@implementation YOSTextField {
    UIView *_lineView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    
    self.font = [UIFont systemFontOfSize:14.0f];
    
    _lineView = [UIView new];
    _lineView.backgroundColor = [UIColor grayColor];
    
    [self addSubview:_lineView];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.and.trailing.mas_equalTo(0);
        make.height.mas_equalTo(0.5f);
        make.bottom.mas_equalTo(0);
    }];
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
