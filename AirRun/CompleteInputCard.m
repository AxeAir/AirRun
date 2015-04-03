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
@interface CompleteInputCard()

@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) NSMutableArray *buttonArray;

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
    [weekLabel setFrame:CGRectMake(MaxX(dayLabel)+5, 10, 0, 0)];
    [weekLabel setText:[[DateHelper getFormatterDate:@"EEEE"] stringByReplacingOccurrencesOfString:@"星期" withString:@"周"]];
    [weekLabel setFont:[UIFont systemFontOfSize:12]];
    [weekLabel setTextColor:[UIColor whiteColor]];
    [weekLabel sizeToFit];
    [self addSubview:weekLabel];
    
    UILabel *monthLabel = [[UILabel alloc] init];
    [monthLabel setFrame:CGRectMake(MaxX(dayLabel)+5, MaxY(weekLabel), 0, 0)];
    [monthLabel setText:[NSString stringWithFormat:@"%@月",[DateHelper getFormatterDate:@"MM"]]];
    [monthLabel setFont:[UIFont systemFontOfSize:12]];
    [monthLabel setTextColor:[UIColor whiteColor]];
    [monthLabel sizeToFit];
    [self addSubview:monthLabel];
    
    
    NSInteger wid = WIDTH(self)/5;
    
    _buttonArray = [[NSMutableArray alloc] init];
    for (int i=0; i<5; i++) {
        NSInteger offset = i*wid;
        UIButton *biaoqing = [[UIButton alloc] initWithFrame:CGRectMake((wid-25)/2+offset, MaxY(dayLabel)+10, 25, 25)];
        [biaoqing setImage:[UIImage imageNamed:@"biaoqing"] forState:UIControlStateNormal];
        
        [biaoqing setImage:[UIImage imageNamed:@"setting"] forState:UIControlStateSelected];
        biaoqing.tag = 20000+i;
        [_buttonArray addObject:biaoqing];
        [biaoqing addTarget:self action:@selector(didSelectFace:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:biaoqing];
    }
    
    _textview = [[UILabel alloc] initWithFrame:CGRectMake(20, MaxY(dayLabel)+50, WIDTH(self)-40, 40)];
    [_textview setBackgroundColor:[UIColor whiteColor]];
    [[_textview layer] setCornerRadius:2];
    [_textview setText:@"说点什么嘛?"];
    [_textview setFont:[UIFont systemFontOfSize:14]];
    [_textview setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapText:)];
    [_textview addGestureRecognizer:tap];
    
    [self addSubview:_textview];
    
    UIButton *downButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    downButton.center = CGPointMake(WIDTH(self)/2, MaxY(_textview)+30);
    [downButton setImage:[UIImage imageNamed:@"down"] forState:UIControlStateNormal];
    [downButton addTarget:self action:@selector(downButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:downButton];
    
}



#pragma event

- (void)downButtonTouch:(id)sender
{
    [_delegate didClickDownButton];
}

- (void)didTapText:(id)sender
{
    [_delegate didTouchLabel];
}


- (void)didSelectFace:(id)sender
{
    UIButton *button = (UIButton *)sender;
    if (button.selected) {
        
    }
    else
    {
        for (UIButton *btn in _buttonArray) {
            [btn setSelected:NO];
        }
        button.selected = YES;
        _currentFaceIndex = button.tag-20000+1;
    }
    
    
}

#pragma mark private
-(void)setTextFieldLeftPadding:(UITextField *)textField forWidth:(CGFloat)leftWidth
{
    CGRect frame = textField.frame;
    frame.size.width = leftWidth;
    UIView *leftview = [[UIView alloc] initWithFrame:frame];
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.leftView = leftview;
}

@end
