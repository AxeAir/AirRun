//
//  RunGuideViewController.m
//  AirRun
//
//  Created by JasonWu on 4/8/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import "RunGuideViewController.h"
#import "GuideView.h"

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

- (void)p_layout {
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 20+30, self.view.bounds.size.width, self.view.bounds.size.height-(20+30)-60)];
    _scrollView.contentSize = CGSizeMake(4*_scrollView.frame.size.width, 0);
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    
    GuideView *guideView1 = [[GuideView alloc] initWithFrame:CGRectMake(15, 0, _scrollView.frame.size.width-30, _scrollView.frame.size.height)];
    guideView1.title = @"ccc";
    guideView1.content = @"你好";
    guideView1.closeBlock = ^(GuideView *view){
        
        [self dismissViewControllerAnimated:YES completion:nil];
    };
    [_scrollView addSubview:guideView1];
    
    GuideView *guideView2 = [[GuideView alloc] initWithFrame:CGRectMake(15+_scrollView.frame.size.width*1, 0, _scrollView.frame.size.width-30, _scrollView.frame.size.height)];
    guideView2.closeBlock = ^(GuideView *view){
        [self dismissViewControllerAnimated:YES completion:nil];
    };
    [_scrollView addSubview:guideView2];
    
    GuideView *guideView3 = [[GuideView alloc] initWithFrame:CGRectMake(15+_scrollView.frame.size.width*2, 0, _scrollView.frame.size.width-30, _scrollView.frame.size.height)];
    guideView3.closeBlock = ^(GuideView *view){
        
        [self dismissViewControllerAnimated:YES completion:nil];;
    };
    [_scrollView addSubview:guideView3];
    
    GuideView *guideView4 = [[GuideView alloc] initWithFrame:CGRectMake(15+_scrollView.frame.size.width*3, 0, _scrollView.frame.size.width-30, _scrollView.frame.size.height)];
    guideView4.closeBlock = ^(GuideView *view){
        
        [self dismissViewControllerAnimated:YES completion:nil];
    };
    [_scrollView addSubview:guideView4];
    
    _pageControl = [[UIPageControl alloc] init];
    _pageControl.numberOfPages = 4;
    _pageControl.currentPage = 0;
    [_pageControl sizeToFit];
    _pageControl.center = CGPointMake(self.view.bounds.size.width/2, CGRectGetMaxY(_scrollView.frame)+30+_pageControl.frame.size.height/2);
    [self.view addSubview:_pageControl];
    
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