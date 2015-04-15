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
+ (UIImage *)compressImage:(UIImage *)image;

/**
 *@param 把图片缩小到新的大小
 */
+ (UIImage *)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;

/**
 *  得到图片的内存大小
 *
 *  @param image 图片
 *
 *  @return 图片内存大小KB单位
 */
+ (CGFloat)getImageMemerySize:(UIImage *)image;


+ (UIImage *)compressImage:(UIImage *)image LessThanKB:(NSInteger)kb;


+ (void)configAvatar:(UIImageView *)imageview;

+ (void)configAvatarBackground:(UIImageView *)imageview;

+ (UIImage *)convertViewToImage:(UIView*)v;
@end
