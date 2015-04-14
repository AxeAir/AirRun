//
//  EditImageView.m
//  AirRun
//
//  Created by JasonWu on 4/6/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import "EditImageView.h"

@interface EditImageView () <UIScrollViewDelegate>

@property (weak, nonatomic) UIView *addView;

@property (assign, nonatomic) BOOL editable;

@property (strong, nonatomic) NSArray *imgs;
@property (strong, nonatomic) NSMutableArray *imgViews;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIToolbar *toolBar;
@property (strong, nonatomic) UIBarButtonItem *closeButton;
@property (strong, nonatomic) UIBarButtonItem *deleteButton;

@end

@implementation EditImageView

#pragma mark - Set

- (void)setCurrentIndex:(NSInteger)currentIndex {
    _currentIndex = currentIndex;
    [_scrollView setContentOffset:CGPointMake(currentIndex*_scrollView.frame.size.width, 0)];
}

- (instancetype)initWithImages:(NSArray *)imgs InView:(UIView *)view Editeable:(BOOL)editable {
    
    self = [super init];
    if (self) {
        _imgs = imgs;
        _addView = view;
        _editable = editable;
        [self p_commonInit];
    }
    return self;
}

#pragma mark - Layout

- (void)p_commonInit {
    
    self.frame = _addView.bounds;
    [_addView addSubview:self];
    _imgViews = [[NSMutableArray alloc] init];
    _currentIndex = 0;
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView.contentSize = CGSizeMake(self.frame.size.width*_imgs.count, 0);
    _scrollView.backgroundColor = [UIColor blackColor];
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    [self addSubview:_scrollView];
    [self p_addImgsToScrollView];
    
    if (!_editable) {
        return;
    }
    _toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.frame.size.height-44, self.frame.size.width, 44)];
    _toolBar.barTintColor = [UIColor blackColor];
    [self addSubview:_toolBar];
    
    _closeButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"setting.png"] style:UIBarButtonItemStylePlain target:self action:@selector(closeButtonTouch:)];
    UIBarButtonItem *flexButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    _deleteButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"setting.png"] style:UIBarButtonItemStylePlain target:self action:@selector(deleteButtonTouch:)];
    _toolBar.items = @[_closeButton,flexButton,_deleteButton];
    [self addSubview:_toolBar];
    
}

- (void)p_addImgsToScrollView {
    
    [_imgs enumerateObjectsUsingBlock:^(UIImage *img, NSUInteger idx, BOOL *stop) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(idx*_scrollView.frame.size.width, 0,_scrollView.frame.size.width , _scrollView.frame.size.height)];
        imageView.image = img;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.backgroundColor = [UIColor blackColor];
        [_imgViews addObject:imageView];
        [_scrollView addSubview:imageView];
    }];
}

#pragma mark - Event
#pragma mark Button Event
- (void)closeButtonTouch:(id)sender {
    
    if (_closeBlock) {
        _closeBlock(self);
    }
    [self  removeFromSuperview];
}

- (void)deleteButtonTouch:(id)sender {
    
    if (_deleteBlock) {
        _deleteBlock(_imgs[_currentIndex],_currentIndex);
    }
    [self p_deleteAtIndex:_currentIndex];
}

#pragma mark - Action
- (void)p_deleteAtIndex:(NSInteger)idx {
    
    UIImageView *imageView = _imgViews[idx];
    [_imgViews removeObjectAtIndex:idx];
    
    
    //图片消失动画
    CGRect imageFrame = imageView.frame;
    imageFrame.origin = imageView.center;
    imageFrame.size = CGSizeZero;
    [UIView animateWithDuration:0.5 animations:^{
        imageView.frame = imageFrame;
    } completion:^(BOOL finished) {
        [imageView removeFromSuperview];
        
        if (_imgViews.count == 0) {
            [self closeButtonTouch:nil];
            return ;
        }
        
        if (idx != _imgViews.count) {//不是最后一张图片
            //后面的imageView向前移动
            for (long i=(long)idx; i<_imgViews.count; i++) {
                UIImageView *imgView = _imgViews[i];
                CGRect frame = CGRectMake(i*_scrollView.frame.size.width, 0, _scrollView.frame.size.width, _scrollView.frame.size.height);
                [UIView animateWithDuration:0.5 animations:^{
                    imgView.frame = frame;
                }];
            }
        } else {//最后一张图片
            [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width*(_imgs.count-1), 0) animated:YES];
        }

        _scrollView.contentSize = CGSizeMake(_imgViews.count *_scrollView.frame.size.width, 0);
        
    }];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    _currentIndex = scrollView.contentOffset.x/scrollView.frame.size.width;
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
