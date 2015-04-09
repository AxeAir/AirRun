//
//  CompleteDisplayCard.h
//  AirRun
//
//  Created by ChenHao on 4/1/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseCardView.h"

@class MKMapSnapshot;
@class MapViewDelegate;

typedef NS_ENUM(NSInteger, CompleteDisplayCardButtonType) {
        CompleteDisplayCardButtonTypeShare
};

@protocol CompleteDisplayCardDelegate;

@interface CompleteDisplayCard : BaseCardView
@property (nonatomic, strong) MapViewDelegate *mapDelegate;
@property (nonatomic, weak) id<CompleteDisplayCardDelegate> delegate;
- (void)adjust:(NSString *)heart;
- (void)mapViewShotWithComplete:(void(^)(MKMapSnapshot *snapshot))completeBlock;

@end


@protocol CompleteDisplayCardDelegate <NSObject>
- (void)completeDisplayCard:(CompleteDisplayCard *)card didSelectButton:(CompleteDisplayCardButtonType)type;
- (void)completeDisplayCard:(CompleteDisplayCard *)card FoucsButtouTouch:(UIButton *)button;

@end