//
//  ImageViewer.m
//  AirRun
//
//  Created by ChenHao on 4/3/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import "ImageViewer.h"
#import "UConstants.h"


@interface ImageViewer()<UIScrollViewDelegate>

@property (nonatomic, strong) UIView *BackgroundMaksView;
@property (nonatomic, strong) UIView *superView;

@property (nonatomic, strong) UIScrollView *scrollview;
@property (nonatomic, strong) NSMutableArray *data;

@property (nonatomic, assign) NSInteger currentIndex;



// Blocks
@property (nonatomic, copy) CompleteBlock completeBlock;

@end


@implementation ImageViewer

- (instancetype)initWithArray:(NSArray *)array WithSuperView:(UIView *)superview
{
    self = [super init];
    if (self) {
        _superView = superview;
        _data = [[NSMutableArray alloc] initWithArray:array];
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    [self setFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height)];
    [self setAlpha:0.0];
    
    _scrollview = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    int i=0;
    for (UIImage *image in _data) {
        UIImageView *v = [[UIImageView alloc] initWithFrame:CGRectMake(i*Main_Screen_Width, 0, Main_Screen_Width, Main_Screen_Height)];
        [v setImage:image];
        [v setContentMode:UIViewContentModeScaleAspectFit];
        [v setTag:40000+i];
        [_scrollview addSubview:v];
        i++;
    }
    _scrollview.delegate = self;
    [_scrollview setMinimumZoomScale:1.0];
    [_scrollview setMaximumZoomScale:5.0];
    [_scrollview setPagingEnabled:YES];
    [_scrollview setContentSize:CGSizeMake(Main_Screen_Width*[_data count], Main_Screen_Height)];
    [self addSubview:_scrollview];
    [_superView addSubview:self];
    [self creatBottomBar];
}

#pragma mark Public
- (void)dismiss
{
    [UIView animateWithDuration:0.3 animations:^{
        [self setFrame:CGRectMake(35, 245, 30, 30)];
        self.transform=CGAffineTransformMakeScale(0.01f, 0.01f);//先让要显示的view最小直至消失
        [self hideMaks];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
         _completeBlock(_data);
    }];
}

- (void)show
{
    self.transform=CGAffineTransformMakeScale(0.01f, 0.01f);//先让要显示的view最小直至消失
    [UIView animateWithDuration:0.3 animations:^{
        self.transform=CGAffineTransformMakeScale(1.0f, 1.0f);
        [self setAlpha:1.0];
        [self showMask];
    } completion:^(BOOL finished) {
        
    }];
}


- (void)showWithCompleteArray:(CompleteBlock)block
{
    _completeBlock = block;
    [self show];
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
        [_BackgroundMaksView setAlpha:0.9];
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


- (void)creatBottomBar
{
    UIView *bottom = [[UIView alloc] initWithFrame:CGRectMake(0, Main_Screen_Height-40, Main_Screen_Width, 40)];
    [bottom setBackgroundColor:[UIColor blackColor]];
    [self addSubview:bottom];
    
    
    UIButton *delete = [[UIButton alloc] initWithFrame:CGRectMake(Main_Screen_Width-35, 5, 30, 30)];
    [delete setImage:[UIImage imageNamed:@"trash"] forState:UIControlStateNormal];
    [delete addTarget:self action:@selector(deleteCurrentImage:) forControlEvents:UIControlEventTouchUpInside];
    [bottom addSubview:delete];
    
    
    UIButton *close = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 30, 30)];
    [close setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [close addTarget:self action:@selector(dismissself:) forControlEvents:UIControlEventTouchUpInside];
    [bottom addSubview:close];
    
}




#pragma Action

/**
 *  隐藏
 *
 *  @param sender
 */
- (void)dismissself:(id)sender
{
    [self dismiss];
}
/**
 *  删除图片
 *
 *  @param sender
 */
- (void)deleteCurrentImage:(id)sender
{
    /**
     *  如果后面还有图片，删除本张图然后后面的前移
     */
    if (_currentIndex+1<[_data count]) {
        
        UIImageView *currentView = (UIImageView *)[self viewWithTag:40000+_currentIndex];
        
        [currentView removeFromSuperview];
        [UIView animateWithDuration:0.3 animations:^{
            NSInteger i=0;
            for (i =_currentIndex+1;i<[_data count];i++) {
                UIImageView *currentView = (UIImageView *)[self viewWithTag:40000+i];
                CGRect now = currentView.frame;
                now.origin.x-=Main_Screen_Width;
                currentView.frame = now;
            }
        } completion:^(BOOL finished) {
            [_data removeObjectAtIndex:_currentIndex];
            [_scrollview setContentSize:CGSizeMake(Main_Screen_Width*[_data count], Main_Screen_Height)];
        }];
    }
    
    /**
     *  如果是最后一张图片,但剩下不止一张图片的时候,镜头向前偏移
     */
    if (_currentIndex+1==[_data count]&&[_data count] !=1) {
        
        [UIView animateWithDuration:0.6 animations:^{
    
            [_data removeObjectAtIndex:_currentIndex];
            
            UIImageView *currentView = (UIImageView *)[self viewWithTag:40000+_currentIndex];
            [currentView removeFromSuperview];
            _currentIndex -=1;
            
        } completion:^(BOOL finished) {
            [_scrollview setContentSize:CGSizeMake(Main_Screen_Width*[_data count], Main_Screen_Height)];
        }];
        
    }
    
    if ([_data count] ==1) {
        [_data removeObjectAtIndex:_currentIndex];
        UIImageView *currentView = (UIImageView *)[self viewWithTag:40000+_currentIndex];
        [currentView removeFromSuperview];
        [UIView animateWithDuration:0.3 animations:^{
            [self setAlpha:0.0];
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
            _completeBlock(_data);
        }];
    }
    
}


#pragma mark - ScrollView delegate
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    
    for (UIImageView *v in scrollView.subviews){
        return v;
    }
    return nil;
}



- (void)scrollViewDidScroll:(UIScrollView *)sender {
    int page = _scrollview.contentOffset.x / WIDTH(self);
    _currentIndex = page;
}

@end
