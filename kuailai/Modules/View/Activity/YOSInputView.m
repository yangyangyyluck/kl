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
#import "YOSDBManager.h"
#import "YOSCityModel.h"
#import "YOSRegionModel.h"
#import "YOSWidget.h"

static CGFloat kOneLineHeight = 44.0f;

@interface YOSInputView () <UITextFieldDelegate, UITextViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, copy) NSString *textViewString;

@property (nonatomic, strong) YOSTextField *textField;


@property (nonatomic, copy) NSString *dateString;

// YOSInputViewPickerTypeAllCity
@property (nonatomic, copy) NSString *city;

@property (nonatomic, copy) NSString *region;

@property (nonatomic, copy) NSString *cityId;

@property (nonatomic, copy) NSString *regionId;

// YOSInputViewPickerTypeSex
@property (nonatomic, strong) NSArray *sexDataSource;

// YOSInputViewPickerTypeEducation
@property (nonatomic, strong) NSArray *educationDataSource;

// YOSInputViewPickerTypeJobYears
@property (nonatomic, strong) NSArray *jobYearsDataSource;

@end

@implementation YOSInputView {
    YOSLRLabel *_titleLabel;
    UILabel *_symbolLabel;
    
    UIView *_lineView;
    UIImageView *_imageView;
    
    BOOL _single;
    UIButton *_textViewButton;

    NSString *_title;
    NSUInteger _maxCharacters;
    
    // pickerType 不为None的时候采用datePicker
    UIDatePicker *_datePicker;
    
    UIPickerView *_pickerView;
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
    
    _symbolLabel = [UILabel new];
    _symbolLabel.font = [UIFont systemFontOfSize:14.0f];
    _symbolLabel.textColor = [UIColor colorWithHexString:@"#858585"];
    _symbolLabel.text = @":";
    
    [self addSubview:_symbolLabel];
    
    _textField = [YOSTextField new];
    _textField.font = _titleLabel.font;
    _textField.delegate = self;
    UIView *rightView = [UIView new];
    rightView.frame = CGRectMake(0, 0, 20 + 8 + 8, 10);
    _textField.rightView = rightView;
    _textField.rightViewMode = UITextFieldViewModeAlways;
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
        make.size.mas_equalTo(CGSizeMake(60, 22));
        make.top.mas_equalTo(11);
    }];
    
    [_symbolLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_titleLabel.mas_right);
        make.centerY.mas_equalTo(_titleLabel);
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBeginEditing:) name:UITextFieldTextDidBeginEditingNotification object:nil];
    
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

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _titleLabel.text = _title;
}

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    
    _textField.placeholder = placeholder;
}

- (void)setPickerType:(YOSInputViewPickerType)pickerType {
    _pickerType = pickerType;
    
    if (pickerType == YOSInputViewPickerTypeActivity) {
        _datePicker = [UIDatePicker new];
        _datePicker.datePickerMode = UIDatePickerModeDateAndTime;
        _datePicker.minimumDate = [NSDate date];
        [_datePicker addTarget:self action:@selector(dateChange:)forControlEvents:UIControlEventValueChanged];
        _textField.inputView = _datePicker;
//        _textField.hideCursor = YES;
    }
    
    if (pickerType == YOSInputViewPickerTypeAge) {
        _datePicker = [UIDatePicker new];
        _datePicker.datePickerMode = UIDatePickerModeDate;
        [_datePicker addTarget:self action:@selector(dateChange:)forControlEvents:UIControlEventValueChanged];
        _textField.inputView = _datePicker;
//        _textField.hideCursor = YES;
    }
    
    if (pickerType == YOSInputViewPickerTypeAllCity) {
        _pickerView = [UIPickerView new];
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
        _textField.inputView = _pickerView;
//        _textField.hideCursor = YES;
    }
    
    if (pickerType == YOSInputViewPickerTypeSex) {
        _pickerView = [UIPickerView new];
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
        _textField.inputView = _pickerView;
        //        _textField.hideCursor = YES;
    }
    
    if (pickerType == YOSInputViewPickerTypeEducation) {
        _pickerView = [UIPickerView new];
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
        _textField.inputView = _pickerView;
        //        _textField.hideCursor = YES;
    }
    
    if (pickerType == YOSInputViewPickerTypeJobYears) {
        _pickerView = [UIPickerView new];
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
        _textField.inputView = _pickerView;
        //        _textField.hideCursor = YES;
    }
    
}

- (void)setKeyboardType:(UIKeyboardType)keyboardType {
    _keyboardType = keyboardType;
    
    _textField.keyboardType = keyboardType;
}

#pragma mark - editingChanged

- (void)editingChanged:(UITextField *)textField {
    NSLog(@"\r\n\r\n%s", __func__);
    
    // 有markedTextRange 为输入阶段 不检测
    if (!textField.markedTextRange) {

        if (_maxCharacters && (textField.text.length > _maxCharacters)) {
            [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"最多可输入%zi个字符", _maxCharacters] maskType:SVProgressHUDMaskTypeClear];
            
            NSLog(@"%@ --- %zi", textField.text, textField.text.length);
            
            textField.text = [textField.text substringWithRange:NSMakeRange(0, _maxCharacters)];
        }
        
        self.selected = [self canSelectedWithString:textField.text];
        
    }
   
}

- (void)didBeginEditing:(NSNotification *)noti {
    
    if ([noti.object isEqual:_textField] && _textField.text.length == 0 && self.pickerType == YOSInputViewPickerTypeAllCity) {
        
        [((UIPickerView *)_textField.inputView) selectRow:0 inComponent:0 animated:NO];
        
        YOSCityModel *cityModel = (YOSCityModel *)self.dataSource[0];
        
        NSString *text = nil;
        
        NSString *city = cityModel.name;
        
        NSString *region = @"";
        
        YOSRegionModel *regionModel = (YOSRegionModel *)cityModel.area[0];
        
        if (cityModel.area.count) {
            region = regionModel.name;
            
            text = [NSString stringWithFormat:@"%@ %@ ", city, region];
        } else {
            text = [NSString stringWithFormat:@"%@ ", city];
        }
        
        self.city = city;
        self.cityId = cityModel.ID;
        self.region = region;
        self.regionId = regionModel.ID;
        
        _textField.text = text;
        self.selected = YES;
    }
    
    if ([noti.object isEqual:_textField] && _textField.text.length == 0 && self.pickerType == YOSInputViewPickerTypeSex) {
        _textField.text = self.sexDataSource[0];
        self.sexId = @"1";
        self.selected = YES;
    }
    
    if ([noti.object isEqual:_textField] && _textField.text.length == 0 && self.pickerType == YOSInputViewPickerTypeEducation) {
        _textField.text = self.educationDataSource[0];
        self.educationId = @"1";
        self.selected = YES;
    }
    
    if ([noti.object isEqual:_textField] && _textField.text.length == 0 && self.pickerType == YOSInputViewPickerTypeJobYears) {
        _textField.text = self.jobYearsDataSource[0];
        self.jobYearsId = @"1";
        self.selected = YES;
    }
}

#pragma mark - UIDatePicker valueChanged

- (void)dateChange:(UIDatePicker *)datePicker {
    YOSLog(@"%@", datePicker.date);
    if (self.pickerType == YOSInputViewPickerTypeAge) {
        
    }
    
    if (self.pickerType == YOSInputViewPickerTypeActivity) {
        _textField.text = [YOSWidget dateStringWithDate:datePicker.date Format:@"YYYY年MM月dd HH:mm"];
        self.selected = YES;
        self.dateString = [NSString stringWithFormat:@"%zi", (NSUInteger)[datePicker.date timeIntervalSince1970]];
        
        NSLog(@"\r\n\r\ndateString : %@", self.dateString);
    }
}

#pragma mark - public methods

- (NSString *)text {
    
    // 如果是当前是显示时间，返回时间戳
    if (self.pickerType == YOSInputViewPickerTypeAge || self.pickerType == YOSInputViewPickerTypeActivity) {
        return self.dateString;
    }

    if (_single) {
        return _textField.text;
    } else {
        return self.textViewString;
    }

}

- (NSString *)textWithoutWhitespace {
    // 如果是当前是显示时间，返回时间戳
    if (self.pickerType == YOSInputViewPickerTypeAge || self.pickerType == YOSInputViewPickerTypeActivity) {
        return self.dateString;
    }
    
    if (_single) {
        
        NSString *string = _textField.text;
        
        NSMutableString *mString = [string mutableCopy];
        
        [mString replaceOccurrencesOfString:@" " withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, mString.length)];
        
        return [mString copy];
    } else {
        
        NSString *string = self.textViewString;
        
        NSMutableString *mString = [string mutableCopy];
        
        [mString replaceOccurrencesOfString:@" " withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, mString.length)];
        
        return [mString copy];
    }
}

- (CGFloat)height {
    return kOneLineHeight;
}

- (NSDate *)date {
    return _datePicker.date;
}

- (void)setSelected:(BOOL)selected {
    _selected = selected;
    
    if (selected) {
        _imageView.image = [UIImage imageNamed:@"绿色对号"];
    } else {
        _imageView.image = [UIImage imageNamed:@"灰色对号"];
    }
    
}

#pragma mark UIPickerView DataSource & Delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    BOOL b1 = (self.pickerType == YOSInputViewPickerTypeSex);
    BOOL b2 = (self.pickerType == YOSInputViewPickerTypeJobYears);
    BOOL b3 = (self.pickerType == YOSInputViewPickerTypeEducation);
    
    if (b1 || b2 || b3) {
        return 1;
    } else {
        return 2;
    }
    
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    if (self.pickerType == YOSInputViewPickerTypeAllCity) {
        if (component == 0) {
            return self.dataSource.count;
        } else {
            
            NSUInteger row = [pickerView selectedRowInComponent:0];
            
            // nothing selected
            if (row == -1) {
                row = 0;
            }
            
            YOSCityModel *city = (YOSCityModel *)self.dataSource[row];
            
            NSArray *arr = city.area;
            
            return arr.count;
        }
    }
    
    if (self.pickerType == YOSInputViewPickerTypeSex) {
        return self.sexDataSource.count;
    }
    
    if (self.pickerType == YOSInputViewPickerTypeEducation) {
        return self.educationDataSource.count;
    }
    
    if (self.pickerType == YOSInputViewPickerTypeJobYears) {
        return self.jobYearsDataSource.count;
    }
    
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if (self.pickerType == YOSInputViewPickerTypeAllCity) {
        if (component == 0) {
            YOSCityModel *city = self.dataSource[row];
            return city.name;
        } else {
            NSUInteger index = [pickerView selectedRowInComponent:0];
            
            YOSCityModel *city = (YOSCityModel *)self.dataSource[index];
            
            NSArray *arr = city.area;
            
            return ((YOSRegionModel *)arr[row]).name;
        }
    }
    
    if (self.pickerType == YOSInputViewPickerTypeSex) {
        return self.sexDataSource[row];
    }
    
    if (self.pickerType == YOSInputViewPickerTypeEducation) {
        return self.educationDataSource[row];
    }
    
    if (self.pickerType == YOSInputViewPickerTypeJobYears) {
        return self.jobYearsDataSource[row];
    }
    
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if (self.pickerType == YOSInputViewPickerTypeAllCity) {
        if (component == 0) {
            YOSCityModel *cityModel = (YOSCityModel *)self.dataSource[row];
            
            NSString *text = nil;
            
            NSString *city = cityModel.name;
            
            NSString *region = @"";
            
            YOSRegionModel *regionModel = (YOSRegionModel *)cityModel.area[0];
            
            if (cityModel.area.count) {
                region = regionModel.name;
                
                text = [NSString stringWithFormat:@"%@ %@ ", city, region];
            } else {
                text = [NSString stringWithFormat:@"%@ ", city];
            }
            
            self.city = city;
            self.cityId = cityModel.ID;
            self.region = region;
            self.regionId = regionModel.ID;
            
            [pickerView selectRow:0 inComponent:1 animated:NO];
            
            _textField.text = text;
            self.selected = YES;
            
        } else {
            NSUInteger index = [pickerView selectedRowInComponent:0];
            
            YOSCityModel *cityModel = (YOSCityModel *)self.dataSource[index];
            
            NSString *text = nil;
            
            NSString *city = cityModel.name;
            
            NSString *region = @"";
            
            YOSRegionModel *regionModel = (YOSRegionModel *)cityModel.area[row];
            
            if (cityModel.area.count) {
                region = regionModel.name;
                
                text = [NSString stringWithFormat:@"%@ %@ ", city, region];
            } else {
                text = [NSString stringWithFormat:@"%@ ", city];
            }
            
            self.city = city;
            self.cityId = cityModel.ID;
            self.region = region;
            self.regionId = regionModel.ID;
            
            _textField.text = text;
            self.selected = YES;
        }
        
        if (component == 0) {
            [pickerView reloadAllComponents];
        }
    }
    
    if (self.pickerType == YOSInputViewPickerTypeSex) {
        _textField.text = self.sexDataSource[row];
        self.sexId = [NSString stringWithFormat:@"%zi", row + 1];
        self.selected = YES;
    }
    
    if (self.pickerType == YOSInputViewPickerTypeEducation) {
        _textField.text = self.educationDataSource[row];
        self.educationId = [NSString stringWithFormat:@"%zi", row + 1];
        self.selected = YES;
    }
    
    if (self.pickerType == YOSInputViewPickerTypeJobYears) {
        _textField.text = self.jobYearsDataSource[row];
        self.jobYearsId = [NSString stringWithFormat:@"%zi", row + 1];
        self.selected = YES;
    }
}

#pragma mark - event response

- (void)clickTextViewButton {
    NSLog(@"%s", __func__);
    YOSEditViewController *editVC = [[YOSEditViewController alloc] initWithTitle:_title placeholder:_placeholder maxCharacters:_maxCharacters];
    editVC.text = self.textField.text;
    
    YOSWSelf(weakSelf);
    editVC.vBlock = ^(id data){
        weakSelf.textViewString = [(NSString *)data copy];
        weakSelf.textField.text = [(NSString *)data copy];
        
        weakSelf.selected = [self canSelectedWithString:weakSelf.textField.text];
    };
    
    [self.yos_viewController presentViewController:editVC animated:YES completion:nil];
}

#pragma mark - private method list

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

- (BOOL)canSelectedWithString:(NSString *)string {
    
    NSMutableString *mString = [string mutableCopy];
    
    [mString replaceOccurrencesOfString:@" " withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, mString.length)];
    
    return (BOOL)mString.length;
}

#pragma mark - getter & setter

- (NSArray *)sexDataSource {
//    1. 男
//    2. 女
    return @[@"男", @"女"];
}

- (NSArray *)educationDataSource {
//    1. 高中
//    2. 大专
//    3. 本科
//    4. 硕士
//    5. 博士
//    6. 其他
    return @[@"高中", @"大专", @"本科", @"硕士", @"博士", @"其他"];
}

- (NSArray *)jobYearsDataSource {
//    1. 1年以下
//    2. 1-3年
//    3. 3-5年
//    4. 5-10年
//    5. 10年以上
    return @[@"1年以下", @"1-3年", @"3-5年", @"5-10年", @"10年以上"];
}

@end
