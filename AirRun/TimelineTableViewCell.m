//
//  TimelineTableViewCell.m
//  AirRun
//
//  Created by ChenHao on 4/4/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import "TimelineTableViewCell.h"
#import "UConstants.h"

@interface TimelineTableViewCell()

@property (nonatomic, strong) RunningRecordEntity *runningRecord;

@property (nonatomic, strong) UIView *mainView;

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIView *heartView;
@property (nonatomic, strong) UIView *heartImageView;
@property (nonatomic, strong) UIView *footerView;

@property (nonatomic, strong) UIImageView *mapImageView;

@property (nonatomic, strong) UIImageView *distanceIconImageView;
@property (nonatomic, strong) UIImageView *speedIconImageView;
@property (nonatomic, strong) UIImageView *timeIconImageView;
@property (nonatomic, strong) UIImageView *kcalIconImageView;

@property (nonatomic, strong) UILabel *distanceLabel;
@property (nonatomic, strong) UILabel *speedLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *kcalLabel;

@property (nonatomic, strong) UILabel *heartLabel;

@end


@implementation TimelineTableViewCell

- (instancetype)initWithRunningRecord:(RunningRecordEntity *)aRunningrecord
{
    self = [self init];
    if (self) {
        _runningRecord = aRunningrecord;
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
                runningRecord:(RunningRecordEntity *)aRunningrecord
{
    self = [self initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _runningRecord = aRunningrecord;
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    _mainView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, Main_Screen_Width-20, 200)];
    
    [_mainView setBackgroundColor:RGBACOLOR(252, 248, 240, 1)];
    [[_mainView layer] setCornerRadius:4];
    [[_mainView layer] setMasksToBounds:YES];
    [self.contentView addSubview:_mainView];
    if (_headerView ==nil) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(_mainView), 50)];
        [_mainView addSubview:_headerView];
    }
    
    if (_mapImageView == nil) {
        _mapImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, MaxY(_headerView), WIDTH(_mainView)-20, 150)];
        [_mainView addSubview:_mapImageView];
    }
    [_mapImageView setImage:[UIImage imageNamed:@"map.jpg"]];
    
    [_mapImageView addSubview:[self createDataView]];
    
    
    if (_runningRecord.heart ==nil && _runningRecord.heartimages==nil) {
        
        _footerView = [self createFooterView:MaxY(_mapImageView)];
        
        [_mainView addSubview:_footerView];
        [_mainView setFrame:CGRectMake(10, 10, Main_Screen_Width-20, MaxY(_footerView))];
        [self setFrame:CGRectMake(0, 0, WIDTH(_mainView), MaxY(_footerView))];
    }
    else
    {
        _heartView = [self createHeartView:MaxY(_mapImageView)];
        [_mainView addSubview:_heartView];
        
        _footerView = [self createFooterView:MaxY(_heartView)];
        
        [_mainView addSubview:_footerView];
        [_mainView setFrame:CGRectMake(10, 10, Main_Screen_Width-20, MaxY(_footerView))];
        [self setFrame:CGRectMake(0, 0, WIDTH(_mainView), MaxY(_footerView))];
    }
    
    [self setFrame:CGRectMake(0, 0, 100, MaxY(_footerView)+20)];
}


- (UIView *)createDataView
{
    UIView *dataview = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT(_mapImageView)-36, WIDTH(_mapImageView), 36)];
    
    UIView *bgMask = [[UIView alloc] initWithFrame:CGRectMake(0, 0, dataview.frame.size.width, dataview.frame.size.height)];
    [bgMask setBackgroundColor:RGBACOLOR(107, 107, 107, 0.6)];
    [dataview addSubview:bgMask];
        if (_distanceIconImageView == nil) {
            _distanceIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20,8, 20, 20)];
            [_distanceIconImageView setImage:[UIImage imageNamed:@"setting"]];
            [dataview addSubview:_distanceIconImageView];
        }
    
        if (_distanceLabel == nil) {
            _distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(_distanceIconImageView)+10, 8, 100, 20)];
            [_distanceLabel setTextColor:RGBCOLOR(207, 207, 207)];
            [dataview addSubview:_distanceLabel];
        }
        [_distanceLabel setText:[NSString stringWithFormat:@"%ld",[_runningRecord.distance integerValue]]];
    
    
        if (_speedIconImageView == nil) {
            _speedIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20+(Main_Screen_Width-40)/3, 8, 20, 20)];
            [_speedIconImageView setImage:[UIImage imageNamed:@"setting"]];
            [dataview addSubview:_speedIconImageView];
        }
    
        if (_speedLabel == nil) {
            _speedLabel = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(_speedIconImageView)+10, 8, 100, 20)];
            [_speedLabel setTextColor:RGBCOLOR(207, 207, 207)];
            [dataview addSubview:_speedLabel];
        }
        [_speedLabel setText:[NSString stringWithFormat:@"%.2lf",[_runningRecord.averagespeed floatValue]]];
    
        if (_timeIconImageView == nil) {
            _timeIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20+(Main_Screen_Width-40)/3*2, 8, 20, 20)];
            [_timeIconImageView setImage:[UIImage imageNamed:@"setting"]];
            [dataview addSubview:_timeIconImageView];
        }
    
        if (_timeLabel == nil) {
            _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(_timeIconImageView)+10, 8, 100, 20)];
            [_timeLabel setTextColor:RGBCOLOR(207, 207, 207)];
            [dataview addSubview:_timeLabel];
        }
        [_timeLabel setText:[NSString stringWithFormat:@"%ld",[_runningRecord.time integerValue]]];
        
    
    
    
    
    return dataview;
}


- (UIView *)createFooterView:(CGFloat)top
{
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, top, Main_Screen_Width, 40)];
    
    UILabel *detailTime = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, 40)];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM月dd日 HH:mm"];
    
    [detailTime setText:[formatter stringFromDate:_runningRecord.finishtime]];
    [detailTime setTextColor:RGBCOLOR(138, 138, 138)];
    [detailTime setFont:[UIFont systemFontOfSize:14]];
    [footer addSubview:detailTime];
    
    
    
    UIView *location = [self createLocationView];
    [location setFrame:CGRectMake(Main_Screen_Width-75-30, 10, 75, 20)];
    [footer addSubview:location];
    
    return footer;
}

- (UIView *)createHeartView:(CGFloat)top
{
    UIView *heart = [[UIView alloc] initWithFrame:CGRectMake(30, top, Main_Screen_Width-80, 200)];
    
    UILabel *runningRecord = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, WIDTH(heart), 20)];
    runningRecord.text = @"跑步记录";
    [runningRecord setFont:[UIFont boldSystemFontOfSize:14]];
    [runningRecord setTextColor:RGBCOLOR(170, 170, 170)];
    [runningRecord setTextAlignment:NSTextAlignmentCenter];
    [heart addSubview:runningRecord];
    
    if(_runningRecord.heart !=nil)
    {
        _heartLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, MaxY(runningRecord)+5, WIDTH(heart), 20)];
        _heartLabel.text = _runningRecord.heart;
        [_heartLabel setFont:[UIFont systemFontOfSize:14]];
        [_heartLabel setTextColor:RGBCOLOR(143, 143, 143)];
        _heartLabel.numberOfLines = 0;
        [_heartLabel sizeToFit];
        
    }
    else
    {
        _heartLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, MaxY(runningRecord), WIDTH(heart), 0)];
    }
    [heart addSubview:_heartLabel];
    
    if ([[_runningRecord getImages] count]!=0) {
        _heartImageView = [[UIView alloc] initWithFrame:CGRectMake(0, MaxY(_heartLabel), WIDTH(heart), 80)];
        
        NSArray *date = [_runningRecord getImages];
        
        NSInteger imagewidth = (Main_Screen_Width-80-40)/5;
        
        NSInteger index= 0;
        for (NSObject *o in date) {
            UIImageView *view = [[UIImageView alloc] initWithImage:(UIImage*)o];
            [view setFrame:CGRectMake((imagewidth+10)*index, 12.5, imagewidth, imagewidth)];
            [[view layer] setCornerRadius:5];
            [[view layer] setMasksToBounds:YES];
            [_heartImageView addSubview:view];
            index ++;
        }
    }
    else
    {
        _heartImageView = [[UIView alloc] initWithFrame:CGRectMake(0, MaxY(_heartLabel), WIDTH(heart), 0)];
    }
    
    [heart addSubview:_heartImageView];
    [heart setFrame:CGRectMake(30, top, Main_Screen_Width-80, MaxY(_heartImageView))];
    
    return heart;
}

- (UIView *)createLocationView
{
    UIView *location = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 75, 20)];
    [location setBackgroundColor:RGBCOLOR(237, 237, 237)];
    
    UIImageView *locationImageView = [[UIImageView alloc] initWithFrame:CGRectMake(3, 3, 14, 14)];
    [location addSubview:locationImageView];
    
    UILabel *cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(locationImageView)+3, 3, 100, 14)];
    
    cityLabel.text = _runningRecord.city;
    [cityLabel setTextColor:RGBCOLOR(237, 237, 237)];
    [cityLabel setFont:[UIFont systemFontOfSize:12]];
    [location addSubview:cityLabel];
    return location;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
