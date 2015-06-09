//
//  AboutUsViewController.m
//  AirRun
//
//  Created by JasonWu on 4/9/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import "AboutUsViewController.h"
#import <AVOSCloud.h>
#import <Masonry.h>


@interface AboutUsViewController ()

@property (strong, nonatomic) UIImageView *bgImage;
@property (strong, nonatomic) UIButton *closeButton;

@property (strong, nonatomic) UIScrollView *scrollView;


@end

@implementation AboutUsViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"关于我们"];
    [self p_layout];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [AVAnalytics beginLogPageView:@"关于我们页面"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [AVAnalytics endLogPageView:@"关于我们页面"];
}

#pragma mark - Layout

- (void)p_layout {
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]]];
    UIImageView *only_logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"only_logo"]];
    only_logoImageView.center = self.view.center;
    [self.view addSubview:only_logoImageView];
    
    UILabel *airRunLabel = [[UILabel alloc] init];
    //airRunLabel
    
    
}

#pragma mark - Event
#pragma mark Button Event
- (void)closeButtonTouch:(UIButton *)sender {
    
}



@end
