//
//  PopInputView.h
//  AirRun
//
//  Created by ChenHao on 4/2/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^completeEdit)(NSString *string);

@interface PopInputView : UIView

- (instancetype)initWithSuperView:(UIView *)superview;

- (void)show;

- (void)showWithCompleteBlock:(completeEdit)block;

- (void)showWithCompleteBlock:(completeEdit)block Text:(NSString *)text;

- (void)disimiss;
@end
