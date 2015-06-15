//
//  YOSNeedView.m
//  kuailai
//
//  Created by yangyang on 15/6/15.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSNeedView.h"
#import "UIView+YOSAdditions.h"
#import "Masonry.h"
#import "EDColor.h"

@interface YOSNeedView ()

@property (nonatomic, assign) NSUInteger totalRows;

@property (nonatomic, assign) NSUInteger heightOfNeedView;

@end

@implementation YOSNeedView {
    NSArray *_titles;
}

- (instancetype)initWithTitles:(NSArray *)titles {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _titles = titles;
    
    [self setupSubviews];
    
    return self;
}

- (void)setupSubviews {
    
    NSMutableArray *btns = [NSMutableArray array];
    
    [_titles enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
        UIButton *btn = [self subButtonWithTitle:obj];
        
        [btns addObject:btn];
        [self addSubview:btn];
    }];
    
    CGFloat spaceX = 10.0f;
    __block NSUInteger currentRow = 0;
    __block CGFloat currentWidth = 8.0;
    __block UIView *lastView = nil;
    [btns enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL *stop) {
        CGSize size = [obj sizeThatFits:obj.frame.size];
        size.width += 20;
        
        currentWidth = currentWidth + size.width + spaceX;
        
        if (currentWidth > YOSScreenWidth) {
            currentRow++;
            currentWidth = 8.0 + size.width + spaceX;
            
        }
        
        NSUInteger rowOfLastView = 0;
        if (lastView) {
            rowOfLastView = [lastView.yos_attachment unsignedIntegerValue];
        }
        
        [obj mas_makeConstraints:^(MASConstraintMaker *make) {
            
            if (rowOfLastView == currentRow && lastView) {
                make.left.mas_equalTo(lastView.mas_right).offset(10);
            } else {
                make.left.mas_equalTo(8);
            }
            
            make.top.mas_equalTo(currentRow * 35);
            make.size.mas_equalTo(size);
        }];
        
        lastView = obj;
        [lastView setYos_attachment:@(currentRow)];
    }];
    
    if (btns.count) {
        self.totalRows = currentRow + 1;
        self.heightOfNeedView = currentRow * 20 + (currentRow + 1) * 15;
    } else {
        self.totalRows = currentRow;
        self.heightOfNeedView = 0;
    }
}

- (UIButton *)subButtonWithTitle:(NSString *)title {
    UIButton *btn = [UIButton new];
    [btn setImage:[UIImage imageNamed:@"绿色对勾"] forState:UIControlStateSelected];
    [btn setImage:[UIImage imageNamed:@"绿色对勾"] forState:UIControlStateNormal];
    [btn setTitleColor:YOSColorFontBlack forState:UIControlStateNormal];
    [btn setTitleColor:YOSColorFontBlack forState:UIControlStateSelected];
    btn.titleLabel.font = YOSFontNormal;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
    btn.enabled = NO;
    btn.selected = YES;
    
    return btn;
}

@end
