//
//  RunGuideViewController.m
//  AirRun
//
//  Created by JasonWu on 4/8/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import "RunGuideViewController.h"
#import "GuideView.h"
#import <AVOSCloud.h>

@interface RunGuideViewController () <UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIPageControl *pageControl;

@end

@implementation RunGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    
    [self p_layout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [AVAnalytics beginLogPageView:@"跑前指导页面"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [AVAnalytics endLogPageView:@"跑前指导页面"];
}

- (void)p_layout {
    
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 20+30, self.view.bounds.size.width, self.view.bounds.size.height-(20+30)-60)];
    _scrollView.contentSize = CGSizeMake(4*_scrollView.frame.size.width, 0);
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    
    GuideView *guideView1 = [[GuideView alloc] initWithFrame:CGRectMake(15, 0, _scrollView.frame.size.width-30, _scrollView.frame.size.height)];
    guideView1.image = [UIImage imageNamed:@"changweibo"];
    guideView1.closeBlock = ^(GuideView *view){
        [UIView transitionWithView:self.view.superview
                          duration:0.5
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            [self.view removeFromSuperview];
                        } completion:nil];
    };
    [self p_addShowdowToView:guideView1];
    [_scrollView addSubview:guideView1];
    
    GuideView *guideView2 = [[GuideView alloc] initWithFrame:CGRectMake(15+_scrollView.frame.size.width*1, 0, _scrollView.frame.size.width-30, _scrollView.frame.size.height)];
    guideView2.image = [UIImage imageNamed:@"rightway"];
    guideView2.closeBlock = ^(GuideView *view){
        [UIView transitionWithView:self.view.superview
                          duration:0.5
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            [self.view removeFromSuperview];
                        } completion:nil];
    };
    [self p_addShowdowToView:guideView2];
    [_scrollView addSubview:guideView2];
    
    GuideView *guideView3 = [[GuideView alloc] initWithFrame:CGRectMake(15+_scrollView.frame.size.width*2, 0, _scrollView.frame.size.width-30, _scrollView.frame.size.height)];
    guideView3.image = [UIImage imageNamed:@"shoes"];
    guideView3.closeBlock = ^(GuideView *view){
        
        [UIView transitionWithView:self.view.superview
                          duration:0.5
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            [self.view removeFromSuperview];
                        } completion:nil];
    };
    [self p_addShowdowToView:guideView3];
    [_scrollView addSubview:guideView3];
    
    GuideView *guideView4 = [[GuideView alloc] initWithFrame:CGRectMake(15+_scrollView.frame.size.width*3, 0, _scrollView.frame.size.width-30, _scrollView.frame.size.height)];
    guideView4.closeBlock = ^(GuideView *view){
        
        [UIView transitionWithView:self.view.superview
                          duration:0.5
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            [self.view removeFromSuperview];
                        } completion:nil];
    };
    guideView4.image = [UIImage imageNamed:@"strech"];
    [self p_addShowdowToView:guideView4];
    [_scrollView addSubview:guideView4];
    
    _pageControl = [[UIPageControl alloc] init];
    _pageControl.numberOfPages = 4;
    _pageControl.currentPage = 0;
    [_pageControl sizeToFit];
    _pageControl.center = CGPointMake(self.view.bounds.size.width/2, CGRectGetMaxY(_scrollView.frame)+30+_pageControl.frame.size.height/2);
    [self.view addSubview:_pageControl];
    
}

- (void)p_addShowdowToView:(UIView *)view {
    view.layer.masksToBounds = NO;
    view.layer.cornerRadius = 8; // if you like rounded corners
    view.layer.shadowOffset = CGSizeMake(5, 5);
    view.layer.shadowRadius = 5;
    view.layer.shadowOpacity = 0.7;
}

#pragma mark - UIScrollViewDelegate 

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    _pageControl.currentPage = _scrollView.contentOffset.x/_scrollView.frame.size.width;
    
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
