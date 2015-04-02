//
//  PopInputView.m
//  AirRun
//
//  Created by ChenHao on 4/2/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import "PopInputView.h"
#import "UConstants.h"
@interface PopInputView()

@property (nonatomic, strong) UIView *maksView;
@property (nonatomic, strong) UIView *inputView;
@property (nonatomic, strong) UITextView *textView;

@property (nonatomic, strong) UIView *sView;


@property (nonatomic, strong) UIButton *okButton;


@end
static completeEdit Stablock;
@implementation PopInputView


- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithSuperView:(UIView *)superview
{
    self = [self init];
    if (self) {
        _sView = superview;
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    [self creatMaskatSuperView:_sView];
    [self creatPopView];
}


- (void)show
{
    [_sView addSubview:self];
    
    CGRect finalFrame = _inputView.frame;
    finalFrame.origin.y = -(HEIGHT(_inputView));
    _inputView.frame=finalFrame;
    
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.4 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        [_inputView setFrame:CGRectMake(30, 100, Main_Screen_Width-60, 190)];
    } completion:^(BOOL finished) {
        [_textView becomeFirstResponder];
    }];
}



- (void)showWithCompleteBlock:(completeEdit)block
{
    Stablock = block;
    [self show];
}

- (void)showWithCompleteBlock:(completeEdit)block Text:(NSString *)text
{
    [self showWithCompleteBlock:block];
    _textView.text = text;
}

- (void)disimiss
{
    
    [UIView animateWithDuration:0.2 animations:^{
        CGRect finalFrame = _inputView.frame;
        finalFrame.origin.y = -(HEIGHT(_inputView));
        _inputView.frame=finalFrame;
        [_maksView setAlpha:0];
    } completion:^(BOOL finished) {
        [_inputView removeFromSuperview];
        [_maksView removeFromSuperview];

    }];
}



- (void)creatPopView
{
    _inputView = [[UIView alloc] initWithFrame:CGRectMake(30, 100, Main_Screen_Width-60, 190)];
    [_inputView setBackgroundColor:[UIColor whiteColor]];
    [_sView addSubview:_inputView];

    //header
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(_inputView), 40)];
    [headerView setBackgroundColor:[UIColor grayColor]];
    [_inputView addSubview:headerView];
    
    UILabel *title = [[UILabel alloc] init];
    [title setFrame:CGRectMake(0, 0, 100, 20)];
    title.center = headerView.center;
    [title setTextAlignment:NSTextAlignmentCenter];
    title.text =@"跑步日记";
    [headerView addSubview:title];
    
    
    //header close
    UIButton *close = [[UIButton alloc] init];
    [close setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [close setFrame:CGRectMake(5, 5, 30, 30)];
    [close addTarget:self action:@selector(disimiss) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:close];
    
    
    _okButton = [[UIButton alloc] init];
    [_okButton setImage:[UIImage imageNamed:@"ic_menu_mark"] forState:UIControlStateNormal];
    [_okButton setFrame:CGRectMake(WIDTH(headerView)-35, 5, 30, 30)];
    [_okButton addTarget:self action:@selector(ok) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:_okButton];
    

    _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, MaxY(headerView), WIDTH(_inputView), 110)];
    [_inputView addSubview:_textView];
    
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, MaxY(_textView), WIDTH(self), 40)];
    [bottomView setBackgroundColor:[UIColor whiteColor]];
    [_inputView addSubview:bottomView];
    
    UIButton *addimage = [[UIButton alloc] init];
    [addimage setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [addimage setFrame:CGRectMake(WIDTH(headerView)-35, 5, 30, 30)];
    [addimage addTarget:self action:@selector(disimiss) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:addimage];
}


- (void)creatMaskatSuperView:(UIView *)superView;
{
    _maksView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [_maksView setBackgroundColor:[UIColor blackColor]];
    [_maksView setAlpha:0.5];
    [superView addSubview:_maksView];
}



#pragma mark Event
- (void)ok
{
    Stablock([_textView text]);
    [self disimiss];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}


@end
