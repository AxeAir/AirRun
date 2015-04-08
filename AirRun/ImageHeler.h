//
//  ImageHeler.h
//  AirRun
//
//  Created by ChenHao on 4/3/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <UIKit/UIKit.h>


@interface ImageHeler : NSObject

+ (UIImage *)fullResolutionImageFromALAsset:(ALAsset *)asset;

/**
 *@param image 压缩图片是原来的1/4
 */
+ (NSData *)compressImage:(UIImage *)image;

/**
 *@param 把图片缩小到新的大小
 */
+ (UIImage *)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;

@end
