//
//  GuideView.h
//  AirRun
//
//  Created by JasonWu on 4/8/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GuideView;

typedef void(^closeBlock)(GuideView *guideView);

@interface GuideView : UIView

@property (strong, nonatomic) UIImage *image;

@property (copy, nonatomic) closeBlock closeBlock;

@end
