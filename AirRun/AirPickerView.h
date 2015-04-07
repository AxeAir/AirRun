//
//  AirPickerView.h
//  AirRun
//
//  Created by ChenHao on 4/5/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^selectComplete)(NSInteger index,NSString *string);

typedef void (^selectDateComplete)(NSDate *date);

@interface AirPickerView : UIView


- (instancetype)initWithFrame:(CGRect)frame dataSource:(NSArray *)dataSource;

- (instancetype)initWithDatePickerFrames:(CGRect)frame date:(NSDate *)date;

- (void)showInView:(UIView *)superview completeBlock:(selectComplete)block;

- (void)showDateInView:(UIView *)superview completeBlock:(selectDateComplete)block;
- (void)dismiss;


@end
