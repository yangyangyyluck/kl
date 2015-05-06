//
//  YOSInputView.m
//  kuailai
//
//  Created by yangyang on 15/5/6.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSInputView.h"
#import "YOSTextField.h"
#import "YOSLRLabel.h"
#import "Masonry.h"

@interface YOSInputView () <UITextFieldDelegate>

@end

@implementation YOSInputView {
    YOSLRLabel *_titleLabel;
    NSMutableArray *_textFieldM;
    UIImageView *_imageView;
    
    BOOL _selected;
    NSString *_title;
    
    MASConstraint *_heightConstraint;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    
    _titleLabel = [YOSLRLabel new];
    _textFieldM = [NSMutableArray new];
    _imageView = [UIImageView new];
    
    YOSTextField *textField = [YOSTextField new];
    textField.delegate = self;
    [_textFieldM addObject:textField];
    
    [self addSubview:_titleLabel];
    [self addSubview:textField];
    [self addSubview:_imageView];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(8);
        make.size.mas_equalTo(CGSizeMake(75, 22));
        make.top.mas_equalTo(11);
    }];
    
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_titleLabel.mas_right).offset(8);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(44);
        make.top.mas_equalTo(0);
    }];
    
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.top.mas_equalTo(11);
        make.right.mas_equalTo(-8);
    }];
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        self->_heightConstraint = make.height.mas_equalTo(44);
    }];
    
    self.clipsToBounds = YES;
    
    return self;
}

- (instancetype)initWithTitle:(NSString *)title selectedStatus:(BOOL)selected {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _title = title;
    _selected = selected;
    
    if (selected) {
        _imageView.image = [UIImage imageNamed:@"绿色对号"];
    } else {
        _imageView.image = [UIImage imageNamed:@"灰色对号"];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _titleLabel.text = _title;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    CGSize oldSize = [textField.text sizeWithAttributes:@{NSFontAttributeName : textField.font}];
    
    CGSize newSize = [string sizeWithAttributes:@{NSFontAttributeName : textField.font}];
    
    // annotate: reduce imageView's size and two marign
    CGFloat maxWidth = textField.frame.size.width - 20 - 8 - 8;
    
    // create new YOSTextField and update it's constraints
    if (maxWidth <= (oldSize.width + newSize.width)) {
        YOSTextField *textField = [YOSTextField new];
        
        [_textFieldM addObject:textField];
        
        [self addSubview:textField];

        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_titleLabel.mas_right).offset(8);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(44);
            make.top.mas_equalTo(44 * (_textFieldM.count - 1));
        }];
        
        [self layoutIfNeeded];
        
        textField.backgroundColor = YOSColorRandom;
        
        _heightConstraint.offset(44 * _textFieldM.count);
        [UIView animateWithDuration:0.25f animations:^{
            [self.superview layoutIfNeeded];
        }];
        
        
        return NO;
    } else {
        return YES;
    }
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
