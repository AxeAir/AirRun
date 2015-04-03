//
//  ImageViewer.h
//  AirRun
//
//  Created by ChenHao on 4/3/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void (^completeBlock)(NSMutableArray *array);

@interface ImageViewer : UIView

@property (nonatomic, assign) CGRect startframe;

- (void)show;

- (void)showWithCompleteArray:(completeBlock)block;

- (instancetype)initWithArray:(NSArray *)array WithSuperView:(UIView*)superview;





@end
