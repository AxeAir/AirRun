//
//  CompleteDisplayCard.m
//  AirRun
//
//  Created by ChenHao on 4/1/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import "CompleteDisplayCard.h"
#import "UConstants.h"
#import "UIView+CHQuartz.h"
#import "MapViewDelegate.h"
#import <MapKit/MapKit.h>

@interface CompleteDisplayCard()<UIScrollViewDelegate>


@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) MKMapView *mapView;
@property (strong, nonatomic) UIButton *fouseButton;


@property (nonatomic, strong) UIPageControl* pagecontrol;

@property (nonatomic, strong) UIView   *speedAndTime;
@property (nonatomic, strong) UIView   *distanceAndCarl;

@property (nonatomic, strong) UILabel  *heartLabel;
@property (nonatomic, strong) UIButton *shareButton;
@property (nonatomic, strong) UIButton *completeButton;


@property (nonatomic, strong) NSString *heart;//新的体会


@property (nonatomic, strong) RunningRecordEntity *runningentity;


@end

@implementation CompleteDisplayCard


- (instancetype)initWithFrame:(CGRect)frame withEntity:(RunningRecordEntity *)entity
{
    self = [super initWithFrame:frame];
    if (self) {
        _runningentity = entity;
        [self commomInit];
    }
    return self;
}


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
    
    UIImageView *location = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"location"]];
    [location setFrame:CGRectMake(10, 10, 30, 30)];
    [_titleView addSubview:location];
    
    UILabel *degree = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH(self)/2+10, 10, 130, 30)];
    [degree setTextColor:[UIColor whiteColor]];
    [degree setText:@"24℃"];
    [degree setFont:[UIFont systemFontOfSize:16]];
    [_titleView addSubview:degree];
    
    
    UILabel *pm25 = [[UILabel alloc] init];
    [pm25 setTextColor:[UIColor whiteColor]];
    [pm25 setText:@"200"];
    [pm25 setFont:[UIFont boldSystemFontOfSize:16]];
    [pm25 sizeToFit];
    [pm25 setFrame:CGRectMake(WIDTH(self)-WIDTH(pm25)-10, 10, WIDTH(pm25), HEIGHT(pm25))];
    [_titleView addSubview:pm25];
    
    UILabel *pm25d = [[UILabel alloc] init];
    [pm25d setTextColor:[UIColor whiteColor]];
    [pm25d setText:@"PM"];
    [pm25d setFont:[UIFont systemFontOfSize:12]];
    [pm25d sizeToFit];
    [pm25d setFrame:CGRectMake(WIDTH(self)-WIDTH(pm25)-10, MaxY(pm25), WIDTH(pm25), HEIGHT(pm25d))];
    [pm25d setTextAlignment:NSTextAlignmentCenter];
    [_titleView addSubview:pm25d];
    
    _mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, MaxY(_titleView), WIDTH(self), 300)];
    [self addSubview:_mapView];
    
    _fouseButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_fouseButton setImage:[UIImage imageNamed:@"setting.png"] forState:UIControlStateNormal];
    [_fouseButton sizeToFit];
    _fouseButton.center = CGPointMake(WIDTH(self)-5-WIDTH(_fouseButton)/2, MaxY(_mapView)-5-HEIGHT(_fouseButton)/2);
    [_fouseButton addTarget:self action:@selector(fouchsButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_fouseButton];
    
    _mapDelegate = [[MapViewDelegate alloc] initWithMapView:_mapView];
    _mapView.delegate = _mapDelegate;
    
    _pagecontrol = [[UIPageControl alloc] initWithFrame:CGRectMake(0, MaxY(_mapView), WIDTH(self), 20)];
    _pagecontrol.numberOfPages =3;
    _pagecontrol.alpha = 0;
    [self addSubview:_pagecontrol];
    
    _distanceAndCarl = [self creatDistance:[NSString stringWithFormat:@"%.2f",[_runningentity.distance floatValue]] andCarl:[NSString stringWithFormat:@"%ld",[_runningentity.kcar integerValue]]];
    [_distanceAndCarl setFrame:CGRectMake(0, MaxY(_pagecontrol)+10, WIDTH(self), 50)];
    
    [self addSubview:_distanceAndCarl];
    
     _speedAndTime = [self creatSpeed:[NSString stringWithFormat:@"%.2f",[_runningentity.averagespeed floatValue]] andTime:[self formatTime:[_runningentity.time integerValue]]];
    [_speedAndTime setFrame:CGRectMake(0, MaxY(_distanceAndCarl)+15, WIDTH(self), 50)];
    
    [self addSubview:_speedAndTime];
    
    
}

- (UIView *)creatDistance:(NSString *)distance andCarl:(NSString *)carl
{
    
    UIView *view = [[UIView alloc] init];
    UIImageView *flag = [[UIImageView alloc] initWithFrame:CGRectMake(30, 15, 30, 30)];
    [flag setImage:[UIImage imageNamed:@"distance"]];
    [view addSubview:flag];
    
    UILabel *distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(flag)+5, 0, 0, 0)];
    [distanceLabel setFont:[UIFont boldSystemFontOfSize:30]];
    [distanceLabel setText:distance];
    [distanceLabel sizeToFit];
    [distanceLabel setTextColor:[UIColor whiteColor]];
    [view addSubview:distanceLabel];
    
    
    UILabel *km = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(flag)+5, MaxY(distanceLabel), 100, 14)];
    [km setFont:[UIFont boldSystemFontOfSize:12]];
    [km setText:@"距离Km"];
    [km setTextAlignment:NSTextAlignmentLeft];
    [km setTextColor:[UIColor whiteColor]];
    [view addSubview:km];
    
    
    UIImageView *water = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH(self)/2+30,  15, 30, 30)];
    
    [water setImage:[UIImage imageNamed:@"cal"]];
    [view addSubview:water];
    
    UILabel *calLabel = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(water)+5, 0, 0, 0)];
    [calLabel setFont:[UIFont boldSystemFontOfSize:30]];
    [calLabel setText:carl];
    [calLabel sizeToFit];
    [calLabel setTextColor:[UIColor whiteColor]];
    [view addSubview:calLabel];
    
    
    UILabel *ca = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(water)+5, MaxY(calLabel), 100, 14)];
    [ca setFont:[UIFont boldSystemFontOfSize:12]];
    [ca setText:@"卡路里Kcal"];
    [ca setTextAlignment:NSTextAlignmentLeft];
    [ca setTextColor:[UIColor whiteColor]];
    [view addSubview:ca];
    
    return view;
}


- (UIView *)creatSpeed:(NSString *)speed andTime:(NSString *)time
{
    
    UIView *view = [[UIView alloc] init];
    
    UIImageView *flag = [[UIImageView alloc] initWithFrame:CGRectMake(30, 15, 30, 30)];
    
    [flag setImage:[UIImage imageNamed:@"sharespeed2"]];
    [view addSubview:flag];
    
    UILabel *distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(flag)+5, 0, 0, 0)];
    [distanceLabel setFont:[UIFont boldSystemFontOfSize:30]];
    [distanceLabel setText:speed];
    [distanceLabel sizeToFit];
    [distanceLabel setTextColor:[UIColor whiteColor]];
    [view addSubview:distanceLabel];
    
    
    UILabel *km = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(flag)+5, MaxY(distanceLabel), 100, 14)];
    [km setFont:[UIFont boldSystemFontOfSize:12]];
    [km setText:@"速度Km"];
    [km setTextAlignment:NSTextAlignmentLeft];
    [km setTextColor:[UIColor whiteColor]];
    [view addSubview:km];
    
    
    UIImageView *water = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH(self)/2+30,  15, 30, 30)];
    
    [water setImage:[UIImage imageNamed:@"clock"]];
    [view addSubview:water];
    
    UILabel *calLabel = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(water)+5, 0, 0, 0)];
    [calLabel setFont:[UIFont boldSystemFontOfSize:30]];
    [calLabel setText:time];
    [calLabel sizeToFit];
    [calLabel setTextColor:[UIColor whiteColor]];
    [view addSubview:calLabel];
    
    
    UILabel *ca = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(water)+5, MaxY(calLabel), 100, 14)];
    [ca setFont:[UIFont boldSystemFontOfSize:12]];
    [ca setText:@"时间"];
    [ca setTextAlignment:NSTextAlignmentLeft];
    [ca setTextColor:[UIColor whiteColor]];
    [view addSubview:ca];
    
    return view;
}

- (void)adjust:(NSString *)heart
{
    if (![heart isEqualToString:@""]) {
        if (_heartLabel==nil) {
            _heartLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, MaxY(_speedAndTime)+10, WIDTH(self)-60, 30)];
        }
        _heart = heart;
        [_heartLabel setNumberOfLines:0];
        [_heartLabel setFont:[UIFont systemFontOfSize:12]];
        _heartLabel.text = heart;
        [_heartLabel setTextColor:[UIColor whiteColor]];
        [_heartLabel sizeToFit];
        [self addSubview:_heartLabel];
        
    }
    else
    {
        if (_heartLabel == nil) {
            _heartLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, MaxY(_speedAndTime)+10, 0, 0)];
        }
        _heartLabel.text = heart;
        [_heartLabel setTextColor:[UIColor whiteColor]];
        [self addSubview:_heartLabel];
    }
    
    if (_shareButton ==nil) {
        _shareButton = [[UIButton alloc] init];
    }
    [_shareButton setFrame:CGRectMake(0, 0, 140, 30)];
    _shareButton.center = CGPointMake(WIDTH(self)/2, MaxY(_heartLabel)+45);
    
    [_shareButton setTitle:@"分享跑步卡片" forState:UIControlStateNormal];
    [[_shareButton titleLabel] setFont:[UIFont boldSystemFontOfSize:16]];
    [_shareButton setBackgroundColor:RGBCOLOR(97, 187, 162)];
    [_shareButton addTarget:self action:@selector(shareButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_shareButton];
    
    
    if (_completeButton ==nil) {
        _completeButton = [[UIButton alloc] init];
    }
    [_completeButton setFrame:CGRectMake(0, 0, 140, 30)];
    _completeButton.center = CGPointMake(WIDTH(self)/2, MaxY(_shareButton)+35);
    
    [_completeButton setTitle:@"暂不分享" forState:UIControlStateNormal];
    [[_completeButton titleLabel] setFont:[UIFont boldSystemFontOfSize:16]];
    [_completeButton addTarget:self action:@selector(completeButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_completeButton];
    

    if (MaxY(_completeButton)+20>Main_Screen_Height+1) {
        [self setFrame:CGRectMake(10, 10, WIDTH(self), MaxY(_completeButton)+10)];
    }
    else
    {
        [self setFrame:CGRectMake(10, 10, WIDTH(self), Main_Screen_Height-20)];
       
    }
    
    [self setNeedsDisplay];
    
    
}


- (void)drawRect:(CGRect)rect
{
    [self drawLineFrom:CGPointMake(20, MaxY(_distanceAndCarl)+7.5) to:CGPointMake(WIDTH(self)-20, MaxY(_distanceAndCarl)+7.5) color:RGBCOLOR(145, 194, 235) width:1];
    
    
    if (_heart !=nil) {
        [self drawLineFrom:CGPointMake(20, MaxY(_speedAndTime)+7.5) to:CGPointMake(WIDTH(self)-20, MaxY(_speedAndTime)+7.5) color:RGBCOLOR(145, 194, 235) width:1];
    }
    

}

#pragma mark Action

- (void)shareButtonTouch:(id)sender
{
    [_delegate completeDisplayCard:self didSelectButton:CompleteDisplayCardButtonTypeShare];
}

- (void)fouchsButtonTouch:(UIButton *)sender {
    
    if ([_delegate respondsToSelector:@selector(completeDisplayCard:FoucsButtouTouch:)]) {
        [_delegate completeDisplayCard:self FoucsButtouTouch:sender];
    }
    
}


- (void)completeButtonTouch:(id)sender
{
    [_delegate completeDisplayCard:self didSelectButton:CompleteDisplayCardButtonTypeComplete];
}

#pragma mark function
- (NSString *)formatTime:(NSInteger)seconds
{
    if (seconds > 3600) {
        
    }
    else
    {
        return [NSString stringWithFormat:@"%0.2ld:%0.2ld",seconds/60,seconds%60];
    }
    return nil;
}

@end
