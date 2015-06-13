//
//  YOSActivityDetailItemView.m
//  kuailai
//
//  Created by yangyang on 15/6/11.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSActivityDetailItemView.h"
#import "Masonry.h"
#import "EDColor.h"

@interface YOSActivityDetailItemView ()

@property (nonatomic, assign, readwrite) CGFloat itemHeight;

@end

@implementation YOSActivityDetailItemView {
    NSString *_imageName;
    NSString *_title;
    
    UIImageView *_imageView;
    UILabel *_label;
    UIView *_bottomLineView;
}

- (instancetype)initWithImage:(NSString *)image title:(NSString *)title {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _imageName = image;
    _title = title;
    
    self.backgroundColor = [UIColor whiteColor];
    [self setupSubviews];
    
    return self;
}

- (void)setupSubviews {
    _imageView = [UIImageView new];
    _imageView.image = [UIImage imageNamed:_imageName];
    
    _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
    _label.font = YOSFontNormal;
    _label.textColor = YOSColorFontBlack;
    _label.numberOfLines = 0;
    
    [self addSubview:_imageView];
    [self addSubview:_label];
    
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(18, 18));
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(13);
    }];
    
    NSString *string = _title;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    
    NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
    
    style.lineSpacing = 5;
    style.lineBreakMode = NSLineBreakByWordWrapping;
    
    NSDictionary *attrs = @{
                            NSParagraphStyleAttributeName : style ,
                            NSFontAttributeName : [UIFont systemFontOfSize:14],
                            };
    
    [attributedString setAttributes:attrs range:NSMakeRange(0, string.length)];
    
    CGSize size = [string boundingRectWithSize:CGSizeMake(YOSScreenWidth - 10 - 18 - 10 - 10, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attrs context:nil].size;

    _label.attributedText = attributedString;
    _label.lineBreakMode = NSLineBreakByWordWrapping;
    
    [_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(ceil(size.height));
        make.width.mas_equalTo(YOSScreenWidth - 10 - 18 - 10 - 10);
        make.left.mas_equalTo(_imageView.mas_right).offset(10);
        make.top.mas_equalTo(13);
    }];
    
    _bottomLineView = [UIView new];
    _bottomLineView.backgroundColor = YOSColorLineGray;
    [self addSubview:_bottomLineView];
    
    [_bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.and.trailing.mas_equalTo(8);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    
//    NSLog(@"\r\n\r\nsize is %@\r\n\r\n size2 %@ --- %@\r\n width : %f", NSStringFromCGSize(size), @"", NSStringFromCGRect(_label.frame), YOSScreenWidth);
    
    CGFloat height = 13 + ceil(size.height) + 13;
    self.itemHeight = (height < 50.0) ? 44.0 : height;
}

#pragma mark - getter & setter 

- (void)setShowBottomLine:(BOOL)showBottomLine {
    _showBottomLine = showBottomLine;
    
    _bottomLineView.hidden = !showBottomLine;
}

@end
