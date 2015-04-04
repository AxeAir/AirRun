//
//  CompleteDisplayCard.h
//  AirRun
//
//  Created by ChenHao on 4/1/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseCardView.h"

@class MapViewDelegate;
@interface CompleteDisplayCard : BaseCardView

@property (nonatomic, strong) MapViewDelegate *mapDelegate;

- (void)adjust:(NSString *)heart;


@end
