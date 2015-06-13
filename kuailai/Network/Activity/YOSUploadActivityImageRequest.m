//
//  YOSUploadActivityImageRequest.m
//  kuailai
//
//  Created by yangyang on 15/6/2.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSUploadActivityImageRequest.h"

@implementation YOSUploadActivityImageRequest {
    UIImage *_image;
}

- (instancetype)initWithImage:(UIImage *)aImage {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _image = aImage;
    
    return self;
}

- (NSString *)requestUrl {
    return @"active/upImg";
}

- (AFConstructingBlock)constructingBodyBlock {
    return ^(id<AFMultipartFormData> formData) {
        NSData *data = UIImageJPEGRepresentation(_image, 0.8);
        NSString *name = @"img.jpg";
        NSString *formKey = @"img";
        NSString *type = @"image/jpeg";
        [formData appendPartWithFileData:data name:formKey fileName:name mimeType:type];
    };
}

@end
