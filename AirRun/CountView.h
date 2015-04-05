//
//  CountView.h
//  AirRun
//
//  Created by jasonWu on 4/5/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CountView;
typedef void(^completeBlock)(CountView *countView);

@interface CountView : UIView

- (instancetype)initWithCount:(NSInteger)count;
- (void)startCountWithCompleteBlock:(completeBlock)block;

@end
