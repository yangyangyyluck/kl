//
//  YOSActivityPhotoView.m
//  kuailai
//
//  Created by yangyang on 15/5/18.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSActivityPhotoView.h"
#import "EDColor.h"
#import "UIView+YOSAdditions.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "QBImagePickerController.h"
#import "YOSImageView.h"
#import "Masonry.h"

@interface YOSActivityPhotoView () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, QBImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) UIButton *button;

@property (nonatomic, strong, readwrite) NSMutableArray *photos;

@property (nonatomic, strong) NSMutableArray *photosView;

@end

@implementation YOSActivityPhotoView

#pragma mark - life cycle

- (void)awakeFromNib {
    NSString *text = @"上传活动图片(推荐上传横幅图片，最多4张)";
    
    NSMutableAttributedString *attributeText = [[NSMutableAttributedString alloc] initWithString:text];
    
    UIColor *blackColor = [UIColor colorWithHexString:@"#858585"];
    
    [attributeText setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.0f], NSForegroundColorAttributeName : blackColor} range:NSMakeRange(0, 6)];
    
    [attributeText setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.0f], NSForegroundColorAttributeName : YOSRGB(210, 210, 210)} range:NSMakeRange(6, text.length - 6)];
    
    self.titleLabel.attributedText = attributeText;
    
    self.button = [UIButton new];
    [self.button setBackgroundImage:[UIImage imageNamed:@"添加图片"] forState:UIControlStateNormal];
    [self.button addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.button];
    
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.bottom.mas_equalTo(-15);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
}

#pragma mark - event response

- (IBAction)clickBtn:(UIButton *)sender {
    NSLog(@"%s", __func__);
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        QBImagePickerController *pickerVC = [QBImagePickerController new];
        pickerVC.delegate = self;
        pickerVC.allowsMultipleSelection = YES;
        pickerVC.maximumNumberOfSelection = 4 - self.photos.count;
        
        [self.yos_viewController presentViewController:pickerVC animated:YES completion:nil];

        /*
        UIImagePickerController *pickerVC = [[UIImagePickerController alloc] init];
        pickerVC.delegate = self;
        pickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self.yos_viewController presentViewController:pickerVC animated:YES completion:nil];
         */
    }
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"%s", __func__);
    
//    [self saveImage:self.photos[0] withName:@"abc.jpeg"];

}

#pragma mark - private methods

- (UIButton *)createButton {
    UIButton *btn = [UIButton new];
    [btn setBackgroundImage:[UIImage imageNamed:@"创建图片"] forState:UIControlStateNormal];
    
    [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

- (void)updatePhotos {
    
    [self.photosView enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromSuperview];
    }];
    
    [self.photosView removeAllObjects];
    
    [self.photos enumerateObjectsUsingBlock:^(UIImage *obj, NSUInteger idx, BOOL *stop) {
        YOSImageView *imageView = [YOSImageView new];
        imageView.image = obj;
        
        [self addSubview:imageView];
        
        [self.photosView addObject:imageView];
    }];
    
    CGFloat btnWidth = 70.0;
    CGFloat marginX = 10.0;
    CGFloat spaceX = (YOSScreenWidth - 4 * btnWidth - marginX * 2) / 3;
    YOSWSelf(weakSelf);
    [self.photosView enumerateObjectsUsingBlock:^(YOSImageView *obj, NSUInteger idx, BOOL *stop) {
//        obj.backgroundColor = YOSColorRandom;
        [obj setDeleteBlock:^{
            [weakSelf.photos removeObject:weakSelf.photos[idx]];
            [weakSelf updatePhotos];
        }];
        
        [obj mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(btnWidth, btnWidth));
            make.bottom.mas_equalTo(-15);
            make.left.mas_equalTo(marginX + idx * (btnWidth + spaceX));
        }];
        
    }];
    
    if (self.photosView.count == 4) {
        self.button.hidden = YES;
    } else {
        self.button.hidden = NO;
        
        [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.removeExisting = YES;
            
            CGFloat offset = weakSelf.photos.count * (btnWidth + spaceX) + marginX;
            make.size.mas_equalTo(CGSizeMake(60, 60));
            make.left.mas_equalTo(offset);
            make.bottom.mas_equalTo(-15);
        }];
    }
}

//保存图片至沙盒
- (void)saveImage:(UIImage *)currentImage withName:(NSString *)imageName
{

    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.5);
    // 获取沙盒目录
    
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    // 将图片写入文件
    
    [imageData writeToFile:fullPath atomically:NO];
}

#pragma mark - image picker delegte

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"%s", __func__);
    
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    /* 此处info 有六个值
     * UIImagePickerControllerMediaType; // an NSString UTTypeImage)
     * UIImagePickerControllerOriginalImage;  // a UIImage 原始图片
     * UIImagePickerControllerEditedImage;    // a UIImage 裁剪后图片
     * UIImagePickerControllerCropRect;       // an NSValue (CGRect)
     * UIImagePickerControllerMediaURL;       // an NSURL
     * UIImagePickerControllerReferenceURL    // an NSURL that references an asset in the AssetsLibrary framework
     * UIImagePickerControllerMediaMetadata    // an NSDictionary containing metadata from a captured photo
     */
    // 保存图片至本地，方法见下文
    [self saveImage:image withName:@"currentImage.png"];
    
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"currentImage.png"];
    
    UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:fullPath];
     
    
    [self.button setImage:savedImage forState:0];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    NSLog(@"%s", __func__);
    [self.yos_viewController dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark - QBImagePickerControllerDelegate

- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didSelectAssets:(NSArray *)assets {
    NSLog(@"QBImagePickerController : %@", assets);
    
    [assets enumerateObjectsUsingBlock:^(ALAsset *obj, NSUInteger idx, BOOL *stop) {
        UIImage *image = [UIImage imageWithCGImage:[[obj defaultRepresentation] fullScreenImage]];
        
        [self.photos addObject:image];
        
    }];
    
    [self updatePhotos];
    
    [self.yos_viewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController {
    [self.yos_viewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - getter & setter

- (NSMutableArray *)photos {
    if (!_photos) {
        _photos = [NSMutableArray array];
    }
    
    return _photos;
}

- (NSMutableArray *)photosView {
    if (!_photosView) {
        _photosView = [NSMutableArray array];
    }
    
    return _photosView;
}

@end
