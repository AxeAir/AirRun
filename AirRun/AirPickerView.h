//
//  AirPickerView.h
//  AirRun
//
//  Created by ChenHao on 4/5/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^selectComplete)(NSInteger index,NSString *string);

@interface AirPickerView : UIView


- (instancetype)initWithFrame:(CGRect)frame dataSource:(NSArray *)dataSource;


- (void)showInView:(UIView *)superview completeBlock:(selectComplete)block;

- (void)dismiss;


@end
