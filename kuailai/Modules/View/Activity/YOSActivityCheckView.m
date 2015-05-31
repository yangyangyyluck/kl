//
//  YOSActivityTypeView.m
//  kuailai
//
//  Created by yangyang on 15/5/30.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSActivityCheckView.h"
#import "EDColor.h"
#import "Masonry.h"
#import "UIImage+YOSAdditions.h"

@interface YOSActivityCheckView ()

@property (nonatomic, strong) NSArray *configBtns;

@end

@implementation YOSActivityCheckView {
    UIView *_topView;
    UILabel *_titleLabel;
    UISwitch *_swh;
    
    UIView *_bottomView;
    NSMutableArray *_bottomBtns;
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
    _titleLabel.text = @"审核报名";
    
    _swh = [UISwitch new];
    _swh.onTintColor = YOSRGB(76, 197, 158);
    [_swh setOn:YES];
    [_swh addTarget:self action:@selector(tappedSwitch:) forControlEvents:UIControlEventValueChanged];
    
    [_topView addSubview:_titleLabel];
    [_topView addSubview:_swh];
    
    UILabel *titleLabel2 = [UILabel new];
    titleLabel2.text = @"报名所需资料:";
    titleLabel2.font = YOSFontNormal;
    titleLabel2.textColor = YOSColorFontGray;
    [self addSubview:titleLabel2];
    
    _bottomView = [UIView new];
    _bottomBtns = [NSMutableArray array];
    
    [self addSubview:_bottomView];
    
    [self.configBtns enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
        
        UIButton *btn = [self buttonWithTitle:obj];
        btn.tag = idx;
        [_bottomBtns addObject:btn];
        [_bottomView addSubview:btn];
        
    }];
    
    // setup constraints
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.right.left.mas_equalTo(0);
        make.height.mas_equalTo(44);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.centerY.mas_equalTo(_topView);
    }];
    
    [_swh mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 35));
        make.centerY.mas_equalTo(_topView);
        make.right.mas_equalTo(-4);
    }];
    
    [titleLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_topView.mas_bottom);
        make.leading.mas_equalTo(_titleLabel);
        make.size.mas_equalTo(CGSizeMake(YOSScreenWidth - 8, 44));
    }];
    
    NSUInteger maxCols = 3;
    CGFloat marginX = 8;
    CGFloat spaceX = (YOSScreenWidth - maxCols * 93 - 2 * marginX) / (maxCols - 1);
    CGFloat marginY = 15;
    
    [_bottomBtns enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL *stop) {
        NSUInteger row = idx / maxCols;
        NSUInteger col = idx % maxCols;
        [obj mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(93, 25));
            make.left.mas_equalTo(marginX + (spaceX + 93) * col);
            make.top.mas_equalTo((marginY + 25) * row);
        }];
    }];
    
    NSUInteger maxRows = ceil(_bottomBtns.count / maxCols);
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLabel2.mas_bottom);
        make.left.and.right.mas_equalTo(0);
        make.height.mas_equalTo(maxRows * 25 + (maxRows - 1) * 15);
    }];
    
}

#pragma mark - event response

- (void)tappedSwitch:(UISwitch *)swh {
    if (swh.on) {
        _titleLabel.textColor = YOSColorFontBlack;
        
        [_bottomBtns enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL *stop) {
            obj.enabled = YES;
        }];
    } else {
        _titleLabel.textColor = YOSColorFontGray;
        
        [_bottomBtns enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL *stop) {
            obj.selected = NO;
            obj.enabled = NO;
        }];
    }
}

- (void)tappedButton:(UIButton *)button {
    button.selected = !button.selected;
}

#pragma mark - getter & setter

- (NSArray *)configBtns {
    
    if (!_configBtns) {
        _configBtns = @[@"姓名", @"手机号码", @"公司", @"工作职位", @"工作年限", @"学历",];
    }
    
    return _configBtns;
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

#pragma mark - public methods

- (CGFloat)currentHeight {
    return 44 + 44 + 25 * 2 + 15 + 20;
}

- (NSString *)isOpenCheck {
    return [NSString stringWithFormat:@"%zi", _swh.on];
}

- (NSString *)checkField {
    NSMutableArray *array = [NSMutableArray array];
    
    [_bottomBtns enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL *stop) {
        
        if (obj.selected) {
            [array addObject:[NSString stringWithFormat:@"%zi", obj.tag + 1]];
        }
        
    }];
    
    return [array componentsJoinedByString:@","];
}

@end
