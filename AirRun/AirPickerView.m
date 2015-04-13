//
//  AirPickerView.m
//  AirRun
//
//  Created by ChenHao on 4/5/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import "AirPickerView.h"
#import "UConstants.h"

@interface AirPickerView ()<UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, copy) selectComplete selectCompleteBlock;
@property (nonatomic, copy) selectDateComplete selectDateCompleteBlock;

@property (nonatomic, strong) NSArray *dataSource;

@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, strong) UIDatePicker *datePicker;

@end

@implementation AirPickerView


- (instancetype)initWithFrame:(CGRect)frame dataSource:(NSArray *)dataSource
{
    
    self = [super initWithFrame:frame];
    if (self) {
        _dataSource = dataSource;
        [self commonInit];
    }
    return self;
}


- (instancetype)initWithDatePickerFrames:(CGRect)frame date:(NSDate *)date
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonDate];
    }
    return self;
}

- (void)commonInit
{
    
    [self setBackgroundColor:[UIColor grayColor]];
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 30,WIDTH(self) , HEIGHT(self)-40)];
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    
    [self addSubview:_pickerView];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self), 40)];
    [headerView setBackgroundColor:CardBgColor];
    [self addSubview:headerView];
    
    UIButton *okButton = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH(self)-50, 0, 50, 40)];
    [okButton setTitle:@"确定" forState:UIControlStateNormal];
    [okButton addTarget:self action:@selector(okButton:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:okButton];
    
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 40)];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:cancelButton];
}


- (void)commonDate
{
    [self setBackgroundColor:[UIColor grayColor]];
    _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 30,WIDTH(self) , HEIGHT(self)-40)];
    _datePicker.datePickerMode = UIDatePickerModeDate;
    
    [self addSubview:_datePicker];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self), 40)];
    [headerView setBackgroundColor:[UIColor redColor]];
    [self addSubview:headerView];
    
    UIButton *okButton = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH(self)-50, 0, 50, 40)];
    [okButton setTitle:@"确定" forState:UIControlStateNormal];
    [okButton addTarget:self action:@selector(dateOkbutton:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:okButton];
    
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 40)];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:cancelButton];
}



- (void)showInView:(UIView *)superview completeBlock:(selectComplete)block
{
    
    _selectCompleteBlock = block;
    _maskView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [_maskView setBackgroundColor:[UIColor clearColor]];
    [superview addSubview:_maskView];
    
    [superview addSubview:self];
    
    CGRect finalFrame = self.frame;
    CGRect startFrame = finalFrame;
    startFrame.origin.y = Main_Screen_Height;
    
    [self setFrame:startFrame];
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = finalFrame;
    } completion:^(BOOL finished) {
        
    }];
    
}


- (void)showDateInView:(UIView *)superview completeBlock:(selectDateComplete)block
{
    
    _selectDateCompleteBlock = block;
    _maskView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [_maskView setBackgroundColor:[UIColor clearColor]];
    [superview addSubview:_maskView];
    
    [superview addSubview:self];
    CGRect finalFrame = self.frame;
    CGRect startFrame = finalFrame;
    startFrame.origin.y = Main_Screen_Height;
    
    [self setFrame:startFrame];
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = finalFrame;
    } completion:^(BOOL finished) {
        
    }];
    
}



- (void)dismiss
{
    CGRect finalFrame = self.frame;
    finalFrame.origin.y = Main_Screen_Height;
    [UIView animateWithDuration:0.2 animations:^{
        self.frame = finalFrame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [_maskView removeFromSuperview];
    }];
}



/*表示UIPickerView一共有几列*/
- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [_dataSource count];
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [_dataSource objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _currentIndex = row;
}


#pragma mark Event

- (void)okButton:(id)sender
{
    [self dismiss];
    _selectCompleteBlock(_currentIndex, [_dataSource objectAtIndex:_currentIndex]);
}


- (void)dateOkbutton:(id)sender
{
    [self dismiss];
    _selectDateCompleteBlock(_datePicker.date);
}


@end
