//
//  ImageHeler.m
//  AirRun
//
//  Created by ChenHao on 4/3/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import "ImageHeler.h"
#import <AVOSCloud.h>
#import <UIImageView+AFNetworking.h>
#import <GPUImage.h>


@implementation ImageHeler

+ (UIImage *)fullResolutionImageFromALAsset:(ALAsset *)asset
{
    ALAssetRepresentation *assetRep = [asset defaultRepresentation];
    CGImageRef imgRef = [assetRep fullResolutionImage];
    UIImage *img = [UIImage imageWithCGImage:imgRef
                                       scale:assetRep.scale
                                 orientation:(UIImageOrientation)assetRep.orientation];
    return img;
}

+ (UIImage *)compressImage:(UIImage *)image {
    CGSize imagesize=image.size;
    
    while (true) {
        if(imagesize.width>800)
        {
            imagesize.width=imagesize.width/2;
            imagesize.height=imagesize.height/2;
        }
        else
        {
            break;
        }
    }
    while (true) {
        if(imagesize.height>1100)
        {
            imagesize.width=imagesize.width/2;
            imagesize.height=imagesize.height/2;
        }
        else
        {
            break;
        }
    }
    
    image=[self imageWithImage:image scaledToSize:imagesize];
    return image;
    
}

+ (UIImage *)compressImage:(UIImage *)image LessThanKB:(NSInteger)kb {
    UIImage *newImage = image;
    NSInteger kbs = [self getImageMemerySize:image];
    while (kbs > kb) {
        newImage = [self compressImage:image];
        kbs = [self getImageMemerySize:newImage];
    }
    return newImage;
}

+ (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    // End the context
    UIGraphicsEndImageContext();
    // Return the new image.
    return newImage;
}

+ (CGFloat)getImageMemerySize:(UIImage *)image {
    size_t imageSize = CGImageGetBytesPerRow(image.CGImage) * CGImageGetHeight(image.CGImage);
    return imageSize/10240.0;
}


+ (void)configAvatar:(UIImageView *)imageview
{
    AVUser *currentuser = [AVUser currentUser];
    AVFile *avatarData = [currentuser objectForKey:@"avatar"];
    NSData *resumeData = [avatarData getData];
    
    if (resumeData !=nil) {
        [imageview setImage:[UIImage imageWithData:resumeData]];
    }
    else if([currentuser objectForKey:@"weiboavatar"]!=nil)
    {
        [imageview setImageWithURL:[NSURL URLWithString:[currentuser objectForKey:@"weiboavatar"]]];
    }
    else if([currentuser objectForKey:@"qqavatar"]!=nil){
        [imageview setImageWithURL:[NSURL URLWithString:[currentuser objectForKey:@"qqavatar"]]];
    }
    else{
        [imageview setImage:[UIImage imageNamed:@"defaultavatar"]];
    }
    
}

+ (void)configAvatarBackground:(UIImageView *)imageview
{
    AVUser *currentuser = [AVUser currentUser];
    AVFile *avatarData = [currentuser objectForKey:@"avatar"];
    NSData *resumeData = [avatarData getData];
    
    if (resumeData !=nil) {
        [imageview setImage:[self blurImage:[UIImage imageWithData:resumeData]]];
    }
    else if([currentuser objectForKey:@"weiboavatar"]!=nil)
    {
        NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:[currentuser objectForKey:@"weiboavatar"]]
                                                  cachePolicy:NSURLRequestUseProtocolCachePolicy
                                              timeoutInterval:60.0];
        __block UIImageView *imageviewblock = imageview;
        [imageview setImageWithURLRequest:theRequest placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            [imageviewblock setImage:[self blurImage:image]];
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            
        }];
    }
    else if([currentuser objectForKey:@"qqavatar"]!=nil){
        NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:[currentuser objectForKey:@"qqavatar"]]
                                                  cachePolicy:NSURLRequestUseProtocolCachePolicy
                                              timeoutInterval:60.0];
        __block UIImageView *imageviewblock = imageview;
        [imageview setImageWithURLRequest:theRequest placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            [imageviewblock setImage:[self blurImage:image]];
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            
        }];
    }
    else{
        [imageview setImage:[self blurImage:[UIImage imageNamed:@"defaultTimeline"]]];
    }
    
    
}

+ (UIImage *)blurImage:(UIImage *)image
{
    GPUImagePicture *stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
    GPUImageiOSBlurFilter *stillImageFilter = [[GPUImageiOSBlurFilter alloc] init];
    [stillImageFilter setBlurRadiusInPixels:4];
    [stillImageSource addTarget:stillImageFilter];
    [stillImageFilter useNextFrameForImageCapture];
    [stillImageSource processImage];
    return [stillImageFilter imageFromCurrentFramebuffer];
    
}

+ (UIImage *)convertViewToImage:(UIView*)v{
    CGSize s = v.bounds.size;
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
    UIGraphicsBeginImageContextWithOptions(s, NO, [UIScreen mainScreen].scale);
    [v.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
