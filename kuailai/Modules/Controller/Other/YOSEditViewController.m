//
//  YOSEditViewController.m
//  kuailai
//
//  Created by yangyang on 15/5/12.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSEditViewController.h"

#import "YOSTextView.h"
#import "IQKeyboardManager.h"
#import "SVProgressHUD+YOSAdditions.h"
#import "UIView+YOSAdditions.h"
#import "EDColor.h"

@interface YOSEditViewController () <UITextViewDelegate, UIScrollViewDelegate>

@end

@implementation YOSEditViewController {
    UIScrollView *_scrollView;
    YOSTextView *_textView;
    
    NSString *_title;
    NSString *_placeholder;
    NSUInteger _maxCharacters;
}

- (instancetype)initWithTitle:(NSString *)title placeholder:(NSString *)placeholder maxCharacters:(NSUInteger)maxCharacters {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _title = title;
    _placeholder = placeholder;
    _maxCharacters = maxCharacters;
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [_textView becomeFirstResponder];
}

- (void)setupSubviews {
    
    self.view.backgroundColor = [UIColor whiteColor];

    [IQKeyboardManager sharedManager].enable = NO;
    
    _scrollView = [UIScrollView new];
    _scrollView.contentSize = CGSizeMake(0, YOSScreenHeight + 5);
    _scrollView.frame = CGRectMake(0, 0, YOSScreenWidth, YOSScreenHeight);
    _scrollView.delegate = self;
    
    [self.view addSubview:_scrollView];
    
    _textView = [YOSTextView new];
    _textView.placeholder = _placeholder;
    _textView.delegate = self;
    _textView.text = _text;
    
    _textView.frame = CGRectMake(0, 64, YOSScreenWidth, YOSScreenHeight - 64 - 260 - 44);
    
    [_scrollView addSubview:_textView];
    

    [self setupNavigationBar];
    
    [self setupNavTitle:_title];
    [self setupLeftButtonWithTitle:@"取消"];
    [self setupRightButtonWithTitle:@"确定"];
}

- (void)clickLeftItem:(UIButton *)item {
    
    [_textView resignFirstResponder];
    
    [super clickLeftItem:item];
}

- (void)clickRightItem:(UIButton *)item {
    
    [_textView resignFirstResponder];
    
    if (self.vBlock) {
        self.vBlock(_textView.text);
    }
    
    [super clickRightItem:item];
}

#pragma mark - UITextViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    [_textView resignFirstResponder];
}

- (void)textViewDidChange:(UITextView *)textView {
    NSLog(@"\r\n\r\n%s", __func__);
    
    if (!textView.markedTextRange) {
        if (textView.text.length > _maxCharacters) {
            [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"最多可输入%zi个字符", _maxCharacters] maskType:SVProgressHUDMaskTypeClear];
            textView.text = [textView.text substringWithRange:NSMakeRange(0, _maxCharacters)];
        }
        
        [textView setNeedsDisplay];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
