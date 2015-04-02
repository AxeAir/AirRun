//
//  BaseCardView.m
//  AirRun
//
//  Created by ChenHao on 4/1/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import "BaseCardView.h"
#import "UConstants.h"

@implementation BaseCardView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self baseConfig];
    }
    return self;
}


- (void)baseConfig
{
    [[self layer] setCornerRadius:5.0];
    [[self layer] setMasksToBounds:YES];
    [self setBackgroundColor:CardBgColor];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
