//
//  TNewsCell.m
//  TGod
//
//  Created by yangyang on 15/2/27.
//  Copyright (c) 2015年 LaShou. All rights reserved.
//

#import "YOSCollectionImageCell.h"

#import "UIView+YOSAdditions.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "Masonry.h"

NSString * const kCollectionImageDefaultImage = @"首页默认图";

@interface YOSCollectionImageCell()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation YOSCollectionImageCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setupSubviews];
    }
    
    return self;
}

- (void)setupSubviews {
    
    _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kCollectionImageDefaultImage]];
    _imageView.userInteractionEnabled = YES;
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    [_imageView sizeToFit];
    
    [self.contentView addSubview:_imageView];
    
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self);
        make.top.and.left.mas_equalTo(0);
    }];

}

- (void)setImageUrl:(NSString *)imageUrl {
    _imageUrl = imageUrl;
    
    [self setupImageView];
}

- (void)setupImageView {
    [_imageView setImageWithURL:[NSURL URLWithString:_imageUrl] placeholderImage:[UIImage imageNamed:kCollectionImageDefaultImage] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
}

- (void)clickImageBtn {
    NSLog(@"%s", __func__);
    
}

@end
