//
//  YOSFeedbackViewController.m
//  kuailai
//
//  Created by yangyang on 15/8/14.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSFeedbackViewController.h"
#import "YOSTextView.h"

#import "YOSUserInfoModel.h"

#import "YOSUserFeedbackRequest.h"

#import "SVProgressHUD+YOSAdditions.h"
#import "UIView+YOSAdditions.h"
#import "UIImage+YOSAdditions.h"
#import "EDColor.h"
#import "Masonry.h"
#import "GVUserDefaults+YOSProperties.h"

@interface YOSFeedbackViewController () <UITextViewDelegate>

@end

@implementation YOSFeedbackViewController {
    YOSTextView *_textView;
    
    UIButton *_submitButton;
    UILabel *_noticeLabel;
    
    NSUInteger _maxCharacters;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _maxCharacters = 500;
    
    [self setupNavTitle:@"意见反馈"];
    
    [self setupBackArrow];
    
    [self setupSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    [_textView becomeFirstResponder];
}

- (void)setupSubviews {
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _noticeLabel = [UILabel new];
    _noticeLabel.textColor = YOSColorFontGray;
    _noticeLabel.font = YOSFontNormal;
    _noticeLabel.numberOfLines = 0;
    _noticeLabel.text = @"请把您的意见和建议填入文字编辑框中,我们会及时处理,谢谢您的反馈";
    
    [self.view addSubview:_noticeLabel];
    
    CGSize size = [_noticeLabel.text boundingRectWithSize:CGSizeMake(YOSScreenWidth - 40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : YOSFontNormal} context:nil].size;
    
    [_noticeLabel sizeToFit];
    [_noticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.bottom.mas_equalTo(-50);
        make.size.mas_equalTo(size);
    }];
    
    _submitButton = [UIButton new];
    [_submitButton setTitle:@"提交" forState:UIControlStateNormal];
    [_submitButton setBackgroundImage:[UIImage yos_imageWithColor:YOSColorGreen size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
    _submitButton.titleLabel.font = YOSFontNormal;
    [_submitButton addTarget:self action:@selector(tappedSubmitButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_submitButton];
    
    [_submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(40);
        make.bottom.mas_equalTo(_noticeLabel.mas_top).offset(-25);
    }];
    
    _textView = [YOSTextView new];
    _textView.placeholder = @"请留言(500字内)";
    _textView.delegate = self;
    _textView.layer.borderColor = YOSColorLineGray.CGColor;
    _textView.layer.borderWidth = 0.5f;
    
    _textView.frame = CGRectMake(0, 64, YOSScreenWidth, YOSScreenHeight - 64 - 260 - 44);
    
    [self.view addSubview:_textView];
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(10, 10, 10, 10)).priorityLow();
        make.bottom.mas_equalTo(_submitButton.mas_top).offset(-25);
        
    }];
    
}

#pragma mark - event response 

- (void)tappedSubmitButton {
    NSLog(@"%s", __func__);
    
    if (_textView.text.length) {
        [self sendNetworkRequest];
    } else {
        [SVProgressHUD showErrorWithStatus:@"请先编辑意见~" maskType:SVProgressHUDMaskTypeClear];
    }
    
}

#pragma mark - network

- (void)sendNetworkRequest {
    NSString *uid = [GVUserDefaults standardUserDefaults].currentLoginID;
    
    YOSUserFeedbackRequest *request = [[YOSUserFeedbackRequest alloc] initWithUid:uid demand:_textView.text];
                                       
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    [request startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        
        [request yos_performCustomResponseErrorWithStatus:BusinessRequestStatusSuccess errorBlock:^{
            [SVProgressHUD showSuccessWithStatus:@"提交成功~" maskType:SVProgressHUDMaskTypeClear];
        }];
        
        if ([request yos_checkResponse]) {
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.4f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
            
        }
        
    } failure:^(YTKBaseRequest *request) {
        [request yos_checkResponse];
    }];
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
    NSLog(@"\r\n\r\n%s", __func__);
    
    if (!textView.markedTextRange) {
        if (_maxCharacters && (textView.text.length > _maxCharacters)) {
            [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"最多可输入%zi个字符", _maxCharacters] maskType:SVProgressHUDMaskTypeClear];
            textView.text = [textView.text substringWithRange:NSMakeRange(0, _maxCharacters)];
        }
        
        [textView setNeedsDisplay];
    }
    
}

@end
