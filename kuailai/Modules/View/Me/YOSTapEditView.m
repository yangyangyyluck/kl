//
//  YOSTapEditView.m
//  kuailai
//
//  Created by yangyang on 15/7/9.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSTapEditView.h"
#import "YOSTapDeleteView.h"

#import "YOSTagModel.h"

#import "YOSUserAddTagRequest.h"

#import "UIView+YOSAdditions.h"
#import "Masonry.h"
#import "GVUserDefaults+YOSProperties.h"
#import "EDColor.h"
#import "UIImage+YOSAdditions.h"

@interface YOSTapEditView () <UIAlertViewDelegate, UITextFieldDelegate>

// tag models 数据
@property (nonatomic, strong) NSMutableArray *tags;

@property (nonatomic, strong) NSMutableArray *btns;

@property (nonatomic, assign) NSUInteger totalRows;

@property (nonatomic, strong) UIButton *addButton;

@property (nonatomic, weak) UIAlertView *alert;

@end

@implementation YOSTapEditView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (!self) {
        return nil;
    }
    
    _btns = [NSMutableArray array];
    
    [self setupAddButton];
    
    self.backgroundColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTagInfo) name:YOSNotificationUpdateTagInfo object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextFieldTextDidChangeNotification object:nil];
    
    return self;
}

- (void)setupAddButton {
    self.addButton = [UIButton new];
    
    [self.addButton setImage:[UIImage imageNamed:@"添加标签"] forState:UIControlStateNormal];
    
    [self.addButton setTitle:@"添加" forState:UIControlStateNormal];
    [self.addButton setTitleColor:YOSColorFontGray forState:UIControlStateNormal];
    
    self.addButton.imageEdgeInsets = UIEdgeInsetsMake(0, -8, 0, 0);
    self.addButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -8);
    
    self.addButton.titleLabel.font = YOSFontNormal;
    [self.addButton setBackgroundImage:[UIImage yos_imageWithColor:YOSColorGray size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
    
    [self.addButton addTarget:self action:@selector(addTag) forControlEvents:UIControlEventTouchUpInside];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setTapArray:(NSArray *)tapArray {
    _tapArray = tapArray;
    
    self.tags = [YOSTagModel arrayOfModelsFromDictionaries:tapArray];
}

- (void)setTags:(NSMutableArray *)tags {
    _tags = tags;
    
    [_btns enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromSuperview];
    }];
    
    [_btns removeAllObjects];
    
    [_tags enumerateObjectsUsingBlock:^(YOSTagModel *obj, NSUInteger idx, BOOL *stop) {
        YOSTapDeleteView *btn = [[YOSTapDeleteView alloc] initWithTagModel:obj];
        btn.tag = idx;
        
        [_btns addObject:btn];
        [self addSubview:btn];
    }];
    
    // addButton
    [_btns addObject:self.addButton];
    [self addSubview:self.addButton];
    
    CGFloat spaceX = 10.0f;
    CGFloat marginX = 15.0f;
    CGFloat lineHeight = 30.0f;
    CGFloat lineSpace = 20.0f;
    __block NSUInteger currentRow = 0;
    __block CGFloat currentWidth = marginX;    // left margin
    __block UIView *lastView = nil;
    [_btns enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        
        CGSize size;
        if ([obj isKindOfClass:[YOSTapDeleteView class]]) {
            size = ((YOSTapDeleteView *)obj).yos_contentSize;
        } else {    // addButton
            size = CGSizeMake(80, 30);
        }
        
        currentWidth = currentWidth + size.width + spaceX;
        
        if (currentWidth > YOSScreenWidth) {
            currentRow++;
            currentWidth = marginX + size.width + spaceX;
            
        }
        
        NSUInteger rowOfLastView = 0;
        if (lastView) {
            rowOfLastView = [lastView.yos_attachment unsignedIntegerValue];
        }
        
        [obj mas_makeConstraints:^(MASConstraintMaker *make) {
            
            if (rowOfLastView == currentRow && lastView) {
                make.left.mas_equalTo(lastView.mas_right).offset(10);
            } else {
                make.left.mas_equalTo(marginX);
            }
            
            if ([obj isKindOfClass:[YOSTapDeleteView class]]) {
                make.top.mas_equalTo(currentRow * (lineHeight + lineSpace) + 15);
            } else {    // addButton
                make.top.mas_equalTo(currentRow * (lineHeight + lineSpace) + 15 + 10);
            }
            
            make.size.mas_equalTo(size);
        }];
        
        lastView = obj;
        [lastView setYos_attachment:@(currentRow)];
    }];
    
    if (_btns.count) {
        self.totalRows = currentRow + 1;
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(currentRow * lineSpace + (self.totalRows) * lineHeight + 30);
        }];
    } else {
        self.totalRows = currentRow;
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
    }

}

#pragma mark - deal notification

- (void)updateTagInfo {
    NSLog(@"%s", __func__);
    
    NSDictionary *data = [GVUserDefaults standardUserDefaults].currentTagDictionary;
    
    NSArray *array = nil;
    if (data) {
        array = data[@"data"];
    }
    
    self.tapArray = array;
}

#pragma mark - network 

- (void)sendNetworkRequestWithString:(NSString *)string {
    YOSUserAddTagRequest *request = [[YOSUserAddTagRequest alloc] initWithUid:[GVUserDefaults standardUserDefaults].currentLoginID tagString:string];
    
    [request startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        if ([request yos_checkResponse]) {
            // add success.
            
            NSDictionary *tagDict = [GVUserDefaults standardUserDefaults].currentTagDictionary;
            
            NSMutableDictionary *mTagDict = [NSMutableDictionary dictionaryWithDictionary:tagDict];
            
            NSArray *data = tagDict[@"data"];
            
            NSMutableArray *mData = [NSMutableArray arrayWithArray:data];
            
            NSDictionary *lastDict = request.yos_data;
            
            [mData insertObject:lastDict atIndex:0];
            
            mTagDict[@"data"] = mData;
            
            [GVUserDefaults standardUserDefaults].currentTagDictionary = mTagDict;
            
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            YOSLog(@"tag : %@", mTagDict);
            
            [[NSNotificationCenter defaultCenter] postNotificationName:YOSNotificationUpdateTagInfo object:nil];
        }
    } failure:^(YTKBaseRequest *request) {
        [request yos_checkResponse];
    }];
}

#pragma mark - event response

- (void)addTag {
    NSLog(@"%s", __func__);
    
    NSDictionary *tapDict = [GVUserDefaults standardUserDefaults].currentTagDictionary;
    
    NSArray *tapArr = tapDict[@"data"];
    
    // 最多30个标签
    if (tapArr.count >= 30) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"最多可添加30个标签,已经30个了哦~" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请输入您的标签(10个字以内哦~)" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        alert.delegate = self;
        
        self.alert = alert;
        
        [alert show];
    }
    
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        // do nothing..
    } else {
        UITextField *textField = [alertView textFieldAtIndex:0];
        
        YOSLog(@"input tag : %@", textField.text);
        
        if (textField.text.length) {
            [self sendNetworkRequestWithString:textField.text];
        }
        
    }
}

#pragma mark - UITextFieldDelegate

- (void)textDidChange {
    UITextField *textField = [self.alert textFieldAtIndex:0];
    
    if (!textField.markedTextRange) {
        if (textField.text.length > 10) {
            textField.text = [textField.text substringToIndex:10];
        }
    }
    
}

@end
