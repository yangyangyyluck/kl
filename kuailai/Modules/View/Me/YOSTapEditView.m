//
//  YOSTapEditView.m
//  kuailai
//
//  Created by yangyang on 15/7/9.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSTapEditView.h"
#import "YOSTapDeleteView.h"

#import "UIView+YOSAdditions.h"
#import "Masonry.h"

@interface YOSTapEditView ()

@property (nonatomic, strong) NSArray *tapArray;

@property (nonatomic, strong) NSMutableArray *btns;

@property (nonatomic, assign) NSUInteger totalRows;

@end

@implementation YOSTapEditView

- (instancetype)initWithTapArray:(NSArray *)array {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _btns = [NSMutableArray array];
    self.tapArray = array;
    
    self.backgroundColor = [UIColor whiteColor];
    
    [self setupSubviews];
    
    return self;
}

- (void)setupSubviews {
    
}

- (void)setTapArray:(NSArray *)tapArray {
    _tapArray = tapArray;
    
    [_btns enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromSuperview];
    }];
    
    [_btns removeAllObjects];
    
    [tapArray enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
        YOSTapDeleteView *btn = [[YOSTapDeleteView alloc] initWithString:obj];
        btn.tag = idx;
        
        [_btns addObject:btn];
        [self addSubview:btn];
    }];
    
    CGFloat spaceX = 10.0f;
    CGFloat marginX = 15.0f;
    CGFloat lineHeight = 30.0f;
    CGFloat lineSpace = 20.0f;
    __block NSUInteger currentRow = 0;
    __block CGFloat currentWidth = marginX;    // left margin
    __block UIView *lastView = nil;
    [_btns enumerateObjectsUsingBlock:^(YOSTapDeleteView *obj, NSUInteger idx, BOOL *stop) {
        CGSize size = obj.yos_contentSize;
        
        currentWidth = currentWidth + size.width + spaceX;
        
        if (currentWidth > YOSScreenWidth) {
            currentRow++;
            currentWidth = marginX + size.width + spaceX;
            
        }
        
        NSUInteger rowOfLastView = 0;
        if (lastView) {
            rowOfLastView = [lastView.yos_attachment unsignedIntegerValue];
        }
        
        [obj mas_makeConstraints:^(MASConstraintMaker *make) {
            
            if (rowOfLastView == currentRow && lastView) {
                make.left.mas_equalTo(lastView.mas_right).offset(10);
            } else {
                make.left.mas_equalTo(marginX);
            }
            
            make.top.mas_equalTo(currentRow * (lineHeight + lineSpace) + 15);
            make.size.mas_equalTo(size);
        }];
        
        lastView = obj;
        [lastView setYos_attachment:@(currentRow)];
    }];
    
    if (_btns.count) {
        self.totalRows = currentRow + 1;
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(currentRow * lineSpace + (self.totalRows) * lineHeight + 30);
        }];
    } else {
        self.totalRows = currentRow;
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
    }
    
}

@end
