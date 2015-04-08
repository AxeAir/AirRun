//
//  ImageHeler.m
//  AirRun
//
//  Created by ChenHao on 4/3/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import "ImageHeler.h"



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

+ (NSData *)compressImage:(UIImage *)image {
    CGSize imagesize=image.size;
    
    while (true) {
        if(imagesize.width>800)
        {
            imagesize.width=imagesize.width/4;
            imagesize.height=imagesize.height/4;
        }
        else
        {
            break;
        }
    }
    while (true) {
        if(imagesize.height>1100)
        {
            imagesize.width=imagesize.width/4;
            imagesize.height=imagesize.height/4;
        }
        else
        {
            break;
        }
    }
    
    image=[self imageWithImage:image scaledToSize:imagesize];
    
    NSData *data;
    data = UIImageJPEGRepresentation(image, 0.5);
    
    return data;
    
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
@end
