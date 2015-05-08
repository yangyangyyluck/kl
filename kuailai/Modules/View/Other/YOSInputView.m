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
    UITextField *_firstTextField;
    UIImageView *_imageView;

    NSString *_title;
    NSUInteger _maxCharacters;
    NSUInteger _maxLines;
    
    MASConstraint *_heightConstraint;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    
    _titleLabel = [YOSLRLabel new];
    _titleLabel.font = [UIFont systemFontOfSize:14.0f];
    _textFieldM = [NSMutableArray new];
    _imageView = [UIImageView new];
    
    YOSTextField *textField = [YOSTextField new];
    textField.font = _titleLabel.font;
    textField.delegate = self;
    _firstTextField = textField;
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

- (instancetype)initWithTitle:(NSString *)title selectedStatus:(BOOL)selected maxCharacters:(NSUInteger)maxCharacters maxLines:(NSUInteger)maxLines {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _title = title;
    _selected = selected;
    
    _maxCharacters = maxCharacters;
    _maxLines = maxLines;
    
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
    
    YOSLog(@"%@ --- %@", NSStringFromRange(range), string);
    
    // 处理几个特殊情况
    // case 1.删除 range.length != 0, 删除一定会执行成功
    if (range.length != 0) {
        if (textField.text.length == range.length && textField != _firstTextField) {
            
            NSUInteger index = [_textFieldM indexOfObject:textField];
            [textField removeFromSuperview];
            [_textFieldM removeObjectAtIndex:index];
            
            _heightConstraint.offset(44 * _textFieldM.count);
            [UIView animateWithDuration:0.25f animations:^{
                [self.superview layoutIfNeeded];
            }];
            [_textFieldM[index - 1] becomeFirstResponder];
            
            return NO;
        }
    }
    
    // lines limit
    if (_maxLines != 0 && (_textFieldM.count >= _maxLines)) {
        return NO;
    }
    
    // characters limit
    if (_maxCharacters != 0 && (self.text.length + string.length >= _maxCharacters)) {
        return NO;
    }
    
    CGSize oldSize = [textField.text sizeWithAttributes:@{NSFontAttributeName : textField.font}];
    
    CGSize newSize = [string sizeWithAttributes:@{NSFontAttributeName : textField.font}];
    
    // create new YOSTextField and update it's constraints
    if ([self textFieldMaxWidth] <= (oldSize.width + newSize.width)) {
        
        YOSTextField *textField = [YOSTextField new];
        textField.delegate = self;
        [_textFieldM addObject:textField];
        
        [self addSubview:textField];

        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_titleLabel.mas_right).offset(8);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(44);
            make.top.mas_equalTo(44 * (_textFieldM.count - 1));
        }];
        
        [self layoutIfNeeded];
        
        _heightConstraint.offset(44 * _textFieldM.count);
        [UIView animateWithDuration:0.25f animations:^{
            [self.superview layoutIfNeeded];
        }];
        
        textField.text = string;
        [textField becomeFirstResponder];
        
        YOSLog(@"%@", [self text]);
        
        return NO;
    } else {
        return YES;
    }
    
}

- (NSString *)text {
    // get array with textField.text
    NSArray *array = [_textFieldM valueForKeyPath:@"text"];
    NSString *string = [array componentsJoinedByString:@""];
    
    return string;
}

- (CGFloat)height {
    return _textFieldM.count * 44.0f;
}

- (void)setSelected:(BOOL)selected {
    _selected = selected;
    
    if (selected) {
        _imageView.image = [UIImage imageNamed:@"绿色对号"];
    } else {
        _imageView.image = [UIImage imageNamed:@"灰色对号"];
    }
    
}

#pragma mark - private method list 
- (CGFloat)textFieldMaxWidth {
    // annotate: reduce imageView's size and two marign
    CGFloat maxWidth = _firstTextField.frame.size.width - 20 - 8 - 8;
    
    return maxWidth;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
