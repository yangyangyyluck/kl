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
#import "UIImage+YOSAdditions.h"
#import "UIImage-Helpers.h"

NSString * const kHomeCellDefaultImage = @"首页默认图";

@interface YOSHomeCell ()

@property (weak, nonatomic) IBOutlet UIImageView *topImageView;

@property (weak, nonatomic) IBOutlet UIImageView *topRightImageView;

@property (weak, nonatomic) IBOutlet UIImageView *messageImageView;

@property (weak, nonatomic) IBOutlet YOSHeadButton *headButton;

@property (weak, nonatomic) IBOutlet UILabel *label0;

@property (weak, nonatomic) IBOutlet UILabel *label1;

@end

@implementation YOSHomeCell

- (void)awakeFromNib {
    
    self.label0.font = [UIFont boldSystemFontOfSize:15.0f];
    self.label0.textColor = YOSColorFontBlack;
    
    self.label1.textColor = YOSColorFontGray;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - getter & setter

- (void)setModel:(YOSActivityListModel *)model {
    _model = model;
    
    if (_model.thumb) {
        NSURL *url = [NSURL URLWithString:_model.thumb];
        
        YOSWSelf(weakSelf);
        [self.topImageView setImageWithURL:url placeholderImage:[UIImage imageNamed:kHomeCellDefaultImage] options:SDWebImageLowPriority completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            [weakSelf showMessageWithGaussianImage];
            
        } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        
    } else {
        self.topImageView.image = [UIImage imageNamed:kHomeCellDefaultImage];
    }
    
    UIImage *image = [UIImage yos_imageWithColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.15f] size:CGSizeMake(YOSScreenWidth - 20, 20)];
    self.messageImageView.image = image;
    [self.headButton setTitle:@"光头强" forState:UIControlStateNormal];
    [self.headButton setImage:[UIImage imageNamed:@"产品分享"] forState:UIControlStateNormal];
    
    self.label0.text = _model.title;
    self.label1.text = @"类别：黑马创业";
}

#pragma mark - private methods

- (void)showMessageWithGaussianImage {
    UIImage *cutImage = [UIImage yos_imageCutWithView:self.topImageView atRect:CGRectMake(0, 105 - 20, YOSScreenWidth - 20, 20)];
    
    CGFloat quality = 0.001f;
    CGFloat blurred = .5f;
    NSData *imageData = UIImageJPEGRepresentation(cutImage, quality);
    UIImage *blurredImage = [[UIImage imageWithData:imageData] blurredImage:blurred];

    self.messageImageView.image = blurredImage;
}

@end
