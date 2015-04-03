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

@end
