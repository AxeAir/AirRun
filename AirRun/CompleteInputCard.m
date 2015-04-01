//
//  CompleteInputCard.m
//  AirRun
//
//  Created by ChenHao on 4/1/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import "CompleteInputCard.h"
#import "UConstants.h"
#import "DateHelper.h"
@interface CompleteInputCard()<UITextViewDelegate>

@property (nonatomic, strong) UITextView *textview;

@property (nonatomic, strong) UIButton *closeButton;

@end

@implementation CompleteInputCard

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commomInit];
    }
    return self;
}


- (void)commomInit
{
    //time
    UILabel *dayLabel = [[UILabel alloc] init];
    [dayLabel setFrame:CGRectMake(20, 10, 0, 0)];
    [dayLabel setText:[DateHelper getFormatterDate:@"dd"]];
    [dayLabel setFont:[UIFont systemFontOfSize:25]];
    [dayLabel setTextColor:[UIColor whiteColor]];
    [dayLabel sizeToFit];
    [self addSubview:dayLabel];
    
    UILabel *weekLabel = [[UILabel alloc] init];
    [weekLabel setFrame:CGRectMake(MaxX(dayLabel), 10, 0, 0)];
    [weekLabel setText:[DateHelper getFormatterDate:@"EEEE"]];
    [weekLabel setFont:[UIFont systemFontOfSize:12]];
    [weekLabel setTextColor:[UIColor whiteColor]];
    [weekLabel sizeToFit];
    [self addSubview:weekLabel];
    
    UILabel *monthLabel = [[UILabel alloc] init];
    [monthLabel setFrame:CGRectMake(MaxX(dayLabel), MaxY(weekLabel), 0, 0)];
    [monthLabel setText:[NSString stringWithFormat:@"%@月",[DateHelper getFormatterDate:@"MM"]]];
    [monthLabel setFont:[UIFont systemFontOfSize:12]];
    [monthLabel setTextColor:[UIColor whiteColor]];
    [monthLabel sizeToFit];
    [self addSubview:monthLabel];
    
    
    UIImageView *biaoqing = [[UIImageView alloc] initWithFrame:CGRectMake(20, MaxY(dayLabel)+10, 25, 25)];
    [biaoqing setImage:[UIImage imageNamed:@"biaoqing"]];
    [self addSubview:biaoqing];
    
    
    _textview = [[UITextView alloc] initWithFrame:CGRectMake(20, MaxY(biaoqing)+10, WIDTH(self)-40, 40)];
    [_textview setBackgroundColor:[UIColor whiteColor]];
    [[_textview layer] setCornerRadius:2];
    //[_textview setPlaceholder:@"说点什么嘛?"];
    [_textview setDelegate:self];
    
    [self addSubview:_textview];
    
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [self openCard];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}


- (void)openCard
{

    
}


- (void)closeCard
{
    
}
@end
