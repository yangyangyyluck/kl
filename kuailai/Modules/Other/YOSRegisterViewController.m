//
//  YOSRegisterViewController.m
//  kuailai
//
//  Created by yangyang on 15/4/9.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSRegisterViewController.h"

#import "Masonry.h"
#import "YOSWidget.h"

#import "UIColor+hex.h"
#import "UIImage+YOSAdditions.h"


@interface YOSRegisterViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *registerCodeButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineView2HeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineView1HeightConstraint;
@property (weak, nonatomic) IBOutlet UIButton *nextStepButton;
@property (weak, nonatomic) IBOutlet UITextField *mobileNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *verifyCodeTextField;

@end

@implementation YOSRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self setupNavTitle:@"注册"];
    
    [self setupSubviews];
}

- (void)setupSubviews {
    
    [self setupBackArrow];
    
    self.lineView1HeightConstraint.constant = 0.5;
    self.lineView2HeightConstraint.constant = 0.5;
    
    self.registerCodeButton.layer.cornerRadius = 10;
    self.registerCodeButton.layer.masksToBounds = YES;
    
    self.nextStepButton.layer.cornerRadius = 20.5;
    self.nextStepButton.layer.masksToBounds = YES;
    
    self.mobileNumberTextField.inputAccessoryView = [self accessoryViewWithTitle:@"下一步" method:@selector(signPasswordTextField)];
    
    self.verifyCodeTextField.inputAccessoryView = [self accessoryViewWithTitle:@"下一步" method:@selector(clickNextStepButton:)];
    
}

- (UIView *)accessoryViewWithTitle:(NSString *)title method:(SEL)sel {
    UIView *accessoryView = [UIView new];
    accessoryView.backgroundColor = [UIColor clearColor];
    
    UIButton *btn = [UIButton new];
    btn.backgroundColor = YOSColorGreen;
    [btn setTitle:title forState:UIControlStateNormal];
    btn.layer.cornerRadius = 3.0f;
    btn.layer.masksToBounds = YES;
    [btn addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    
    [accessoryView addSubview:btn];
    
    accessoryView.frame = CGRectMake(0, 0, YOSScreenWidth, 44);
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.right.and.bottom.mas_equalTo(0);
        make.width.mas_equalTo(100);
    }];
    
    return accessoryView;
}

#pragma mark - touch event

- (void)signPasswordTextField {
    [self.verifyCodeTextField becomeFirstResponder];
}

- (IBAction)clickRegisterCodeButton:(UIButton *)sender {
    NSLog(@"%s", __func__);
}
- (IBAction)clickNextStepButton:(UIButton *)sender {
    NSLog(@"%s", __func__);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"%s", __func__);
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if ([string isEqualToString:@""]) {
        return YES;
    }
    
    // tag 0 -> username
    if (textField.tag == 0 && textField.text.length >= 11) {
        return NO;
    }
    
    // tag 1 -> password
    if (textField.tag == 1 && textField.text.length >= 6) {
        return NO;
    }
    
    return [YOSWidget validateNumberWithTextField:textField shouldChangeCharactersInRange:range replacementString:string];
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
