//
//  YOSImageView.m
//  kuailai
//
//  Created by yangyang on 15/5/26.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSImageView.h"
#import "Masonry.h"

@implementation YOSImageView {
    UIButton *_deleteBtn;
    UIImageView *_imageView;
    
    voidBlock _block;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (!self) {
        return nil;
    }
    

    _imageView = [UIImageView new];
    _imageView.layer.cornerRadius = 5.0;
    _imageView.layer.masksToBounds = YES;
    _imageView.userInteractionEnabled = YES;
    
    [self addSubview:_imageView];
    
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.bottom.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    
    _deleteBtn = [UIButton new];
    
    [_deleteBtn setBackgroundImage:[UIImage imageNamed:@"关闭"] forState:UIControlStateNormal];
    
    [_deleteBtn addTarget:self action:@selector(tappedDeleteBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_deleteBtn];

    [_deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.top.and.right.mas_equalTo(0);
    }];
    
    return self;
}

- (void)setImage:(UIImage *)image {
    _imageView.image = image;
}

- (void)setDeleteBlock:(voidBlock)block {
    _block = block;
}

- (void)tappedDeleteBtn:(UIButton *)button {
    NSLog(@"%s", __func__);
    
    if (_block) {
        _block();
    }
}

@end
