//
//  RunCompleteCardsVC.m
//  AirRun
//
//  Created by ChenHao on 4/1/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import "RunCompleteCardsVC.h"
#import "CompleteInputCard.h"
#import "CompleteDisplayCard.h"
#import "UConstants.h"
#import "PopInputView.h"

@interface RunCompleteCardsVC ()<UIScrollViewDelegate, CompleteInputCardDelegate>

@property (nonatomic, strong) UIScrollView *scrollview;
@property (nonatomic, strong) CompleteInputCard *inputcard;
@property (nonatomic, strong) CompleteDisplayCard *display;

@property (nonatomic, assign) BOOL up;

@end

@implementation RunCompleteCardsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _up = YES;
    
    _scrollview = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _scrollview.delegate = self;
    [_scrollview setBackgroundColor:[UIColor clearColor]];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"cardbg.jpg"]]];
    
    _inputcard = [[CompleteInputCard alloc] initWithFrame:CGRectMake(10, 10, Main_Screen_Width-20, 180)];
    _inputcard.delegate = self;
    [_scrollview addSubview:_inputcard];
    
    _display = [[CompleteDisplayCard alloc] initWithFrame:CGRectMake(10, MaxY(_inputcard)+10, Main_Screen_Width-20, 800)];
    [_scrollview addSubview:_display];
    
    [_scrollview setContentSize:CGSizeMake(Main_Screen_Width,Main_Screen_Height+1 )];
    //MaxY(display)+20
    [self.view addSubview:_scrollview];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    if (scrollView.contentOffset.y < - 50) {
        //向下拉到50松手后，
        DLog(@"下拉");
        [self changeToInput];
    }
    else if((scrollView.contentOffset.y>50)&& _up==YES)
    {
        DLog(@"上拉");
        [self changeToDisplay ];
    }
    
}

- (void)changeToDisplay
{
    
    [UIView animateWithDuration:0.3 animations:^{
        //[_scrollview setContentOffset:CGPointMake(0, 180) animated:YES];
        [_display setFrame:CGRectMake(10,10, Main_Screen_Width-20, 800)];
        [_display adjust:_inputcard.textview.text];
        [_inputcard setAlpha:0];
        [_scrollview setContentSize:CGSizeMake(Main_Screen_Width,Main_Screen_Height+1 )];
    } completion:^(BOOL finished) {
        _up = NO;
         [_scrollview setContentSize:CGSizeMake(Main_Screen_Width,HEIGHT(_display)+21 )];
    }];
}

- (void)changeToInput
{
    [UIView animateWithDuration:0.3 animations:^{
        [_scrollview setContentOffset:CGPointMake(0, 180) animated:YES];
        [_inputcard setFrame:CGRectMake(10,10, Main_Screen_Width-20, 180)];
        
        [_inputcard setAlpha:1.0];
        [_display setAlpha:1.0];
        [_display setFrame:CGRectMake(10, MaxY(_inputcard)+10, Main_Screen_Width-20, 800)];
        [_scrollview setContentSize:CGSizeMake(Main_Screen_Width,Main_Screen_Height+1 )];

    } completion:^(BOOL finished) {
        _up = YES;
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


#pragma mark Delegate


/**
 *  点击想下按钮
 */
- (void)didClickDownButton
{
    [self changeToDisplay];
}

/**
 *  点击新的出现输入框
 */
- (void)didTouchLabel
{
    [[[PopInputView alloc] initWithSuperView:self.view] showWithCompleteBlock:^(NSString *string) {
        NSLog(@"输入的内容为:%@",string);
        if (![string isEqualToString:@""]) {
            _inputcard.textview.text = string;
        }
    } Text:_inputcard.textview.text];
}


//隐藏状态栏
- (BOOL)prefersStatusBarHidden
{
    return YES;
}
@end
