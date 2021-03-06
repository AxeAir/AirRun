//
//  CompleteDisplayCard.h
//  AirRun
//
//  Created by ChenHao on 4/1/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseCardView.h"
#import "RunningRecordEntity.h"

@class MKMapSnapshot;
@class MapViewDelegate;

typedef NS_ENUM(NSInteger, CompleteDisplayCardButtonType) {
    CompleteDisplayCardButtonTypeShare,
    CompleteDisplayCardButtonTypeComplete
};

@protocol CompleteDisplayCardDelegate;

@class MKMapView;
@interface CompleteDisplayCard : BaseCardView

@property (nonatomic, strong) MKMapView *mapView;

@property (nonatomic, weak) id<CompleteDisplayCardDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame withEntity:(RunningRecordEntity *)entity;

- (void)adjust:(NSString *)heart;

- (void)changeToshareModel;

- (void)changeToNormalModel;
@end


@protocol CompleteDisplayCardDelegate <NSObject>
- (void)completeDisplayCard:(CompleteDisplayCard *)card didSelectButton:(CompleteDisplayCardButtonType)type;
- (void)completeDisplayCard:(CompleteDisplayCard *)card FoucsButtouTouch:(UIButton *)button;
- (void)completeDisplayCardaddImageAnnotation:(CompleteDisplayCard *)card;
- (void)completeDisplayCard:(CompleteDisplayCard *)card imageButtouTouch:(UIButton *)button;
@end