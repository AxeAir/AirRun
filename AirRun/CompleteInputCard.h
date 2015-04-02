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

- (void)didClickDownButton;
- (void)didTouchLabel;
@end


@interface CompleteInputCard : BaseCardView

@property (nonatomic, strong) UITextField *textview;
@property (nonatomic, weak) id<CompleteInputCardDelegate> delegate;

@property (nonatomic, assign) NSInteger currentFaceIndex;

@end


