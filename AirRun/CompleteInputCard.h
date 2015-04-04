//
//  CompleteInputCard.h
//  AirRun
//
//  Created by ChenHao on 4/1/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseCardView.h"

@protocol CompleteInputCardDelegate

/**
 *  向下按钮
 */
- (void)didClickDownButton;
/**
 *  点击输入框
 */
- (void)didTouchLabel;

@end

@interface CompleteInputCard : BaseCardView

/**
 *  心得输入框
 */
@property (nonatomic, strong) UILabel *textview;

/**
 *  当前表情的选择
 */
@property (nonatomic, assign) NSInteger currentFaceIndex;

@property (nonatomic, weak) id<CompleteInputCardDelegate> delegate;



@end


