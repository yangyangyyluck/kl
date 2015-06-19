//
//  YOSHomeCell.m
//  kuailai
//
//  Created by yangyang on 15/6/2.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSHomeCell.h"
#import "YOSHeadButton.h"
#import "YOSActivityListModel.h"

#import "EDColor.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "UIButton+WebCache.h"
#import "UIImage+YOSAdditions.h"
#import "UIImage-Helpers.h"
#import "Masonry.h"
#import "YOSWidget.h"

NSString * const kHomeCellDefaultImage = @"首页默认图";

@interface YOSHomeCell ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewWidthConstraint;

@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (weak, nonatomic) IBOutlet UIImageView *topImageView;

@property (weak, nonatomic) IBOutlet UIImageView *topRightImageView;

@property (weak, nonatomic) IBOutlet UIImageView *messageImageView;

@property (weak, nonatomic) IBOutlet YOSHeadButton *headButton;

@property (weak, nonatomic) IBOutlet UILabel *label0;

@property (weak, nonatomic) IBOutlet UILabel *label1;

@property (nonatomic, strong) UIImageView *poisitionImageView;

@property (nonatomic, strong) UIImageView *timeImageView;

@property (nonatomic, strong) UILabel *messageLabel0;

@property (nonatomic, strong) UILabel *messageLabel1;

@end

@implementation YOSHomeCell

- (void)awakeFromNib {
    
    self.topImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    self.label0.font = [UIFont boldSystemFontOfSize:15.0f];
    self.label0.textColor = YOSColorFontBlack;
    
    self.label1.textColor = YOSColorFontGray;
    
    self.poisitionImageView = [UIImageView new];
    self.poisitionImageView.image = [UIImage imageNamed:@"活动地点"];
    [self.poisitionImageView sizeToFit];
    
    self.timeImageView = [UIImageView new];
    self.timeImageView.image = [UIImage imageNamed:@"活动时间"];
    [self.timeImageView sizeToFit];
    
    [self.messageImageView addSubview:self.poisitionImageView];
    [self.messageImageView addSubview:self.timeImageView];
    
    self.messageLabel0 = [UILabel new];
    self.messageLabel1 = [UILabel new];
    self.messageLabel0.font = [UIFont systemFontOfSize:10.0f];
    self.messageLabel1.font = [UIFont systemFontOfSize:10.0f];
    self.messageLabel0.textColor = [UIColor whiteColor];
    self.messageLabel1.textColor = [UIColor whiteColor];
    
    [self.messageImageView addSubview:self.messageLabel0];
    [self.messageImageView addSubview:self.messageLabel1];
    
    self.messageImageView.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.15f];
    
    self.containerView.layer.cornerRadius = 5.0f;
    self.containerView.layer.masksToBounds = YES;
    self.contentView.backgroundColor = YOSColorBackgroundGray;
    
    self.containerViewWidthConstraint.constant = YOSScreenWidth - 20;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - getter & setter

- (void)setModel:(YOSActivityListModel *)model {
    _model = model;

//    UIImage *image = [UIImage yos_imageWithColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.15f] size:CGSizeMake(YOSScreenWidth - 20, 20)];
//    self.messageImageView.image = image;
    
    if (_model.thumb) {
        NSURL *url = [NSURL URLWithString:_model.thumb];
        
        YOSWSelf(weakSelf);
        [self.topImageView setImageWithURL:url placeholderImage:[UIImage imageNamed:kHomeCellDefaultImage] options:SDWebImageLowPriority completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {

            if (!error) {
                [weakSelf showMessageWithGaussianImage];
            } else {
                self.messageImageView.image = nil;
            }
            
        } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        
    } else {
        self.topImageView.image = [UIImage imageNamed:kHomeCellDefaultImage];
    }
    
    [self.headButton setTitle:_model.username forState:UIControlStateNormal];
    
    if (_model.avatar && ![_model.avatar isEqualToString:@""]) {
        NSURL *url = [NSURL URLWithString:_model.avatar];
        
        [self.headButton sd_setImageWithURL:url forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"默认头像"]];
    } else {
        [self.headButton setImage:[UIImage imageNamed:@"默认头像"] forState:UIControlStateNormal];
    }
    
    self.headButton.titleLabel.font = [UIFont systemFontOfSize:10.0f];
    self.headButton.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.headButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.headButton setTitleColor:YOSColorFontGray forState:UIControlStateNormal];
    
    self.label0.text = _model.title;
    self.label1.text = [NSString stringWithFormat:@"类别：%@", _model.typeName];
    
    self.messageLabel0.text = [NSString stringWithFormat:@"%@%@", _model.cityName, YOSFliterNil2String(_model.areaName)];
    self.messageLabel1.text = [YOSWidget dateStringWithTimeStamp:_model.start_time Format:@"YYYY-MM-dd EEEE HH:mm:ss"];
    
    MASAttachKeys(self.poisitionImageView, self.messageLabel0, self.messageLabel1, self.topImageView, self.messageImageView, self.headButton);
    
    [self.poisitionImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.removeExisting = YES;
        
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(2.5);
        make.centerY.mas_equalTo(self.messageImageView);
    }];
    
    [self.messageLabel0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.removeExisting = YES;
        
        make.left.mas_equalTo(self.poisitionImageView.mas_right).offset(4);
        make.centerY.mas_equalTo(self.poisitionImageView);
    }];
    
    [self.timeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.removeExisting = YES;
        
        make.left.mas_equalTo(self.messageLabel0.mas_right).offset(10);
        make.centerY.mas_equalTo(self.poisitionImageView);
    }];
    
    [self.messageLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.removeExisting = YES;
        
        make.left.mas_equalTo(self.timeImageView.mas_right).offset(4);
        make.centerY.mas_equalTo(self.poisitionImageView);
    }];
    
    [self.messageImageView setNeedsUpdateConstraints];
    [self.messageImageView layoutIfNeeded];
    
}

#pragma mark - private methods

- (void)showMessageWithGaussianImage {
    UIImage *cutImage = [UIImage yos_imageCutWithView:self.topImageView atRect:CGRectMake(0, 105 - 20, YOSScreenWidth - 20, 20)];
    
    CGFloat quality = 0.001f;
    CGFloat blurred = .9f;
    NSData *imageData = UIImageJPEGRepresentation(cutImage, quality);
    UIImage *blurredImage = [[UIImage imageWithData:imageData] blurredImage:blurred];

//TODO
    self.messageImageView.image = blurredImage;
}

@end
