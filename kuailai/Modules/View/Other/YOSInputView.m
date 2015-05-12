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
#import "YOSEditViewController.h"

#import "Masonry.h"
#import "SVProgressHUD+YOSAdditions.h"
#import "UIView+YOSAdditions.h"
#import "EDColor.h"

static CGFloat kOneLineHeight = 44.0f;

@interface YOSInputView () <UITextFieldDelegate, UITextViewDelegate>

@property (nonatomic, copy) NSString *textViewString;

@property (nonatomic, strong) YOSTextField *textField;

@end

@implementation YOSInputView {
    YOSLRLabel *_titleLabel;
    
    UIView *_lineView;
    UIImageView *_imageView;
    
    BOOL _single;
    UIButton *_textViewButton;

    NSString *_title;
    NSUInteger _maxCharacters;
    
    // datePickerType 不为None的时候采用datePicker
    UIDatePicker *_datePicker;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    
    return self;
}

- (instancetype)initWithTitle:(NSString *)title selectedStatus:(BOOL)selected maxCharacters:(NSUInteger)maxCharacters isSingleLine:(BOOL)single {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _single = single;
    _titleLabel = [YOSLRLabel new];
    _titleLabel.font = [UIFont systemFontOfSize:14.0f];
    _titleLabel.textColor = [UIColor colorWithHexString:@"#858585"];
    _imageView = [UIImageView new];
    
    _textField = [YOSTextField new];
    _textField.font = _titleLabel.font;
    _textField.delegate = self;
    UIView *rightView = [UIView new];
    rightView.frame = CGRectMake(0, 0, 20 + 8 + 8, 1);
    _textField.rightView = rightView;
    [_textField addTarget:self action:@selector(editingChanged:) forControlEvents:UIControlEventEditingChanged];
    
    [self addSubview:_textField];
    
    _lineView = [UIView new];
    _lineView.backgroundColor = [UIColor colorWithHexString:@"#e5e5e5"];
    [self addSubview:_lineView];
    
    if (!_single) {
        _textViewButton = [UIButton new];
        _textViewButton.adjustsImageWhenHighlighted = NO;
        [_textViewButton addTarget:self action:@selector(clickTextViewButton) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_textViewButton];
        _textViewButton.backgroundColor = [UIColor clearColor];
    }
    
    [self addSubview:_titleLabel];
    
    [self addSubview:_imageView];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(8);
        make.size.mas_equalTo(CGSizeMake(75, 22));
        make.top.mas_equalTo(11);
    }];

    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_titleLabel.mas_right).offset(8);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(kOneLineHeight);
        make.top.mas_equalTo(0);
    }];

    if (!_single) {
        [_textViewButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_titleLabel.mas_right).offset(8);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(kOneLineHeight);
            make.top.mas_equalTo(0);
        }];
    }
    
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.top.mas_equalTo(11);
        make.right.mas_equalTo(-8);
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(0);
        make.left.mas_equalTo(_textField);
        make.height.mas_equalTo(0.5f);
        make.bottom.mas_equalTo(0);
    }];
    
    self.clipsToBounds = YES;
    self.backgroundColor = [UIColor whiteColor];
    
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(kOneLineHeight);
    }];
    
    _title = title;
    _selected = selected;
    
    _maxCharacters = maxCharacters;
    
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
    
    _textField.placeholder = placeholder;
}

- (void)setDatePickerType:(YOSInputViewDatePickerType)datePickerType {
    _datePickerType = datePickerType;
    
    if (datePickerType == YOSInputViewDatePickerTypeActivity) {
        _datePicker = [UIDatePicker new];
        _datePicker.datePickerMode = UIDatePickerModeDateAndTime;
        _datePicker.minimumDate = [NSDate date];
        _textField.inputView = _datePicker;
    }
    
    if (datePickerType == YOSInputViewDatePickerTypeAge) {
        _datePicker = [UIDatePicker new];
        _datePicker.datePickerMode = UIDatePickerModeDate;
        _textField.inputView = _datePicker;
    }
    
}

#pragma mark - editingChanged

- (void)editingChanged:(UITextField *)textField {
    NSLog(@"\r\n\r\n%s", __func__);
    
    if (textField.text.length > _maxCharacters) {
        [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"最多可输入%zi个字符", _maxCharacters] maskType:SVProgressHUDMaskTypeClear];
        textField.text = [textField.text substringWithRange:NSMakeRange(0, _maxCharacters)];
    }
    
    self.selected = (BOOL)textField.text.length;
   
}

#pragma mark - public methods

- (NSString *)text {

    if (_single) {
        return _textField.text;
    } else {
        return self.textViewString;
    }

}

- (CGFloat)height {
    return kOneLineHeight;
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

- (void)clickTextViewButton {
    NSLog(@"%s", __func__);
    YOSEditViewController *editVC = [[YOSEditViewController alloc] initWithTitle:[_title substringToIndex:_title.length - 1] placeholder:_placeholder maxCharacters:_maxCharacters];
    editVC.text = self.text;
    
    YOSWSelf(weakSelf);
    editVC.vBlock = ^(id data){
        weakSelf.textViewString = [(NSString *)data copy];
        weakSelf.textField.text = [(NSString *)data copy];
        weakSelf.selected = (BOOL)weakSelf.textField.text.length;
    };
    
    [self.yos_viewController presentViewController:editVC animated:YES completion:nil];
}

// no used.
- (UITextRange *)textRangeForInput:(UITextField *)input atRange:(NSRange)range {
    UITextPosition *start = [input positionFromPosition:[input beginningOfDocument] offset:range.location];
    
    UITextPosition *end = [input positionFromPosition:start offset:range.length];
    
    return [input textRangeFromPosition:start toPosition:end];
}

// no used.
- (NSRange)rangeWithTextRange:(UITextRange *)textRange {
    NSString *string = [textRange description];
    
    NSUInteger left = [string rangeOfString:@"("].location;
    NSUInteger middle = [string rangeOfString:@","].location;
    NSUInteger right = [string rangeOfString:@")"].location;
    
    NSString *num1 = [string substringWithRange:NSMakeRange(left + 1, middle - left - 1)];
    
    NSString *num2 = [string substringWithRange:NSMakeRange(middle + 1, right - middle - 2)];
    
    return NSMakeRange([num1 integerValue], [num2 integerValue]);
}

// no used.
- (NSString *)suitableStringWithString:(NSString *)allString {
    
    NSString *subString = [allString copy];
    
    CGFloat nowWidth = [subString sizeWithAttributes:@{NSFontAttributeName : _textField.font}].width;
    
    // 折半找出符合要求的最小的string
    while (nowWidth > [self textFieldMaxWidth]) {
        
        NSUInteger middle = (NSUInteger)ceil(subString.length / 2);
        
        subString = [subString substringToIndex:middle];
        
        nowWidth = [subString sizeWithAttributes:@{NSFontAttributeName : _textField.font}].width;
    }
    
    // now nowWidth <= [self textFieldMaxWidth]
    while (subString.length < allString.length && nowWidth < [self textFieldMaxWidth]) {
        subString = [allString substringToIndex:subString.length + 1];
        nowWidth = [subString sizeWithAttributes:@{NSFontAttributeName : _textField.font}].width;
    }
    
    if (nowWidth > [self textFieldMaxWidth]) {
        subString = [subString substringToIndex:subString.length - 1];
    }
    
    YOSLog(@"\r\n\r\n%zi", subString.length);
    
    return subString;
}

// no used.
- (CGFloat)textFieldMaxWidth {
    // annotate: reduce imageView's size and two marign
    CGFloat maxWidth = _textField.frame.size.width - 20 - 8 - 8;
    
    return maxWidth;
}

@end
