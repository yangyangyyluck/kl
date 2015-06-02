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
#import "YOSActivityFatherTypeModel.h"
#import "YOSActivitySonTypeModel.h"
#import "UIImage+YOSAdditions.h"
#import "UIView+YOSAdditions.h"

@interface YOSActivityTypeView ()

@property (nonatomic, strong) NSArray *activityFatherTypeModels;

@property (nonatomic, assign) NSUInteger totalRows;

@property (nonatomic, assign) NSUInteger currentFatherBtnIndex;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *childType;

@end

@implementation YOSActivityTypeView {
    UIView *_topView;
    UILabel *_titleLabel;
    
    UIView *_middleView;
    NSMutableArray *_middleBtns;
    
    UIView *_bottomView;
    NSMutableArray *_bottomBtns;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (!self) {
        return nil;
    }
    
    return self;
}

- (instancetype)initWithActivityFatherTypeModels:(NSArray *)activityFatherTypeModels {
    
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _activityFatherTypeModels = activityFatherTypeModels;
    
    self.backgroundColor = [UIColor whiteColor];
    
    [self setupSubviews];
    
    return self;
    
}

- (void)setupSubviews {
    _topView = [UIView new];
    [self addSubview:_topView];
    
    _titleLabel = [UILabel new];
    _titleLabel.font = YOSFontNormal;
    _titleLabel.textColor = YOSColorFontGray;
    _titleLabel.text = @"活动类别";
    
    [_topView addSubview:_titleLabel];
    
    _middleView = [UIView new];
    [self addSubview:_middleView];
    
    _middleBtns = [NSMutableArray array];
    
    [self.activityFatherTypeModels enumerateObjectsUsingBlock:^(YOSActivityFatherTypeModel *obj, NSUInteger idx, BOOL *stop) {
        
        UIButton *btn = [self buttonWithTitle:obj.name];
        btn.tag = idx;
        [_middleBtns addObject:btn];
        [_middleView addSubview:btn];
        
    }];
    
    _bottomView = [UIView new];
    [self addSubview:_bottomView];
    
    _bottomBtns = [NSMutableArray array];
    
    // setup constraints
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.right.left.mas_equalTo(0);
        make.height.mas_equalTo(44);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.centerY.mas_equalTo(_topView);
    }];
    
    NSUInteger maxCols = 3;
    CGFloat marginX = 8;
    CGFloat spaceX = (YOSScreenWidth - maxCols * 93 - 2 * marginX) / (maxCols - 1);
    CGFloat marginY = 15;
    
    [_middleBtns enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL *stop) {
        NSUInteger row = idx / maxCols;
        NSUInteger col = idx % maxCols;
        [obj mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(93, 25));
            make.left.mas_equalTo(marginX + (spaceX + 93) * col);
            make.top.mas_equalTo((marginY + 25) * row);
        }];
    }];
    
    NSUInteger maxRows = ceil(_middleBtns.count / maxCols);
    [_middleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_topView.mas_bottom);
        make.left.and.right.mas_equalTo(0);
        make.height.mas_equalTo(maxRows * 25 + (maxRows - 1) * 15);
    }];
    
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_middleView.mas_bottom).offset(20);
        make.height.mas_equalTo(0);
        make.left.and.right.mas_equalTo(0);
    }];
}

- (void)setupSonTypesWithIndex:(NSUInteger)index {
    NSArray *array = ((YOSActivityFatherTypeModel *)self.activityFatherTypeModels[index]).ctype;
    
    [_bottomBtns enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromSuperview];
    }];
    
    [_bottomBtns removeAllObjects];
    
    [array enumerateObjectsUsingBlock:^(YOSActivitySonTypeModel *obj, NSUInteger idx, BOOL *stop) {
        UIButton *btn = [self subButtonWithTitle:obj.name];
        btn.tag = idx;
        
        [_bottomBtns addObject:btn];
        [_bottomView addSubview:btn];
    }];
    
    CGFloat spaceX = 10.0f;
    __block NSUInteger currentRow = 0;
    __block CGFloat currentWidth = 8.0;
    __block UIView *lastView = nil;
    [_bottomBtns enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL *stop) {
        CGSize size = [obj sizeThatFits:obj.frame.size];
        size.width += 20;
        
        currentWidth = currentWidth + size.width + spaceX;
//        YOSActivityFatherTypeModel *f = self.activityFatherTypeModels[0];
//        NSLog(@"name %@ currentWidth %f", [f.ctype[idx] name], currentWidth);
        
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
    
    if (_bottomBtns.count) {
        self.totalRows = currentRow + 1;
        [_bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(currentRow * 20 + (currentRow + 1) * 15);
        }];
    } else {
        self.totalRows = currentRow;
        [_bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
    }
    
    // update constraints
    if (self.vBlock) {
        self.vBlock();
    }
}

#pragma mark - public methods

- (CGFloat)currentHeight {
    NSUInteger maxCols = 3;
    NSUInteger maxRows = ceil(_middleBtns.count / maxCols);
    
    return 44 + maxRows * 25 + (maxRows - 1) * 15 + 20 + (self.totalRows * (15 + 20));
}

#pragma mark - private methods

- (UIButton *)buttonWithTitle:(NSString *)title {
    UIButton *btn = [UIButton new];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:YOSColorFontGray forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(tappedButton:) forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font = YOSFontSmall;
    btn.layer.borderWidth = 0.5;
    btn.layer.borderColor = YOSColorLineGray.CGColor;
    btn.layer.masksToBounds = YES;

    UIImage *selectedImage = [UIImage yos_imageWithColor:YOSRGB(252, 106, 67) size:CGSizeMake(1, 1)];
    
    [btn setBackgroundImage:selectedImage forState:UIControlStateSelected];
    
    return btn;
}

- (UIButton *)subButtonWithTitle:(NSString *)title {
    UIButton *btn = [UIButton new];
    [btn setImage:[UIImage imageNamed:@"对号"] forState:UIControlStateSelected];
    [btn setImage:[UIImage imageNamed:@"勾选框"] forState:UIControlStateNormal];
    [btn setTitleColor:YOSColorFontGray forState:UIControlStateNormal];
    [btn setTitleColor:YOSColorFontBlack forState:UIControlStateSelected];
    btn.titleLabel.font = YOSFontSmall;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
    
    btn.backgroundColor = [UIColor greenColor];
    
    [btn addTarget:self action:@selector(tappedSubButton:) forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

#pragma mark - event response

- (void)tappedButton:(UIButton *)button {
    
    [_middleBtns enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL *stop) {
        if (obj != button) {
            obj.selected = NO;
        }
    }];
    
    button.selected = !button.selected;
    
    if (button.selected) {
        self.currentFatherBtnIndex = button.tag;
        
        [self setupSonTypesWithIndex:button.tag];
        
        YOSActivityFatherTypeModel *model = self.activityFatherTypeModels[button.tag];
        self.type = model.ID;
        
    } else {
        [_bottomBtns enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
            [obj removeFromSuperview];
        }];
        
        [_bottomBtns removeAllObjects];
        
        self.totalRows = 0;
        self.type = @"";
        self.childType = @"";
        
        if (self.vBlock) {
            self.vBlock();
        }
    }

}

- (void)tappedSubButton:(UIButton *)button {
    
    button.selected = !button.selected;
    
    NSMutableArray *arrayM = [NSMutableArray array];
    [_bottomBtns enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL *stop) {
        if (obj.selected) {
            [arrayM addObject:@(obj.tag)];
        }
    }];
    
    if (arrayM.count) {
        
        NSMutableArray *arrayString = [NSMutableArray array];
        
        [arrayM enumerateObjectsUsingBlock:^(NSNumber *obj, NSUInteger idx, BOOL *stop) {
            YOSActivityFatherTypeModel *model = self.activityFatherTypeModels[self.currentFatherBtnIndex];
            
            YOSActivitySonTypeModel *sonModel = model.ctype[[obj unsignedIntegerValue]];
            
            [arrayString addObject:sonModel.ID];
        }];
        
        self.childType = [arrayString componentsJoinedByString:@","];
        
    } else {
        self.childType = @"";
    }
    
}

@end
