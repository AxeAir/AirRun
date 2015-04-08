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

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) UIImageView *topImage;
@property (strong, nonatomic) NSString *content;

@property (copy, nonatomic) closeBlock closeBlock;

@end
