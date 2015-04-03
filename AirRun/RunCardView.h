//
//  RunCardView.h
//  Run
//
//  Created by jasonWu on 4/1/15.
//  Copyright (c) 2015 jasonWu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^retractButtonTouch)(UIButton * button);
typedef void(^photoButtonTouch)(UIButton *button);

@interface RunCardView : UIView

@property (copy, nonatomic) retractButtonTouch retractTouchBlock;
@property (copy, nonatomic) photoButtonTouch photoTouchBlock;

@property (assign, nonatomic) CGFloat distance;
@property (assign, nonatomic) NSInteger time;
@property (assign, nonatomic) CGFloat speed;
@property (assign, nonatomic) CGFloat currentSpeed;
@property (assign, nonatomic) CGFloat kcal;
@property (assign, nonatomic) CGFloat gps;

@end
