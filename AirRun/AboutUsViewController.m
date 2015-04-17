//
//  AboutUsViewController.m
//  AirRun
//
//  Created by JasonWu on 4/9/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import "AboutUsViewController.h"
#import "PersonView.h"
#import <AVOSCloud.h>

@interface AboutUsViewController ()

@property (strong, nonatomic) UIImageView *bgImage;
@property (strong, nonatomic) UIButton *closeButton;

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) PersonView *yetiView;
@property (strong, nonatomic) PersonView *cheView;
@property (strong, nonatomic) PersonView *jasonView;
@property (strong, nonatomic) PersonView *desitinoView;

@end

@implementation AboutUsViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self p_layout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    _bgImage = [[UIImageView alloc] initWithFrame:self.view.bounds];
    _bgImage.image = [UIImage imageNamed:@"aboutusbg"];
    [self.view addSubview:_bgImage];
    
    _closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_closeButton setImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
    [_closeButton sizeToFit];
    _closeButton.center = CGPointMake(self.view.bounds.size.width-15-_closeButton.bounds.size.width/2, 20+_closeButton.bounds.size.height/2);
    [_closeButton addTarget:self action:@selector(closeButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_closeButton];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, self.view.bounds.size.height-80)];
    [self.view addSubview:_scrollView];
    
    _yetiView = [[PersonView alloc] initWithFrame:CGRectMake(15, 0, self.view.bounds.size.width-30, 90)];
    _yetiView.engNameLable.text = @"Yeti";
    _yetiView.headImg = [UIImage imageNamed:@"yeti"];
    _yetiView.layer.cornerRadius = 10;
    [_scrollView addSubview:_yetiView];
    
    _cheView = [[PersonView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(_yetiView.frame)+25, self.view.bounds.size.width-30, 90)];
    _cheView.layer.cornerRadius = 10;
    _cheView.nameLable.text = @"陈浩";
    _cheView.engNameLable.text = @"Harries";
    _cheView.roleLable.text = @"开发";
    [_scrollView addSubview:_cheView];
    
    _jasonView = [[PersonView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(_cheView.frame)+25, self.view.bounds.size.width-30, 90)];
    _jasonView.layer.cornerRadius = 10;
    _jasonView.headImg = [UIImage imageNamed:@"wj"];
    _jasonView.nameLable.text = @"吴健";
    _jasonView.engNameLable.text = @"Jason";
    _jasonView.roleLable.text = @"开发";
    [_scrollView addSubview:_jasonView];
    
    _desitinoView = [[PersonView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(_jasonView.frame)+25, self.view.bounds.size.width-30, 90)];
    _desitinoView.layer.cornerRadius = 10;
    _desitinoView.headImg = [UIImage imageNamed:@"destino"];
    _desitinoView.nameLable.text = @"梁锦峰";
    _desitinoView.engNameLable.text = @"Destino";
    _desitinoView.roleLable.text = @"开发";
    [_scrollView addSubview:_desitinoView];
    
    if (CGRectGetMaxY(_desitinoView.frame) > _scrollView.frame.size.height) {
        _scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(_desitinoView.frame)+25);
    }
    
}

#pragma mark - Event
#pragma mark Button Event
- (void)closeButtonTouch:(UIButton *)sender {
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
