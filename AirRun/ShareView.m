//
//  ShareView.m
//  AirRun
//
//  Created by ChenHao on 4/9/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import "ShareView.h"
#import "UConstants.h"
#import <AVOSCloud.h>

@interface ShareView()

@property (nonatomic, strong) UIView *maskBackgroundView;
@property (nonatomic, strong) UIView *shareView;
@property (nonatomic, strong) UIButton *cancelButton;

@property (nonatomic, getter=isShow) BOOL show;
@end

@implementation ShareView

+ (instancetype)shareInstance
{
    static ShareView *shareInstane;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstane = [[ShareView alloc] init];
    });
    return shareInstane;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self commonInit];
        _show = NO;
    }
    return self;
}


- (void)commonInit
{
    [self setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.9]];
    _shareView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 150)];

    [self addSubview:_shareView];
    [self addShareButtons];
    
    _cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, MaxY(_shareView), Main_Screen_Width, 50)];
    [_cancelButton setBackgroundColor:[UIColor whiteColor]];
    [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_cancelButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_cancelButton];
    
    [self setFrame:CGRectMake(0, Main_Screen_Height - HEIGHT(_shareView)-HEIGHT(_cancelButton), Main_Screen_Width, 200)];
}


- (void)addShareButtons
{
    
    NSArray *shareButtons = @[
                              @{@"image":@"weiboshare",
                                @"title":@"分享到微博"
                                },
                              @{@"image":@"weixinshare",
                                @"title":@"分享到微信"
                                },
                              @{@"image":@"friendshare",
                                @"title":@"分享到朋友圈"
                                },
                              ];
    
    NSInteger width = (Main_Screen_Width - 5*30)/4;
    NSInteger i=0;
    for (NSDictionary *dic in shareButtons) {
        
        UIButton *icon = [[UIButton alloc] init];
        [icon setImage:[UIImage imageNamed:[dic objectForKey:@"image"]] forState:UIControlStateNormal];
        [icon setFrame:CGRectMake((width+30)*i+30, 20, width, width)];
        [icon setTag:1000+i];
        [icon addTarget:self action:@selector(ShareButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
        [_shareView addSubview:icon];
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake((width+30)*i+15, MaxY(icon)+5, width+30, 20)];
        
        [title setText:[dic objectForKey:@"title"]];
        [title setTextAlignment:NSTextAlignmentCenter];
        [title setFont:[UIFont systemFontOfSize:12]];
        [_shareView addSubview:title];
        i++;
    }
    
    
}

- (void)showInView:(UIView *)superView
{
    if (!self.isShow) {
        [self createMaskView];
        [superView addSubview:_maskBackgroundView];
        [superView addSubview:self];
        
        CGRect finalFrame = CGRectMake(0, Main_Screen_Height - HEIGHT(_shareView)-HEIGHT(_cancelButton), Main_Screen_Width, 200);
        
        [self setFrame:CGRectMake(0, Main_Screen_Height, Main_Screen_Width, 200)];
        [UIView animateWithDuration:0.2 animations:^{
            [_maskBackgroundView setAlpha:1];
            [self setFrame:finalFrame];
        } completion:^(BOOL finished) {
            _show = YES;
        }];
    }
    
}

- (void)dismiss
{
    CGRect finalFrame = self.frame;
    
    [UIView animateWithDuration:0.2 animations:^{
        [self setFrame:CGRectMake(0, Main_Screen_Height, finalFrame.size.width, finalFrame.size.height)];
        [_maskBackgroundView setAlpha:0];
    } completion:^(BOOL finished) {
        [_maskBackgroundView removeFromSuperview];
        _show = NO;
    }];
}
- (void)createMaskView
{
    _maskBackgroundView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [_maskBackgroundView setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.4]];
    [_maskBackgroundView setAlpha:0];
}



- (void)drawRect:(CGRect)rect
{
    
}


- (void)ShareButtonTouch:(id)sender
{
    UIButton *button = (UIButton *)sender;
    if (button.tag == 1000) {
        [_delegate shareview:self didSelectButton:ShareViewButtonTypeWeiBo];
        [AVAnalytics event:[NSString stringWithFormat:@"share"] label:@"weibo"];
    }
    else if (1001)
    {
        [AVAnalytics event:[NSString stringWithFormat:@"share"] label:@"wechat"];
        [_delegate shareview:self didSelectButton:ShareViewButtonTypeWeChat];
    }
}



@end
