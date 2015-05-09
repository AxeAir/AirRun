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
#import "DateHelper.h"

@interface CompleteDisplayCard()<UIScrollViewDelegate>


@property (nonatomic, strong) UIView *titleView;

@property (strong, nonatomic) UIButton *fouseButton;
@property (strong, nonatomic) UIButton *mapImageButton;

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
    
    UIImageView *location = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"locationwhite"]];
    [location setFrame:CGRectMake(10, 15, 20, 20)];
    [_titleView addSubview:location];
    
    UILabel *cityName = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(location)+5, 10, 100, 30)];
    [cityName setText:_runningentity.city];
    [cityName setTextColor:[UIColor whiteColor]];
    [cityName sizeToFit];
    [cityName setFont:[UIFont systemFontOfSize:14]];
    [cityName setCenter:CGPointMake(MaxX(location)+5+WIDTH(cityName)/2, 25)];
    [_titleView addSubview:cityName];
    
    
    UILabel *monthDayLable = [[UILabel alloc] init];
    monthDayLable.text = [DateHelper getDateFormatter:@"MM-dd" FromDate:_runningentity.finishtime];
    [monthDayLable sizeToFit];
    [monthDayLable setFont:[UIFont systemFontOfSize:16]];
    [monthDayLable setTextColor:[UIColor whiteColor]];
    [monthDayLable setCenter:CGPointMake(WIDTH(_titleView)/2, 25 -8)];
    [_titleView addSubview:monthDayLable];
    
    
    
    UILabel *timeLable = [[UILabel alloc] init];
    timeLable.text = [DateHelper getDateFormatter:@"mm:ss" FromDate:_runningentity.finishtime];
    [timeLable setFont:[UIFont systemFontOfSize:12]];
    [timeLable sizeToFit];
    [timeLable setAlpha:0.8];
    [timeLable setTextColor:[UIColor whiteColor]];
    [timeLable setCenter:CGPointMake(WIDTH(_titleView)/2, 25+8)];
    [_titleView addSubview:timeLable];
    
    UILabel *degree = [[UILabel alloc] init];
    [degree setTextColor:[UIColor whiteColor]];
    [degree setText:[NSString stringWithFormat:@"%@",_runningentity.weather]];
    [degree setFont:[UIFont boldSystemFontOfSize:16]];
    [degree sizeToFit];
    [degree setFrame:CGRectMake(WIDTH(self)-WIDTH(degree)-10, 10, WIDTH(degree), HEIGHT(degree))];
    [_titleView addSubview:degree];
    
    UILabel *pm25d = [[UILabel alloc] init];
    [pm25d setTextColor:[UIColor whiteColor]];
    [pm25d setText:[NSString stringWithFormat:@"PM %ld",(long)[_runningentity.pm25 integerValue]]];
    [pm25d setFont:[UIFont systemFontOfSize:12]];
    [pm25d sizeToFit];
    [pm25d setFrame:CGRectMake(WIDTH(self)-WIDTH(pm25d)-20, MaxY(degree), WIDTH(pm25d), HEIGHT(pm25d))];
    [pm25d setTextAlignment:NSTextAlignmentCenter];
    [_titleView addSubview:pm25d];
    
    _mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, MaxY(_titleView), WIDTH(self), 300)];
    [self addSubview:_mapView];
    
    _fouseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_fouseButton setImage:[UIImage imageNamed:@"focus"] forState:UIControlStateNormal];
    [_fouseButton setTintColor:[UIColor blackColor]];
    [_fouseButton sizeToFit];
    _fouseButton.center = CGPointMake(WIDTH(self)-5-WIDTH(_fouseButton)/2, MaxY(_mapView)-5-HEIGHT(_fouseButton)/2);
    [_fouseButton addTarget:self action:@selector(fouchsButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_fouseButton];
    
    _mapImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_mapImageButton setImage:[UIImage imageNamed:@"nophoto"] forState:UIControlStateNormal];
    [_mapImageButton sizeToFit];
    _mapImageButton.center = CGPointMake(WIDTH(self)-5-WIDTH(_mapImageButton)/2, Y(_fouseButton)-5-HEIGHT(_mapImageButton)/2);
    [_mapImageButton addTarget:self action:@selector(mapImageButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
    _mapImageButton.tag = 10001;//表示现在显示图片
    [self addSubview:_mapImageButton];
    
    
    
    _pagecontrol = [[UIPageControl alloc] initWithFrame:CGRectMake(0, MaxY(_mapView), WIDTH(self), 20)];
    _pagecontrol.numberOfPages =3;
    _pagecontrol.alpha = 0;
    [self addSubview:_pagecontrol];
    
    _distanceAndCarl = [self creatDistance:[NSString stringWithFormat:@"%.2f",[_runningentity.distance floatValue]/1000] andCarl:[NSString stringWithFormat:@"%.1f",[_runningentity.kcar floatValue]]];
    [_distanceAndCarl setFrame:CGRectMake(0, MaxY(_pagecontrol)+10, WIDTH(self), 50)];
    
    [self addSubview:_distanceAndCarl];
    
     _speedAndTime = [self creatSpeed:[NSString stringWithFormat:@"%.2f",[_runningentity.averagespeed floatValue]] andTime:[self formatTime:[_runningentity.time integerValue]]];
    [_speedAndTime setFrame:CGRectMake(0, MaxY(_distanceAndCarl)+15, WIDTH(self), 50)];
    
    [self addSubview:_speedAndTime];
}

- (void)changeToNormalModel
{
    [_shareButton setAlpha:1];
    [_completeButton setAlpha:1];
}

- (void)changeToshareModel
{
    [_shareButton setAlpha:0];
    [_completeButton setAlpha:0];
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
    [km setText:@"距离 km"];
    [km setTextAlignment:NSTextAlignmentLeft];
    [km setTextColor:[UIColor whiteColor]];
    [view addSubview:km];
    
    
    UIImageView *water = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH(self)/2+30,  15, 30, 30)];
    
    [water setImage:[UIImage imageNamed:@"calwhite"]];
    [view addSubview:water];
    
    UILabel *calLabel = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(water)+5, 0, 0, 0)];
    [calLabel setFont:[UIFont boldSystemFontOfSize:30]];
    [calLabel setText:carl];
    [calLabel sizeToFit];
    [calLabel setTextColor:[UIColor whiteColor]];
    [view addSubview:calLabel];
    
    
    UILabel *ca = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(water)+5, MaxY(calLabel), 100, 14)];
    [ca setFont:[UIFont boldSystemFontOfSize:12]];
    [ca setText:@"卡路里 kcal"];
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
    [km setText:@"均速 km/h"];
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
    _shareButton.layer.cornerRadius = 3;
    [[_shareButton titleLabel] setFont:[UIFont boldSystemFontOfSize:16]];
    [_shareButton setBackgroundColor:RGBCOLOR(97, 187, 162)];
    [_shareButton addTarget:self action:@selector(shareButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_shareButton];
    
    
    if (_completeButton ==nil) {
        _completeButton = [[UIButton alloc] init];
    }
    [_completeButton setFrame:CGRectMake(0, 0, 140, 30)];
    _completeButton.center = CGPointMake(WIDTH(self)/2, MaxY(_shareButton)+35);
    
    [_completeButton setTitle:@"完成" forState:UIControlStateNormal];
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

- (void)mapImageButtonTouch:(UIButton *)sender {
    
    if ([_delegate respondsToSelector:@selector(completeDisplayCard:imageButtouTouch:)]) {
        [_delegate completeDisplayCard:self imageButtouTouch:sender];
    }
}

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
        return [NSString stringWithFormat:@"%0.2ld:%0.2ld:%0.2ld",seconds/3600,seconds/60,seconds%60];
    }
    else
    {
        return [NSString stringWithFormat:@"%0.2ld:%0.2ld",seconds/60,seconds%60];
    }
    return nil;
}


@end
