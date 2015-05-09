//
//  GuideView.m
//  AirRun
//
//  Created by JasonWu on 4/8/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import "GuideView.h"

static const CGFloat MARGINSIDE = 10;
static const CGFloat MARGINUP = 30;

@interface GuideView ()

@property (strong, nonatomic) UIButton *closeButton;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation GuideView

#pragma mark - Set

- (void)setImage:(UIImage *)image {
    _image = image;
    
    CGFloat imageViewWidth = _scrollView.bounds.size.width-2*MARGINSIDE;
    CGFloat imageViewHeight = _image.size.height*imageViewWidth/_image.size.width;
    _imageView.frame = CGRectMake(MARGINSIDE, MARGINUP, imageViewWidth, imageViewHeight);
    _imageView.image = _image;
}

#pragma mark - Init
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self p_commonInit];
    }
    return self;
}

- (void)p_commonInit {
    
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 5;
    self.clipsToBounds = YES;
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:_scrollView];
    
    _imageView = [[UIImageView alloc] init];
    [_scrollView addSubview:_imageView];
    
    _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _closeButton.frame = CGRectMake(0, 0, 20, 20);
    [_closeButton setImage:[UIImage imageNamed:@"closetips"] forState:UIControlStateNormal];
    _closeButton.center = CGPointMake(self.bounds.size.width-5-_closeButton.bounds.size.width/2, 5+_closeButton.bounds.size.height/2);
    [_closeButton addTarget:self action:@selector(closeButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_closeButton];
    
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _closeButton.center = CGPointMake(self.bounds.size.width-5-_closeButton.bounds.size.width/2, 5+_closeButton.bounds.size.height/2);
    _scrollView.frame = self.bounds;

    if (CGRectGetMaxY(_imageView.frame)>_scrollView.frame.size.height) {
        _scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(_imageView.frame)+10);
    }
}

#pragma mark - Event
#pragma mark Button Event

- (void)closeButtonTouch:(UIButton *)sender {
    if (_closeBlock) {
        _closeBlock(self);
    }
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
