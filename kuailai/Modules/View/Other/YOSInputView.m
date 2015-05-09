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

#import "SVProgressHUD+YOSAdditions.h"
#import "UIView+YOSAdditions.h"
#import "EDColor.h"

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
    _titleLabel.textColor = [UIColor colorWithHexString:@"#858585"];
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
    self.backgroundColor = [UIColor whiteColor];
    
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

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    
    _firstTextField.placeholder = placeholder;
}

- (BOOL)isSelected {
    return _selected;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    YOSLog(@"%@ --- %@", NSStringFromRange(range), string);
    
    // 处理几个特殊情况
    // case 1.删除 range.length != 0, 删除一定会执行成功
    if (range.length != 0) {
        
        // 当前操作的index
        NSUInteger index = [_textFieldM indexOfObject:textField];
        
        // 删除文字后光标应该在的位置
        NSRange textRange = NSMakeRange(range.location, 0);
        
        // 删除该行
        if (textField.text.length == range.length && textField != _firstTextField) {
            
            [textField removeFromSuperview];
            [_textFieldM removeObjectAtIndex:index];
            
            [self updateConstraintsForTextFeild];
            
            // 光标指到上一行尾
            UITextField *lastField = [_textFieldM objectAtIndex:index - 1];
            
            if (lastField) {
                [lastField becomeFirstResponder];
            }
            
            self.selected = (BOOL)self.text.length;
            return NO;
            
        } else {    // 普通删除字符
                    // 每次删除都会重排字符
            textField.text = [textField.text stringByReplacingCharactersInRange:range withString:string];
            NSArray *tempArr = [_textFieldM subarrayWithRange:NSMakeRange(index, _textFieldM.count - index)];
            
            NSMutableArray *tempArrM = [tempArr mutableCopy];
            
            // 当前操作的是最后一行则不需要处理[因为上面已经处理过了]
//            if (tempArrM.count == 1) {
//                return NO;
//            }
            
            NSString *allString = [[tempArrM valueForKeyPath:@"text"] componentsJoinedByString:@""];
            
            // 设置一行消耗一行字符串
            while (allString.length) {
                
                NSString *subString = [allString copy];
                
                CGFloat nowWidth = [subString sizeWithAttributes:@{NSFontAttributeName : textField.font}].width;
                
                // 折半找出符合要求的最小的string
                while (nowWidth > [self textFieldMaxWidth]) {
                    
                    NSUInteger middle = (NSUInteger)ceil(subString.length / 2);
                    
                    subString = [subString substringToIndex:middle];
                    
                    nowWidth = [subString sizeWithAttributes:@{NSFontAttributeName : textField.font}].width;
                }
                
                // now nowWidth <= [self textFieldMaxWidth]
                while (subString.length < allString.length && nowWidth < [self textFieldMaxWidth]) {
                    YOSLog(@"%zi", subString);
                    subString = [allString substringToIndex:subString.length + 1];
                    nowWidth = [subString sizeWithAttributes:@{NSFontAttributeName : textField.font}].width;
                }
                
                if (nowWidth > [self textFieldMaxWidth]) {
                    subString = [subString substringToIndex:subString.length - 1];
                }
                
                UITextField *nowField = [tempArrM firstObject];
                
                nowField.text = subString;
                
                allString = [allString substringFromIndex:subString.length];
                
                [tempArrM removeObjectAtIndex:0];
                
            }
            
            if (tempArrM.count > 0) {
                [tempArrM enumerateObjectsUsingBlock:^(UITextField *obj, NSUInteger idx, BOOL *stop) {
                    if (obj != _firstTextField) {
                        [obj removeFromSuperview];
                        [_textFieldM removeObject:obj];
                    }
                    
                }];
                
                [self updateConstraintsForTextFeild];
                
            }
            
            // 光标在本行    [xxxx|xxx]
            // 删除到一行的最前面一位的时候，光标移动到上一行[如果上行存在的话]
            UITextField *lastField = nil;
            if (index) {
                lastField = [_textFieldM objectAtIndex:index - 1];
            }
            
            if (range.location == 0 && lastField) {
                [lastField becomeFirstResponder];
            } else {
                textField.selectedTextRange = [self textRangeForInput:textField atRange:textRange];
            }
            
        }
        
        self.selected = (BOOL)self.text.length;
        return NO;
        
    }
    
    // characters limit
    if (_maxCharacters != 0 && (self.text.length + string.length > _maxCharacters)) {
        
        [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"最多可输入%zi个字符", _maxCharacters] maskType:SVProgressHUDMaskTypeClear];
        
        self.selected = (BOOL)self.text.length;
        return NO;
    }
    
    // add characters
    if (range.length == 0) {
        // 当前操作的index
        NSUInteger index = [_textFieldM indexOfObject:textField];
        
        // 输入文字后光标应该在的位置
        NSRange textRange = NSMakeRange(range.location + string.length, 0);
        
        textField.text = [textField.text stringByReplacingCharactersInRange:range withString:string];
        
        NSArray *tempArr = [_textFieldM subarrayWithRange:NSMakeRange(index, _textFieldM.count - index)];
        
        NSMutableArray *tempArrM = [tempArr mutableCopy];
        
        NSString *allString = [[tempArrM valueForKeyPath:@"text"] componentsJoinedByString:@""];

        while (allString.length) {
            
            NSString *subString = [allString copy];
            
            CGFloat nowWidth = [subString sizeWithAttributes:@{NSFontAttributeName : textField.font}].width;
            
            // 折半找出符合要求的最小的string
            while (nowWidth > [self textFieldMaxWidth]) {
                
                NSUInteger middle = (NSUInteger)ceil(subString.length / 2);
                
                subString = [subString substringToIndex:middle];
                
                nowWidth = [subString sizeWithAttributes:@{NSFontAttributeName : textField.font}].width;
            }
            
            // now nowWidth <= [self textFieldMaxWidth]
            while (subString.length < allString.length && nowWidth < [self textFieldMaxWidth]) {
                YOSLog(@"%zi", subString);
                subString = [allString substringToIndex:subString.length + 1];
                nowWidth = [subString sizeWithAttributes:@{NSFontAttributeName : textField.font}].width;
            }
            
            if (nowWidth > [self textFieldMaxWidth]) {
                subString = [subString substringToIndex:subString.length - 1];
            }
            
            allString = [allString substringFromIndex:subString.length];
            
            if (tempArrM.count > 0) {
                UITextField *nowField = [tempArrM firstObject];
                
                nowField.text = subString;
                
                // 光标在本行    [xxxx|xxx]
                if (textRange.location <= subString.length) {
                    nowField.selectedTextRange = [self textRangeForInput:nowField atRange:textRange];
                } else {    // 光标在下一行
                    
                    textRange = NSMakeRange(textRange.location - textField.text.length, 0);
                    
                    if (tempArrM.count >= 2) {
                        
                        UITextField *nextField = [tempArrM objectAtIndex:1];
                        [nextField becomeFirstResponder];
                        
                        nextField.selectedTextRange = [self textRangeForInput:nextField atRange:textRange];
                        
                    }
                }
                
                [tempArrM removeObjectAtIndex:0];
            } else {    // YOSTextField不够了，需要新创建
                
                // lines limit
                if (_maxLines != 0 && (_textFieldM.count >= _maxLines)) {
                    
                    [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"最多可输入%zi行字符", _maxLines]  maskType:SVProgressHUDMaskTypeClear];
                    
                    self.selected = (BOOL)self.text.length;
                    return NO;
                }
                
                YOSTextField *nowField = [YOSTextField new];
                nowField.delegate = self;
                [_textFieldM addObject:nowField];
                
                [self addSubview:nowField];
                
                [nowField mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(_titleLabel.mas_right).offset(8);
                    make.right.mas_equalTo(0);
                    make.height.mas_equalTo(44);
                    make.top.mas_equalTo(44 * (_textFieldM.count - 1));
                }];
                
                [self layoutIfNeeded];
                
                _heightConstraint.offset(44 * _textFieldM.count);
                [UIView animateWithDuration:0.25f animations:^{
                    [self.yos_topestSuperview layoutIfNeeded];
                }];
                
                nowField.text = subString;
                
                // 光标在本行    [xxxx|xxx]
                if (textRange.location <= subString.length) {
                    
                    [nowField becomeFirstResponder];
    
                    nowField.selectedTextRange = [self textRangeForInput:nowField atRange:textRange];
                    
                } else {    // 光标在下一行
                    
                    textRange = NSMakeRange(1, 0);
                    
                    if (tempArrM.count >= 2) {
                        
                        UITextField *nextField = [tempArrM objectAtIndex:1];
                        [nextField becomeFirstResponder];
                        
                        nextField.selectedTextRange = [self textRangeForInput:nextField atRange:textRange];
                        
                    }
                }
                
            }
            
            
            
        }
        
        /*
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
            j
            [self layoutIfNeeded];
            
            _heightConstraint.offset(44 * _textFieldM.count);
            [UIView animateWithDuration:0.25f animations:^{
                [self.yos_topestSuperview layoutIfNeeded];
            }];
            
            textField.text = string;
            [textField becomeFirstResponder];
            
            YOSLog(@"%@", [self text]);
            
            return NO;
        } else {
            return YES;
        }
         */
    }
    
    self.selected = (BOOL)self.text.length;
    return NO;
}

- (UITextRange *)textRangeForInput:(UITextField *)input atRange:(NSRange)range {
    UITextPosition *start = [input positionFromPosition:[input beginningOfDocument] offset:range.location];
    
    UITextPosition *end = [input positionFromPosition:start offset:range.length];
    
    return [input textRangeFromPosition:start toPosition:end];
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

- (void)updateConstraintsForTextFeild {
    // update constraints
    [_textFieldM enumerateObjectsUsingBlock:^(UITextField *obj, NSUInteger idx, BOOL *stop) {
        [obj mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(44 * idx);
        }];
    }];
    
    _heightConstraint.offset(44 * _textFieldM.count);
    [UIView animateWithDuration:0.25f animations:^{
        [self.yos_topestSuperview layoutIfNeeded];
    }];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
