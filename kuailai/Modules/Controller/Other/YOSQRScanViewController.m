//
//  YOSQRScanViewController.m
//  kuailai
//
//  Created by yangyang on 15/7/12.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSQRScanViewController.h"

#import "YOSUserConfirmRegisterRequest.h"

#import <AVFoundation/AVFoundation.h>
#import "Masonry.h"
#import "UIView+YOSAdditions.h"
#import "AES128.h"
#import "SVProgressHUD+YOSAdditions.h"

@interface YOSQRScanViewController () <UIAlertViewDelegate,AVCaptureMetadataOutputObjectsDelegate>

/** 扫描结果 */
@property (nonatomic, retain)NSString *resultString;

@property (nonatomic, strong) MASConstraint *constraint;

@property (nonatomic, assign) BOOL hasOpenLamp;

@property (nonatomic, assign) BOOL canRestart;

@property (nonatomic, assign) BOOL isStopAnimation;

@property (nonatomic, assign) BOOL isViewWillAppear;

@property (strong, nonatomic)AVCaptureDevice            *device;
@property (strong, nonatomic)AVCaptureDeviceInput       *input;
@property (strong, nonatomic)AVCaptureMetadataOutput    *output;
@property (strong, nonatomic)AVCaptureSession           *session;
@property (strong, nonatomic)AVCaptureVideoPreviewLayer *preview;

@end

@implementation YOSQRScanViewController {
    UIImageView *_scanImageView;
    UIImageView *_scanLineView;
    
    UIView *_topBackgroundView;
    UIView *_leftBackgroundView;
    UIView *_rightBackgroundView;
    UIView *_bottomBackgroundView;
}

#pragma mark - life cycles

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupNavTitle:@"二维码检票"];
    
    [self setupBackArrow];
    
    [self setupSubviews];
}

- (void)dealloc {
    YOSLog(@"YOSQRScanViewController dealloc");
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.isViewWillAppear = YES;
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [self restart];
    }

}

- (void)setupSubviews {
    _scanImageView = [UIImageView new];
    _scanImageView.backgroundColor = [UIColor clearColor];
    _scanImageView.image = [UIImage imageNamed:@"二维码框框"];
    [self.view addSubview:_scanImageView];
    
    _scanLineView = [UIImageView new];
    _scanLineView.image = [UIImage imageNamed:@"二维码扫描条"];
    [_scanImageView addSubview:_scanLineView];
    
    _topBackgroundView = [UIView new];
    _topBackgroundView.backgroundColor = [UIColor blackColor];
    _topBackgroundView.alpha = 0.4f;
    [self.view addSubview:_topBackgroundView];
    
    _leftBackgroundView = [_topBackgroundView yos_copySelf];
    [self.view addSubview:_leftBackgroundView];
    
    _rightBackgroundView = [_topBackgroundView yos_copySelf];
    [self.view addSubview:_rightBackgroundView];
    
    _bottomBackgroundView = [_topBackgroundView yos_copySelf];
    [self.view addSubview:_bottomBackgroundView];
    
    [_scanImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(200, 200));
    }];
    
    [_scanLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        self.constraint = make.top.mas_equalTo(0);
        make.left.and.right.mas_equalTo(0);
        make.height.mas_equalTo(20);
    }];
    
    [_topBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.and.right.mas_equalTo(0);
        make.bottom.mas_equalTo(_scanImageView.mas_top);
    }];
    
    [_bottomBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.bottom.and.right.mas_equalTo(0);
        make.top.mas_equalTo(_scanImageView.mas_bottom);
    }];
    
    [_leftBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(_topBackgroundView.mas_bottom);
        make.right.mas_equalTo(_scanImageView.mas_left);
        make.bottom.mas_equalTo(_bottomBackgroundView.mas_top);
    }];
    
    [_rightBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_scanImageView.mas_right);
        make.top.mas_equalTo(_leftBackgroundView);
        make.bottom.mas_equalTo(_leftBackgroundView);
        make.right.mas_equalTo(0);
    }];
    
}

#pragma mark - event response 

- (void)clickLeftItem:(UIButton *)item {
    
    [self stopCamera];
    
    [super clickLeftItem:item];
}

#pragma mark AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    [_session stopRunning];
    
    if ([metadataObjects count] > 0)
    {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        self.resultString = metadataObject.stringValue;
        
        // here stop animation
        self.isStopAnimation = YES;
        [self performSelector:@selector(dealWithResult) withObject:nil afterDelay:0.5];
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self restart];
    }
}

#pragma mark - network

- (void)sendNetworkRequestWithUid:(NSString *)uid aid:(NSString *)aid {
    YOSUserConfirmRegisterRequest *request = [[YOSUserConfirmRegisterRequest alloc] initWithUid:uid aid:aid];
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    [request startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        [request yos_checkResponse:NO];
        
        // 验票成功
        if ([request.yos_baseResponseModel.code integerValue] == 200) {
            NSString *msg = [NSString stringWithFormat:@"验票成功!\r\n用户:%@", request.yos_data[@"nickname"]];
            [self showAlertWithMessage:msg];
        }
        
        // 验票失败等
        if ([request.yos_baseResponseModel.code integerValue] == 400) {
            NSString *msg = [NSString stringWithFormat:@"验票失败!\r\n原因:%@", request.yos_baseResponseModel.msg];
            [self showAlertWithMessage:msg];
        }
        
    } failure:^(YTKBaseRequest *request) {
        [request yos_checkResponse];
    }];
}

#pragma mark - private methods

- (void)doAnimation {
    
    static BOOL isTop = YES;
    
    if (isTop) {
        self.constraint.offset = 180;
    } else {
        self.constraint.offset = 0;
    }
    
    
    YOSWSelf(weakSelf);
    [UIView animateWithDuration:1.0 animations:^{
        [weakSelf.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        isTop = !isTop;
        
        if (!weakSelf.isStopAnimation) {
            [weakSelf doAnimation];
        }
        
    }];
    
}

- (void)restart {
    NSLog(@"%s", __func__);
    
    _input = nil;
    _output = nil;
    _device = nil;
    _session = nil;
    
    self.isStopAnimation = NO;
    
    // 区分第一次进入是因为, 第一次vc.view 刚布局好又 layoutIfNeed 回造成一个
    // 从右上角飞入的动画
    if (self.isViewWillAppear) {
        self.isViewWillAppear = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self doAnimation];
        });
    } else {
        [self doAnimation];
    }
    
    [self setupCamera];
}

- (void)stopCamera {
    [_session stopRunning];
    _session = nil;
    
    _input = nil;
    _output = nil;
    _device = nil;
    
    [_preview removeFromSuperlayer];
    _preview = nil;
}

- (void)setupCamera {
    
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    _input = [AVCaptureDeviceInput deviceInputWithDevice:_device error:nil];
    _output = [AVCaptureMetadataOutput new];
    
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // session
    _session = [AVCaptureSession new];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([_session canAddInput:_input]) {
        [_session addInput:_input];
    }
    
    if ([_session canAddOutput:_output]) {
        [_session addOutput:_output];
    }
    
    // 条码类型 AVMetadataObjectTypeQRCode
    NSArray *array = @[
                      AVMetadataObjectTypeUPCECode
                      , AVMetadataObjectTypeCode39Code
                      , AVMetadataObjectTypeCode39Mod43Code
                      , AVMetadataObjectTypeEAN13Code
                      , AVMetadataObjectTypeEAN8Code
                      , AVMetadataObjectTypeCode93Code
                      , AVMetadataObjectTypeCode128Code
                      , AVMetadataObjectTypePDF417Code
                      // this
                      , AVMetadataObjectTypeQRCode
                      ];
    
    
    NSArray * availableArray = _output.availableMetadataObjectTypes;
    NSMutableArray * mutaArray = [NSMutableArray array];
    for (id type in array) {
        if ([availableArray containsObject:type]) {
            [mutaArray addObject:type];
        }
    }
    _output.metadataObjectTypes = mutaArray;
    
    // Preview
    [_preview removeFromSuperlayer];
    _preview = nil;
    
    _preview =[AVCaptureVideoPreviewLayer layerWithSession:self.session];
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _preview.frame =CGRectMake(0, 0, self.view.yos_width,self.view.yos_height);
    
    [self.view.layer insertSublayer:_preview atIndex:0];
    
    // Start
    [_session startRunning];
}

- (void)dealWithResult {
    NSLog(@"%s", __func__);
    
    NSString *decode = [AES128 AES128Decrypt:self.resultString withKey:YOSAESKey];
    
    if (!decode) {
        [self showAlertWithMessage:[NSString stringWithFormat:@"这个不是活动二维码哦:\r\n%@", self.resultString]];
    } else {
        
        NSArray *array = [decode componentsSeparatedByString:@"-"];
        
        if (array.count != 2) {
            [self showAlertWithMessage:[NSString stringWithFormat:@"这个不是活动二维码哦:\r\n%@", self.resultString]];
            return;
        }
        
        NSString *uid = array[0];
        NSString *aid = array[1];
        
        [self sendNetworkRequestWithUid:uid aid:aid];
    }
    
    
}

- (void)showAlertWithMessage:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    
    [alert show];
}



@end
