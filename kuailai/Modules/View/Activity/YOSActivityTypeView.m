//
//  YOSActivityTypeView.m
//  kuailai
//
//  Created by yangyang on 15/5/30.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSActivityTypeView.h"
#import "EDColor.h"
#import "Masonry.h"

@interface YOSActivityTypeView ()

@property (nonatomic, strong) NSMutableArray *dataSource0;

@end

@implementation YOSActivityTypeView {
    UIView *_topView;
    UILabel *_titleLabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (!self) {
        return nil;
    }
    
    self.backgroundColor = [UIColor whiteColor];
    
    [self setupSubviews];
    
    return self;
}

- (void)setupSubviews {
    _topView = [UIView new];
    [self addSubview:_topView];
    
    _titleLabel = [UILabel new];
    _titleLabel.font = YOSFontNormal;
    _titleLabel.textColor = YOSColorFontBlack;
    _titleLabel.text = @"活动类别";
    
    [_topView addSubview:_titleLabel];
    

    
    
    
    // setup constraints
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.right.left.mas_equalTo(0);
        make.height.mas_equalTo(44);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.centerY.mas_equalTo(_topView);
    }];
    
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(88);
    }];
}

#pragma mark - getter & setter 

- (NSMutableArray *)dataSource0 {
    if (!_dataSource0) {
        _dataSource0 = [NSMutableArray array];
        
        [_dataSource0 addObjectsFromArray:@[@"商务"]];
    }
    
    return _dataSource0;
}

@end
