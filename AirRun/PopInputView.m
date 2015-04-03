//
//  PopInputView.m
//  AirRun
//
//  Created by ChenHao on 4/2/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import "PopInputView.h"
#import "UConstants.h"
#import "UIView+CHQuartz.h"
#import "ImageViewer.h"
@interface PopInputView() 

@property (nonatomic, strong) UIView *BackgroundMaksView;

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIView *superView;//父级视图
@property (nonatomic, strong) UIButton *okButton;
@property (nonatomic, strong) UIImageView *smallImage;//缩略图
@property (nonatomic, strong) NSArray *ImageArray;//图片数组



//Blocks
@property (nonatomic, copy) EditCompleteBlock editcompleteBlock;
@property (nonatomic, copy) ImportPhotosBlock importBlock;

@end

@implementation PopInputView

#pragma mark init
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
        _superView = superview;
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    [self setFrame:CGRectMake(30, 100, Main_Screen_Width-60, 190)];
    [self setBackgroundColor:[UIColor whiteColor]];
    [self setBackgroundColor:[UIColor whiteColor]];
    
    //header
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self), 40)];
    [self addSubview:headerView];
    
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
    [_okButton addTarget:self action:@selector(ok:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:_okButton];
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, MaxY(headerView), WIDTH(self), 110)];
    [self addSubview:_textView];
    
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, MaxY(_textView), WIDTH(self), 40)];
    [self addSubview:_bottomView];
    
    UIButton *addimage = [[UIButton alloc] init];
    [addimage setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [addimage setFrame:CGRectMake(WIDTH(headerView)-35, 5, 30, 30)];
    [addimage addTarget:self action:@selector(addImage:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:addimage];
}


#pragma mark Public

- (void)show
{
    [self commonInit];
    [self showMask];
    [_superView addSubview:self];
    
    CGRect finalFrame = self.frame;
    finalFrame.origin.y = -(HEIGHT(self));
    self.frame=finalFrame;
    
    [UIView animateWithDuration:1 delay:0.0 usingSpringWithDamping:0.4 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        [self setFrame:CGRectMake(30, 100, Main_Screen_Width-60, 190)];
    } completion:^(BOOL finished) {
        [_textView becomeFirstResponder];
    }];
}

- (void)showWithCompleteBlock:(EditCompleteBlock)block
{
    _editcompleteBlock = block;
    [self show];
}

- (void)showWithCompleteBlock:(EditCompleteBlock)block Text:(NSString *)text photoBlock:(ImportPhotosBlock)improtblock
{
    [self showWithCompleteBlock:block];
    _importBlock = improtblock;
    _textView.text = text;
}

- (void)disimiss
{
    [UIView animateWithDuration:0.2 animations:^{
        CGRect finalFrame = self.frame;
        finalFrame.origin.y = -(HEIGHT(self));
        self.frame=finalFrame;
        [self hideMaks];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)addSmallPictures:(NSArray *)imageArray
{
    if ([imageArray count]>=1) {
        _ImageArray = imageArray;
        if(_smallImage == nil)
        {
            _smallImage = [[UIImageView alloc] init];
        }
        [[_smallImage layer] setCornerRadius:15];
        [[_smallImage layer] setMasksToBounds:YES];
        [_smallImage setFrame:CGRectMake(5, 5, 30, 30)];
        [_smallImage setImage:[imageArray objectAtIndex:0]];
        [_smallImage setUserInteractionEnabled:YES];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchImage2Edit:)];
        [_smallImage addGestureRecognizer:tap];
        [_bottomView addSubview:_smallImage];
    }
}

#pragma mark private
- (void)showMask
{
    if (_BackgroundMaksView ==nil) {
        _BackgroundMaksView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    }
    [_BackgroundMaksView setBackgroundColor:[UIColor blackColor]];
    [_BackgroundMaksView setAlpha:0.0];
    [_superView insertSubview:_BackgroundMaksView belowSubview:self];
    
    [UIView animateWithDuration:0.2 animations:^{
        [_BackgroundMaksView setAlpha:0.8];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hideMaks
{
    if (_BackgroundMaksView!=nil) {
        [UIView animateWithDuration:0.2 animations:^{
            [_BackgroundMaksView setAlpha:0.0];
        } completion:^(BOOL finished) {
            [_BackgroundMaksView removeFromSuperview];
        }];
    }
    
}


#pragma mark Event
- (void)ok:(id)sender
{
    _editcompleteBlock([_textView text]);
    [self disimiss];
}

/**
 *  点击添加图片按钮
 *
 *  @param sender 
 */
- (void)addImage:(id)sender
{
    _importBlock();
}

/**
 *  编辑已选图片
 *
 *  @param sender
 */
- (void)touchImage2Edit:(id)sender
{
    [_textView resignFirstResponder];
    ImageViewer *viewer = [[ImageViewer alloc] initWithArray:_ImageArray WithSuperView:_superView];
    [viewer showWithCompleteArray:^(NSMutableArray *array) {
        _ImageArray = array;
    }];
    
}


#pragma mark overrite
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    [self drawLineFrom:CGPointMake(0, 40) to:CGPointMake(WIDTH(self), 40) color:[UIColor blackColor] width:1];
    
    [self drawLineFrom:CGPointMake(0, 150) to:CGPointMake(WIDTH(self), 150) color:[UIColor blackColor] width:1];
}


@end
