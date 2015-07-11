//
//  YOSTapView.m
//  kuailai
//
//  Created by yangyang on 15/7/9.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSTapView.h"

#import "UIView+YOSAdditions.h"
#import "Masonry.h"
#import "GVUserDefaults+YOSProperties.h"

@interface YOSTapView ()

@property (nonatomic, strong) NSMutableArray *btns;

@property (nonatomic, assign) NSUInteger totalRows;

@end

@implementation YOSTapView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (!self) {
        return nil;
    }
    
    _btns = [NSMutableArray array];
    
    self.backgroundColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTagInfo) name:YOSNotificationUpdateTagInfo object:nil];
    
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setTapArray:(NSArray *)tapArray {
    _tapArray = tapArray;
    
    [_btns enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromSuperview];
    }];
    
    [_btns removeAllObjects];
    
    [tapArray enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
        UIButton *btn = [self subButtonWithTitle:obj];
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
    [_btns enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL *stop) {
        CGSize size = [obj sizeThatFits:obj.frame.size];
        size.width += 40;
        size.height = 30;
        
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

- (UIButton *)subButtonWithTitle:(NSString *)title {
    UIButton *btn = [UIButton new];
    
    [btn setTitle:title forState:UIControlStateNormal];
    
    btn.titleLabel.font = YOSFontNormal;
    
    btn.adjustsImageWhenHighlighted = NO;
    
    btn.backgroundColor = YOSColorGreen;
    
    return btn;
}

#pragma mark - deal notification

- (void)updateTagInfo {
    NSLog(@"%s", __func__);
    
    NSDictionary *data = [GVUserDefaults standardUserDefaults].currentTagDictionary;
    
    NSArray *array = nil;
    if (data) {
        array = data[@"data"];
    }
    
    NSMutableArray *temp = [NSMutableArray array];
    
    [array enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
        [temp addObject:obj[@"name"]];
    }];
    
    self.tapArray = temp;
}

@end
