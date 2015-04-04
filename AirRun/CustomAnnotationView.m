//
//  CustomAnnotationView.m
//  MkAnnotationTest
//
//  Created by jasonWu on 12/28/14.
//  Copyright (c) 2014 jasonWu. All rights reserved.
//

#import "CustomAnnotationView.h"
#import "CustomAnnotation.h"

static CGFloat kBottomMargin = 6.0;
static CGFloat kLeftMargin = 6.0;
static CGFloat kRightMargin = 6.0;
static CGFloat kTopMargin = 6.0;
static CGFloat kSpanMargin = 6.0f;
static CGFloat kImageViewWidth = 35.0;
static CGFloat kImageViewHeight = 50.0;
static CGFloat kPointHeight = 14.0;

@interface CustomAnnotationView ()

@property (strong, nonatomic) UIButton *bgButton;

@end

#pragma mark -

@implementation CustomAnnotationView

- (instancetype)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        [self computeFrame];
        [self configAnnotation];
        
    }
    return self;
}

/**
 *  计算Annotation的frame的大小
 */
- (void)computeFrame {
    
    CustomAnnotation *customAnnotation = (CustomAnnotation *)self.annotation;
    if (customAnnotation) {
        
        //计算自身的frame大小
        CGFloat selfWidth = customAnnotation.imageArray.count * kImageViewWidth + (customAnnotation.imageArray.count - 1) *kSpanMargin + kLeftMargin + kRightMargin;
        CGFloat selfHeight = kTopMargin + kImageViewHeight + kBottomMargin + kPointHeight;
        self.frame = CGRectMake(0, 0, selfWidth, selfHeight);
        
        //移动整个view的位置，让箭头指向点
        self.centerOffset = CGPointMake(0, -selfHeight/2);
        
    }
    
}

/**
 *  装配view里的东西
 */
- (void)configAnnotation {
    
    //装配背景按钮
    self.bgButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.bgButton.frame = self.bounds;
    self.bgButton.backgroundColor = [UIColor clearColor];
    [self.bgButton addTarget:self action:@selector(bgButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.bgButton];
    
    //装配图片
    CustomAnnotation *customAnnotation = (CustomAnnotation *)self.annotation;
    for (int i = 0; i < customAnnotation.imageArray.count; i++) {
        CGFloat imageX = kLeftMargin + i*kImageViewWidth + i*kSpanMargin;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageX, kTopMargin, kImageViewWidth, kImageViewHeight)];
        imageView.backgroundColor = [UIColor blackColor];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image = customAnnotation.imageArray[i];
        [self addSubview:imageView];
    }
    
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    CustomAnnotation *customAnnotation = (CustomAnnotation *)self.annotation;
    if (customAnnotation) {
        [[UIColor grayColor] setFill];

        /**
         *  画三角形
         */
        UIBezierPath *triangleShape = [UIBezierPath bezierPath];
        [triangleShape moveToPoint:CGPointMake(kLeftMargin, 0)];
        [triangleShape addLineToPoint:CGPointMake(self.frame.size.width/2, self.frame.size.height)];
        [triangleShape addLineToPoint:CGPointMake(self.frame.size.width-kRightMargin, 0)];
        [triangleShape fill];
        
        //画长方形
        UIBezierPath *rectShape = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - kPointHeight)
                                                             cornerRadius:5];
        rectShape.lineWidth = 2.0;
        [rectShape fill];
    }
}

#pragma mark - Button Touch

- (void)bgButtonTouch:(id)sender {
    CustomAnnotation *customAnnotation = (CustomAnnotation *)self.annotation;
    if ([customAnnotation.delegate respondsToSelector:@selector(tapCustomeAnnotation:)]) {
        
        //防止多次点击
        UIButton *button = (UIButton *)sender;
        button.enabled = NO;
        [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(buttonActive:) userInfo:nil repeats:NO];
        
        [customAnnotation.delegate tapCustomeAnnotation:customAnnotation];
    }
    
}

#pragma mark - Timer Event
//激活按钮
- (void)buttonActive:(NSTimer *)timer {
    NSLog(@"button enabled");
    self.bgButton.enabled = YES;
}


@end
