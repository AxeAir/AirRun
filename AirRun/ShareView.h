//
//  ShareView.h
//  AirRun
//
//  Created by ChenHao on 4/9/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareView : UIView

+ (instancetype)shareInstance;

- (void)showInView:(UIView *)superView;

- (void)dismiss;

@end
