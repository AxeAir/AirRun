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

@property (nonatomic, strong) RunningRecord *runningRecord;

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

- (instancetype)initWithRunningRecord:(RunningRecord *)aRunningrecord
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
                runningRecord:(RunningRecord *)aRunningrecord
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
    
    
    if (_runningRecord.heart ==nil && [_runningRecord objectForKey:@"heartImages"]==nil) {
        
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
    
    
    
    
//    if (_distanceIconImageView == nil) {
//        _distanceIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, MaxY(_mapImageView)+20, 20, 20)];
//        [_distanceIconImageView setImage:[UIImage imageNamed:@"setting"]];
//        [_mainView addSubview:_distanceIconImageView];
//    }
//    
//    if (_distanceLabel == nil) {
//        _distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(_distanceIconImageView)+10, MaxY(_mapImageView)+20, 100, 20)];
//        [_mainView addSubview:_distanceLabel];
//    }
//    [_distanceLabel setText:[NSString stringWithFormat:@"%ld",_runningRecord.distance]];
//    
//    
//    if (_speedIconImageView == nil) {
//        _speedIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20+Main_Screen_Width/3, MaxY(_mapImageView)+20, 20, 20)];
//        [_speedIconImageView setImage:[UIImage imageNamed:@"setting"]];
//        [_mainView addSubview:_speedIconImageView];
//    }
//    
//    if (_speedLabel == nil) {
//        _speedLabel = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(_speedIconImageView)+10, MaxY(_mapImageView)+20, 100, 20)];
//        [_mainView addSubview:_speedLabel];
//    }
//    [_speedLabel setText:[NSString stringWithFormat:@"%.2lf",_runningRecord.averagespeed]];
//    
//    if (_timeIconImageView == nil) {
//        _timeIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20+Main_Screen_Width/3*2, MaxY(_mapImageView)+20, 20, 20)];
//        [_timeIconImageView setImage:[UIImage imageNamed:@"setting"]];
//        [_mainView addSubview:_timeIconImageView];
//    }
//    
//    if (_timeLabel == nil) {
//        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(_timeIconImageView)+10, MaxY(_mapImageView)+20, 100, 20)];
//        [_mainView addSubview:_timeLabel];
//    }
//    [_timeLabel setText:[NSString stringWithFormat:@"%ld",_runningRecord.time]];
//    
//    
//    if (_heartLabel == nil) {
//        _heartLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, MaxY(_mapImageView)+100+10, Main_Screen_Width-30, 50)];
//        [_mainView addSubview:_heartLabel];
//        [_heartLabel setNumberOfLines:0];
//    }
//    
//    [_heartLabel setText:@"如果你无法简洁的表达你的想法，那只说明你还不够了解它。如果你无法简洁的表达你的想法，那只说明你还不够了解它。"];
//    [_heartLabel sizeToFit];
//    
//    
//    if (_heartView == nil) {
//        _heartView = [[UIView alloc] initWithFrame:CGRectMake(0, MaxY(_heartLabel), Main_Screen_Width, 50)];
//    }
//    
//    UIImageView *h1 = [[UIImageView alloc] initWithFrame:CGRectMake(15, 2.5, 45, 45)];
//    [h1 setImage:[UIImage imageNamed:@"header1.jpg"]];
//    [_heartView addSubview:h1];
//    [_mainView addSubview:_heartView];
//    
//    
//    _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, MaxY(_heartView), Main_Screen_Width, 40)];
//    
//    [_mainView addSubview:_footerView];
//    
//    [_mainView setFrame:CGRectMake(0, 0, 100, MaxY(_footerView))];
    [self setFrame:CGRectMake(0, 0, 100, MaxY(_footerView)+10)];
}


- (UIView *)createFooterView:(CGFloat)top
{
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, top, Main_Screen_Width, 40)];
    
    UILabel *detailTime = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, 40)];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM月dd日 HH:mm"];
    
    [detailTime setText:@"MM月dd日 HH:mm"];
    [detailTime setTextColor:RGBCOLOR(138, 138, 138)];
    [detailTime setFont:[UIFont systemFontOfSize:14]];
    [footer addSubview:detailTime];
    return footer;
}

- (UIView *)createHeartView:(CGFloat)top
{
    UIView *heart = [[UIView alloc] initWithFrame:CGRectMake(10, top, Main_Screen_Width-40, 200)];
    
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
    
    if ([_runningRecord objectForKey:@"heartImages"]!=nil) {
        _heartImageView = [[UIView alloc] initWithFrame:CGRectMake(0, MaxY(_heartLabel), WIDTH(heart), 80)];
        NSArray *date = [_runningRecord objectForKey:@"heartImages"];
        for (NSObject *o in date) {
            
        }
    }
    else
    {
        _heartImageView = [[UIView alloc] initWithFrame:CGRectMake(0, MaxY(_heartLabel), WIDTH(heart), 0)];
    }
    
    [heart addSubview:_heartImageView];
    [heart setFrame:CGRectMake(10, top, Main_Screen_Width-40, MaxY(_heartImageView))];
    
    return heart;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
