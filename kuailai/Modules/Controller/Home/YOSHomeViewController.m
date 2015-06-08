//
//  YOSHomeViewController.m
//  kuailai
//
//  Created by yangyang on 15/4/8.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSHomeViewController.h"
#import "YOSRegisterViewController.h"
#import "YOSEditViewController.h"
#import "YOSInputView.h"
#import "YOSTextField.h"
#import "YOSHomeCell.h"
#import "YOSTextView.h"

#import "YOSUserSendCodeRequest.h"
#import "YOSGetActiveListRequest.h"
#import "YOSUserLoginRequest.h"

#import "YOSUserInfoModel.h"
#import "YOSActivityListModel.h"

#import "YOSWidget.h"
#import "Masonry.h"
#import "IQKeyboardManager.h"
#import "YOSDBManager.h"
#import "XXNibConvention.h"

#import "IQUIView+IQKeyboardToolbar.h"
#import "UIImage+YOSAdditions.h"
#import "UIImage-Helpers.h"

@interface YOSHomeViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *activityListModels;

/** 总数据量 */
@property (nonatomic, assign) NSUInteger count;

/** 总页数 */
@property (nonatomic, assign) NSUInteger totalPage;

/** 当前页数量 */
@property (nonatomic, assign) NSUInteger currentPage;

@end

@implementation YOSHomeViewController {
    YOSTextView *_textView;
    UITableView *_tableView;
}

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubviews];
    
    [self setupRightButtonWithTitle:@"right"];
    
    self.currentPage = 0;
    
//    UIImageView *iv = [UIImageView new];
//    iv.frame = CGRectMake(10, 100, 300, 215);
//    iv.image = [UIImage imageNamed:@"test"];
//    
//    UIImage *image = [UIImage yos_imageCutWithView:iv atRect:CGRectMake(0, 195, 300, 20)];
//    
//    float quality = 0.001f;
//    // intensity of blurred
//    float blurred = .5f;
//    NSData *imageData = UIImageJPEGRepresentation(image, quality);
//    UIImage *blurredImage = [[UIImage imageWithData:imageData] blurredImage:blurred];
//    
////    UIImage *topImage = [UIImage imageWithCGImage:CGImageCreateWithImageInRect(blurredImage.CGImage, CGRectMake(0, 0, blurredImage.size.width * blurredImage.scale, 20 * blurredImage.scale))];
//    
//    [self.view addSubview:iv];
//    
//    UIImageView *iv2 = [UIImageView new];
//    iv2.image = blurredImage;
//    iv2.frame = CGRectMake(10, 295, 300, 20);
//    [self.view addSubview:iv2];
//    
//    /*
//    GPUImageGaussianBlurFilter * blurFilter = [[GPUImageGaussianBlurFilter alloc] init];
//    blurFilter.blurRadiusInPixels = 3.0;
//    UIImage *img = [UIImage yos_imageWithColor:[UIColor greenColor] size:CGSizeMake(300, 20)];
//    UIImage *blurredImage = [blurFilter imageByFilteringImage:img];
//    
//    UIImage *image = [UIImage imageNamed:@"test"];
//    
//    GPUImageGaussianBlurPositionFilter *gaussianFilter = [GPUImageGaussianBlurPositionFilter new];
//    gaussianFilter.blurCenter = CGPointMake(10, 150);
//    gaussianFilter.blurRadius = 10;
//    gaussianFilter.blurSize = 0.5;
//    
//    UIImage *img2 = [gaussianFilter imageByFilteringImage:image];
//    
//    iv.image = img2;
//    
//    UIImageView *iv2 = [UIImageView new];
//    iv2.frame = CGRectMake(0, 0, 300, 20);
//    iv2.image = blurredImage;
//    iv2.backgroundColor = YOSColorRandom;
//    
//    [self.view addSubview:iv];
////    [iv addSubview:iv2];
//     */
}

- (void)setupSubviews {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 100, 100) style:UITableViewStyleGrouped];
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 170.0f;
    
    [self.view addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero).priorityLow();
    }];
}

#pragma mark - event response

- (void)clickRightItem:(UIButton *)item {
    NSLog(@"%s", __func__);
    NSString *string = @"2";
    
    if ([string isEqualToString:@"1"]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController pushViewController:[YOSRegisterViewController viewControllerFromStoryboardWithSBName:@"Register"] animated:YES];
        });
    }
    
    if ([string isEqualToString:@"2"]) {
        YOSGetActiveListRequest *request = [[YOSGetActiveListRequest alloc] initWithCity:YOSCityTypeBJ page:(self.currentPage + 1) start_time:0 type:0];
        
        [request startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
            if ([request yos_checkResponse]) {
                YOSLog(@"log : %@", [request.yos_data description]);
                
//                self.activityListModels = [YOSActivityListModel arrayOfModelsFromDictionaries:request.yos_data[@"data"]];
                
                self.currentPage++;
                
                self.totalPage = ((NSString *)request.yos_data[@"total_page"]).integerValue;
                
                self.count = ((NSString *)request.yos_data[@"count"]).integerValue;
                
                NSLog(@"activity list : %@", self.activityListModels);
                
                [_tableView reloadData];
            }
        } failure:^(YTKBaseRequest *request) {
            [request yos_checkResponse];
        }];
    }
    
    if ([string isEqualToString:@"3"]) {
        YOSUserLoginRequest *request = [[YOSUserLoginRequest alloc] initWithUserName:@"18600950783" pwd:@"123123" models:[[UIDevice currentDevice] model]];
        
        [request startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
            if ([request yos_checkResponse]) {
                
                [YOSWidget setUserDefaultWithKey:YOSUserDefaultKeyCurrentUserInfoDictionary value:request.yos_data];
                
                YOSUserInfoModel *model = [[YOSUserInfoModel alloc] initWithDictionary:request.yos_data error:nil];
                
                if (model.ID) {
                    [YOSWidget setUserDefaultWithKey:YOSUserDefaultKeyCurrentLoginID value:model.ID];
                    YOSLog(@"\r\n\r\n had set LoginID");
                }
                
                if (model.username) {
                    [YOSWidget setUserDefaultWithKey:YOSUserDefaultKeyCurrentLoginMobileNumber value:model.username];
                    YOSLog(@"\r\n\r\n had set LoginMobile");
                }
                
            }
        } failure:^(YTKBaseRequest *request) {
            [request yos_checkResponse];
        }];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"%s", __func__);
    NSString *string = @"2";
    
    if ([string isEqualToString:@"1"]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController pushViewController:[YOSRegisterViewController viewControllerFromStoryboardWithSBName:@"Register"] animated:YES];
        });
    }
    
    if ([string isEqualToString:@"2"]) {
        YOSGetActiveListRequest *request = [[YOSGetActiveListRequest alloc] initWithCity:YOSCityTypeBJ page:0 start_time:0 type:0];
        
        [request startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
            if ([request yos_checkResponse]) {
                self.activityListModels = [YOSActivityListModel arrayOfModelsFromDictionaries:request.yos_data];
                
                NSLog(@"activity list : %@", self.activityListModels);
                
                [_tableView reloadData];
            }
        } failure:^(YTKBaseRequest *request) {
            [request yos_checkResponse];
        }];
    }
    
    if ([string isEqualToString:@"3"]) {
        YOSUserLoginRequest *request = [[YOSUserLoginRequest alloc] initWithUserName:@"18600950783" pwd:@"123123" models:[[UIDevice currentDevice] model]];
        
        [request startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
            if ([request yos_checkResponse]) {
                
                [YOSWidget setUserDefaultWithKey:YOSUserDefaultKeyCurrentUserInfoDictionary value:request.yos_data];
                
                YOSUserInfoModel *model = [[YOSUserInfoModel alloc] initWithDictionary:request.yos_data error:nil];
                
                if (model.ID) {
                    [YOSWidget setUserDefaultWithKey:YOSUserDefaultKeyCurrentLoginID value:model.ID];
                    YOSLog(@"\r\n\r\n had set LoginID");
                }
                
                if (model.username) {
                    [YOSWidget setUserDefaultWithKey:YOSUserDefaultKeyCurrentLoginMobileNumber value:model.username];
                    YOSLog(@"\r\n\r\n had set LoginMobile");
                }
                
            }
        } failure:^(YTKBaseRequest *request) {
            [request yos_checkResponse];
        }];
    }
    
}

#pragma mark - network


#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.activityListModels.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YOSHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YOSHomeCell class])];
    
    if (!cell) {
        cell = [YOSHomeCell xx_instantiateFromNib];
    }
    
    cell.model = self.activityListModels[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 10.0f;
    } else {
        return 5.0f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == (self.activityListModels.count - 1)) {
        return 10.0f;
    } else {
        return 5.0f;
    }
}


#pragma mark - getter & setter

- (NSMutableArray *)activityListModels {
    if (!_activityListModels) {
        _activityListModels = [NSMutableArray array];
    }
    
    return _activityListModels;
}

@end
