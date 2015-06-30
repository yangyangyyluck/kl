//
//  YOSUserUpPhotoRequest.m
//  kuailai
//
//  Created by yangyang on 15/6/29.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSUserUpPhotoRequest.h"

@implementation YOSUserUpPhotoRequest {
    UIImage *_image;
    NSString *_uid;
}

- (instancetype)initWithImage:(UIImage *)aImage uid:(NSString *)uid {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _image = aImage;
    _uid = YOSFliterNil2String(uid);
    
    return self;
}

- (NSString *)requestUrl {
    return @"user/upPhoto";
}

- (id)requestArgument {
    return @{@"uid" : _uid};
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
