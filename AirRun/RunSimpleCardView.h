//
//  RunSimpleCardView.h
//  AirRun
//
//  Created by jasonWu on 4/2/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^retractButtonBlock)(UIButton *button);

@interface RunSimpleCardView : UIView

@property (copy, nonatomic) retractButtonBlock retractButtonBlock;

@property (assign, nonatomic) NSInteger time;
@property (assign, nonatomic) CGFloat distance;
@property (assign, nonatomic) CGFloat speed;

@end
