//
//  CompleteDisplayCard.m
//  AirRun
//
//  Created by ChenHao on 4/1/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import "CompleteDisplayCard.h"
#import "UConstants.h"


@interface CompleteDisplayCard()<UIScrollViewDelegate>


@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl* pagecontrol;
@end

@implementation CompleteDisplayCard


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commomInit];
    }
    return self;
}


- (void)commomInit
{
    _titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self), 50)];
    [self addSubview:_titleView];
    
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, MaxY(_titleView), WIDTH(self), 300)];
    [_scrollView setContentSize:CGSizeMake(WIDTH(self)*3, 300)];
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.delegate = self;
    _scrollView.scrollEnabled = YES;
    _scrollView.pagingEnabled = YES; //使用翻页属性
    _scrollView.bounces = NO;
    
    UIImageView *map = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"map.jpg"]];
    [map setFrame:CGRectMake(0, 0, WIDTH(self), 300)];
    
    [_scrollView addSubview:map];
    
    [self addSubview:_scrollView];
    
    
    _pagecontrol = [[UIPageControl alloc] initWithFrame:CGRectMake(0, MaxY(_scrollView), WIDTH(self), 20)];
    _pagecontrol.numberOfPages =3;
    [self addSubview:_pagecontrol];
    
    UIView *distanceAndCarl = [self creatDistance:@"3.45" andCarl:@"4000"];
    [distanceAndCarl setFrame:CGRectMake(0, MaxY(_pagecontrol), WIDTH(self), 50)];
    
    [self addSubview:distanceAndCarl];
    
    UIView *speedAndTime = [self creatSpeed:@"44.3" andTime:@"19:23"];
    [speedAndTime setFrame:CGRectMake(0, MaxY(distanceAndCarl), WIDTH(self), 50)];
    
    [self addSubview:speedAndTime];
    
    
}

- (UIView *)creatDistance:(NSString *)distance andCarl:(NSString *)carl
{
    
    UIView *view = [[UIView alloc] init];
    UIImageView *flag = [[UIImageView alloc] initWithFrame:CGRectMake(30, 15, 20, 20)];
    [flag setImage:[UIImage imageNamed:@"setting"]];
    [view addSubview:flag];
    
    UILabel *distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(flag)+5, 0, 0, 0)];
    [distanceLabel setFont:[UIFont boldSystemFontOfSize:30]];
    [distanceLabel setText:distance];
    [distanceLabel sizeToFit];
    [distanceLabel setTextColor:[UIColor whiteColor]];
    [view addSubview:distanceLabel];
    
    
    UILabel *km = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(flag)+2, MaxY(distanceLabel), WIDTH(distanceLabel), 14)];
    [km setFont:[UIFont boldSystemFontOfSize:12]];
    [km setText:@"距离Km"];
    [km setTextAlignment:NSTextAlignmentCenter];
    [km setTextColor:[UIColor whiteColor]];
    [view addSubview:km];
    
    
    UIImageView *water = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH(self)/2+30,  15, 20, 20)];
    
    [water setImage:[UIImage imageNamed:@"setting"]];
    [view addSubview:water];
    
    UILabel *calLabel = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(water)+5, 0, 0, 0)];
    [calLabel setFont:[UIFont boldSystemFontOfSize:30]];
    [calLabel setText:carl];
    [calLabel sizeToFit];
    [calLabel setTextColor:[UIColor whiteColor]];
    [view addSubview:calLabel];
    
    
    UILabel *ca = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(water)+2, MaxY(calLabel), WIDTH(calLabel), 14)];
    [ca setFont:[UIFont boldSystemFontOfSize:12]];
    [ca setText:@"卡路里Kcal"];
    [ca setTextAlignment:NSTextAlignmentCenter];
    [ca setTextColor:[UIColor whiteColor]];
    [view addSubview:ca];
    
    return view;
}


- (UIView *)creatSpeed:(NSString *)speed andTime:(NSString *)time
{
    
    UIView *view = [[UIView alloc] init];
    
    UIImageView *flag = [[UIImageView alloc] initWithFrame:CGRectMake(30, 15, 20, 20)];
    
    [flag setImage:[UIImage imageNamed:@"setting"]];
    [view addSubview:flag];
    
    UILabel *distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(flag)+5, 0, 0, 0)];
    [distanceLabel setFont:[UIFont boldSystemFontOfSize:30]];
    [distanceLabel setText:speed];
    [distanceLabel sizeToFit];
    [distanceLabel setTextColor:[UIColor whiteColor]];
    [view addSubview:distanceLabel];
    
    
    UILabel *km = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(flag)+2, MaxY(distanceLabel), WIDTH(distanceLabel), 14)];
    [km setFont:[UIFont boldSystemFontOfSize:12]];
    [km setText:@"距离Km"];
    [km setTextAlignment:NSTextAlignmentCenter];
    [km setTextColor:[UIColor whiteColor]];
    [view addSubview:km];
    
    
    UIImageView *water = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH(self)/2+30,  15, 20, 20)];
    
    [water setImage:[UIImage imageNamed:@"setting"]];
    [view addSubview:water];
    
    UILabel *calLabel = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(water)+5, 0, 0, 0)];
    [calLabel setFont:[UIFont boldSystemFontOfSize:30]];
    [calLabel setText:time];
    [calLabel sizeToFit];
    [calLabel setTextColor:[UIColor whiteColor]];
    [view addSubview:calLabel];
    
    
    UILabel *ca = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(water)+2, MaxY(calLabel), WIDTH(calLabel), 14)];
    [ca setFont:[UIFont boldSystemFontOfSize:12]];
    [ca setText:@"卡路里Kcal"];
    [ca setTextAlignment:NSTextAlignmentCenter];
    [ca setTextColor:[UIColor whiteColor]];
    [view addSubview:ca];
    
    return view;
}




- (void)scrollViewDidScroll:(UIScrollView *)sender {
    int page = _scrollView.contentOffset.x / WIDTH(self);
    _pagecontrol.currentPage = page;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
