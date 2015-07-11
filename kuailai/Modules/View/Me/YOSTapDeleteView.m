//
//  YOSTapDeleteView.m
//  kuailai
//
//  Created by yangyang on 15/7/9.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSTapDeleteView.h"
#import "YOSButton.h"

#import "YOSTagModel.h"

#import "YOSUserDelTagRequest.h"

#import "Masonry.h"
#import "SVProgressHUD+YOSAdditions.h"
#import "GVUserDefaults+YOSProperties.h"

@interface YOSTapDeleteView ()

@property (nonatomic, assign, readwrite) CGSize yos_contentSize;

@end

@implementation YOSTapDeleteView {
    UILabel *_label;
    YOSButton *_deleteBtn;
    
    YOSTagModel *_tagModel;
}

- (instancetype)initWithTagModel:(YOSTagModel *)tagModel {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _tagModel = tagModel;
    
    [self setupSubviews];
    
    return self;
}

- (void)setupSubviews {
    _label = [UILabel new];
    _label.font = YOSFontNormal;
    _label.textColor = [UIColor whiteColor];
    _label.backgroundColor = YOSColorGreen;
    _label.text = _tagModel.name;
    _label.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:_label];
    
    _deleteBtn = [YOSButton new];
    
    [_deleteBtn setBackgroundImage:[UIImage imageNamed:@"关闭"] forState:UIControlStateNormal];
    [_deleteBtn addTarget:self action:@selector(tappedDeleteButton) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_deleteBtn];
    
    CGSize size = [_label sizeThatFits:_label.frame.size];
    size.width += 40;
    size.height = 30;
    [_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(size);
        make.left.and.bottom.mas_equalTo(0);
    }];
    
    [_deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.top.mas_equalTo(_label).offset(-10);
        make.right.mas_equalTo(_label).offset(10);
    }];
    
    self.yos_contentSize = CGSizeMake(size.width + 10, size.height + 10);
}

- (void)tappedDeleteButton {
    NSLog(@"%s", __func__);
    
    YOSUserDelTagRequest *request = [[YOSUserDelTagRequest alloc] initWithID:_tagModel.ID];
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    [request startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        
        [request yos_performCustomResponseErrorWithStatus:BusinessRequestStatusSuccess errorBlock:^{
            [SVProgressHUD showInfoWithStatus:@"删除成功~" maskType:SVProgressHUDMaskTypeClear];
        }];
        
        if ([request yos_checkResponse]) {
            // do nothing..
            
            // delete tagDictionary of GVUserDefaults
            NSDictionary *data = [GVUserDefaults standardUserDefaults].currentTagDictionary;
            
            NSMutableDictionary *mData = [NSMutableDictionary dictionaryWithDictionary:data];
            
            NSArray *arr = mData[@"data"];
            
            NSMutableArray *mArr = [NSMutableArray arrayWithArray:arr];
        
            [mArr enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
                if ([obj[@"id"] isEqualToString:_tagModel.ID]) {
                    YOSLog(@"delete");
                    [mArr removeObject:obj];
                }
            }];
            
            mData[@"data"] = mArr;
            
            [GVUserDefaults standardUserDefaults].currentTagDictionary = mData;
            
            // 发出更新tag通知
            [[NSNotificationCenter defaultCenter] postNotificationName:YOSNotificationUpdateTagInfo object:nil];
        }
        
    } failure:^(YTKBaseRequest *request) {
        [request yos_checkResponse];
    }];
}

@end
