//
//  PhotoViewer.h
//  AirRun
//
//  Created by ChenHao on 4/17/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PhotoViewerDataScorceType) {
    PhotoViewerDataScorceTypeURL,
    PhotoViewerDataScorceTypeImage,
};


@interface PhotoViewerController : UIViewController

- (instancetype)initWithURLArray:(NSArray *)paths AtIndex:(NSInteger)index;

- (instancetype)initWithImageArray:(NSArray *)paths AtIndex:(NSInteger)index;


@end
