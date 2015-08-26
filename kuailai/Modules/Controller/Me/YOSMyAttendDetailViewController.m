//
//  YOSMyAttendDetailViewController.m
//  kuailai
//
//  Created by yangyang on 15/7/13.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSMyAttendDetailViewController.h"
#import "YOSMyActivityView.h"
#import "YOSTimeView.h"
#import "YOSHideTextField.h"
#import "YOSChangeTouchButton.h"

#import "YOSActivityListModel.h"

#import "EDColor.h"
#import "UIView+YOSAdditions.h"
#import "Masonry.h"
#import "UIImage+MDQRCode.h"
#import "YOSLocalNotificationManager.h"
#import "AES128.h"
#import "IQUIView+IQKeyboardToolbar.h"

@implementation YOSMyAttendDetailViewController {
    UIScrollView *_scrollView;
    UIView *_contentView;
    
    YOSMyActivityView *_myActivityView;
    
    UIView *_grayContentView0;
    UILabel *_leftLabel0;
    YOSChangeTouchButton *_addButton;
    
    YOSTimeView *_timeView;
    // 黑魔法, 用 addButton 触发 textField
    YOSHideTextField *_hideTextField;
    UIDatePicker *_picker;
    
    UIView *_grayContentView1;
    UILabel *_leftLabel1;
    
    UIView *_bottomView;
    UIView *_bottomTopLineView;
    UIView *_imageContentView;
    UIView *_imageWhiteBackgroundView;
    UIImageView *_imageView;
    UILabel *_bottomLabel;
}

#pragma mark - life cycles

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavTitle:@"参与的活动"];
    [self setupBackArrow];
    
    [self setupSubviews];
}

- (void)dealloc {
    YOSLog(@"YOSMyAttendDetailViewController dealloc");
}

- (void)setupSubviews {

    _scrollView = [UIScrollView new];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    
    _contentView = [UIView new];
    _contentView.backgroundColor = YOSColorBackgroundGray;
    [_scrollView addSubview:_contentView];
    
    _myActivityView = [YOSMyActivityView new];
    _myActivityView.showBottomLine = YES;
    _myActivityView.showTopLine = NO;
    _myActivityView.activityListModel = self.activityListModel;
    [_contentView addSubview:_myActivityView];
    
    _grayContentView0 = [UIView new];
    _grayContentView0.backgroundColor = YOSColorBackgroundGray;
    [_contentView addSubview:_grayContentView0];
    
    _leftLabel0 = [UILabel new];
    _leftLabel0.font = YOSFontSmall;
    _leftLabel0.textColor = YOSColorFontGray;
    _leftLabel0.text = @"活动闹铃设置";
    [_grayContentView0 addSubview:_leftLabel0];
    
    _addButton = [YOSChangeTouchButton new];
    [_addButton setImage:[UIImage imageNamed:@"活动加号"] forState:UIControlStateNormal];
    [_grayContentView0 addSubview:_addButton];
    
    _hideTextField = [YOSHideTextField new];
    _hideTextField.agencyView = _addButton;
    _hideTextField.hideCursor = YES;
    _hideTextField.borderStyle = UITextBorderStyleNone;
    [_hideTextField addDoneOnKeyboardWithTarget:self action:@selector(doneAction)];
    UIDatePicker *picker = [UIDatePicker new];
    _picker = picker;
    picker.datePickerMode = UIDatePickerModeDateAndTime;
    picker.minimumDate = [NSDate date];
    _hideTextField.inputView = picker;
    [_contentView addSubview:_hideTextField];
    
    _timeView = [YOSTimeView new];
    YOSWObject(_timeView, weakObject);
    NSDictionary *userInfo = @{@"activityId" : self.activityListModel.ID, @"title" : self.activityListModel.title, @"start_time" : self.activityListModel.start_time};
    UILocalNotification *noti = [[YOSLocalNotificationManager sharedManager] notificationWithUserInfo:userInfo];
    NSDate *startDate = nil;
    if (noti) {
        startDate = noti.fireDate;
    }
    
    _timeView.alertDate = startDate;
    _timeView.swh.on = [[YOSLocalNotificationManager sharedManager] isExistNotificationWithUserInfo:userInfo];
    _timeView.idBlock = ^(UISwitch *swh) {
        
        if (swh.on) {
            
            if (weakObject.alertDate) {
                [[YOSLocalNotificationManager sharedManager] addNotificationWithDate:weakObject.alertDate UserInfo:userInfo];
            }
            
        } else {
            [[YOSLocalNotificationManager sharedManager] deleteNotificationWithUserInfo:userInfo];
        }
        
    };
    
    startDate = [NSDate dateWithTimeIntervalSince1970:[self.activityListModel.start_time integerValue] - 2 * 3600];
    
    NSTimeInterval interval0 = [startDate timeIntervalSince1970];
    NSTimeInterval interval1 = [[NSDate date] timeIntervalSince1970];
    
    // 过期了
    if (interval0 < interval1) {
        [_timeView expireTime];
        _addButton.userInteractionEnabled = NO;
        _hideTextField.userInteractionEnabled = NO;
    }
    
    [_contentView addSubview:_timeView];
    
    _grayContentView1 = [UIView new];
    _grayContentView1.backgroundColor = YOSColorBackgroundGray;
    [_contentView addSubview:_grayContentView1];
    
    _leftLabel1 = [_leftLabel0 yos_copySelf];
    _leftLabel1.text = @"入场二维码信息";
    [_grayContentView1 addSubview:_leftLabel1];
    
    _bottomView = [UIView new];
    _bottomView.backgroundColor = [UIColor whiteColor];
    [_contentView addSubview:_bottomView];
    
    _bottomTopLineView = [UIView new];
    _bottomTopLineView.backgroundColor = YOSColorLineGray;
    [_bottomView addSubview:_bottomTopLineView];
    
    _imageContentView = [UIView new];
    _imageContentView.backgroundColor = YOSColorBackgroundGray;
    _imageContentView.layer.cornerRadius = 10;
    _imageContentView.layer.masksToBounds = YES;
    [_bottomView addSubview:_imageContentView];
    
    _imageWhiteBackgroundView = [UIView new];
    _imageWhiteBackgroundView.backgroundColor = [UIColor whiteColor];
    [_imageContentView addSubview:_imageWhiteBackgroundView];
    
    _imageView = [UIImageView new];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    NSString *idString = [NSString stringWithFormat:@"%@-%@", self.activityListModel.uid, self.activityListModel.ID];
    NSString *AESCode = [AES128 AES128Encrypt:idString withKey:YOSAESKey];
    _imageView.image = [UIImage mdQRCodeForString:AESCode size:140];
    [_imageWhiteBackgroundView addSubview:_imageView];
    
    _bottomLabel = [_leftLabel0 yos_copySelf];
    _bottomLabel.text = @"扫描二维码";
    [_bottomView addSubview:_bottomLabel];
    
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero).priorityLow();
        make.width.mas_equalTo(YOSScreenWidth);
    }];
    
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero).priorityLow();
        make.width.mas_equalTo(YOSScreenWidth);
        make.bottom.mas_equalTo(_bottomView.mas_bottom);
    }];
    
    [_myActivityView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(YOSScreenWidth, 110));
    }];
    
    [_grayContentView0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_myActivityView.mas_bottom);
        make.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(YOSScreenWidth, 30));
    }];
    
    [_leftLabel0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.centerY.mas_equalTo(_grayContentView0);
    }];
    
    [_addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.top.and.right.mas_equalTo(0);
    }];
    
    [_hideTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 70));
        make.top.mas_equalTo(_grayContentView0.mas_bottom);
        make.left.mas_equalTo(0);
    }];
    
    [_timeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_grayContentView0.mas_bottom);
        make.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(YOSScreenWidth, 70));
    }];
    
    [_grayContentView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(_grayContentView0);
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(_timeView.mas_bottom);
    }];
    
    [_leftLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_grayContentView1);
        make.left.mas_equalTo(10);
    }];
    
    CGFloat height = 264;
    if (YOSIsIphone4 || YOSIsIphone5) {
        height = 264;
    } else {
        height = YOSScreenHeight - 64 - 110 - 30 - 70 - 30;
    }
    
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(_grayContentView1.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(YOSScreenWidth, height));
    }];
    
    [_bottomTopLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(YOSScreenWidth, 0.5));
        make.top.and.left.mas_equalTo(0);
    }];
    
    [_imageContentView mas_makeConstraints:^(MASConstraintMaker *make) {

        make.size.mas_equalTo(CGSizeMake(YOSAutolayout(170), YOSAutolayout(170)));
        make.centerX.mas_equalTo(_bottomView).priorityLow();
        
        if (YOSIsIphone5 || YOSIsIphone4) {
            make.top.mas_equalTo(25);
        } else {
            make.center.mas_equalTo(_bottomView);
        }
        
    }];
    
    [_imageWhiteBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(YOSAutolayout(150), YOSAutolayout(150)));
        make.center.mas_equalTo(_imageContentView);
    }];
    
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(YOSAutolayout(140), YOSAutolayout(140)));
        make.center.mas_equalTo(_imageWhiteBackgroundView);
    }];
    
    [_bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_bottomView);
        make.top.mas_equalTo(_imageContentView.mas_bottom).offset(10);
    }];
}

#pragma mark - event response

- (void)doneAction {
    _timeView.alertDate = _picker.date;
    
    if (_timeView.swh.on) {
        [[YOSLocalNotificationManager sharedManager] addNotificationWithDate:_picker.date UserInfo:@{@"activityId" : self.activityListModel.ID, @"title" : self.activityListModel.title, @"start_time" : self.activityListModel.start_time}];
    }
    
    [_hideTextField resignFirstResponder];
}

@end
