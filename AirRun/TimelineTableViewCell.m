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
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIView *heartView;
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
    if (_headerView ==nil) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 0)];
        [self.contentView addSubview:_headerView];
    }
    [_headerView setBackgroundColor:RGBCOLOR(128, 199, 237)];
    
    if (_mapImageView == nil) {
        _mapImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, MaxY(_headerView), Main_Screen_Width, 330)];
        [self.contentView addSubview:_mapImageView];
    }
    [_mapImageView setImage:[UIImage imageNamed:@"map.jpg"]];
    
    
    if (_distanceIconImageView == nil) {
        _distanceIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, MaxY(_mapImageView)+20, 20, 20)];
        [_distanceIconImageView setImage:[UIImage imageNamed:@"setting"]];
        [self.contentView addSubview:_distanceIconImageView];
    }
    
    if (_distanceLabel == nil) {
        _distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(_distanceIconImageView)+10, MaxY(_mapImageView)+20, 100, 20)];
        [self.contentView addSubview:_distanceLabel];
    }
    [_distanceLabel setText:[NSString stringWithFormat:@"%ld",_runningRecord.distance]];
    
    
    if (_speedIconImageView == nil) {
        _speedIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20+Main_Screen_Width/3, MaxY(_mapImageView)+20, 20, 20)];
        [_speedIconImageView setImage:[UIImage imageNamed:@"setting"]];
        [self.contentView addSubview:_speedIconImageView];
    }
    
    if (_speedLabel == nil) {
        _speedLabel = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(_speedIconImageView)+10, MaxY(_mapImageView)+20, 100, 20)];
        [self.contentView addSubview:_speedLabel];
    }
    [_speedLabel setText:[NSString stringWithFormat:@"%.2lf",_runningRecord.averagespeed]];
    
    if (_timeIconImageView == nil) {
        _timeIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20+Main_Screen_Width/3*2, MaxY(_mapImageView)+20, 20, 20)];
        [_timeIconImageView setImage:[UIImage imageNamed:@"setting"]];
        [self.contentView addSubview:_timeIconImageView];
    }
    
    if (_timeLabel == nil) {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(_timeIconImageView)+10, MaxY(_mapImageView)+20, 100, 20)];
        [self.contentView addSubview:_timeLabel];
    }
    [_timeLabel setText:[NSString stringWithFormat:@"%ld",_runningRecord.time]];
    
    
    if (_heartLabel == nil) {
        _heartLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, MaxY(_mapImageView)+100+10, Main_Screen_Width-30, 50)];
        [self.contentView addSubview:_heartLabel];
        [_heartLabel setNumberOfLines:0];
    }
    
    [_heartLabel setText:@"如果你无法简洁的表达你的想法，那只说明你还不够了解它。如果你无法简洁的表达你的想法，那只说明你还不够了解它。"];
    [_heartLabel sizeToFit];
    
    
    if (_heartView == nil) {
        _heartView = [[UIView alloc] initWithFrame:CGRectMake(0, MaxY(_heartLabel), Main_Screen_Width, 50)];
    }
    
    UIImageView *h1 = [[UIImageView alloc] initWithFrame:CGRectMake(15, 2.5, 45, 45)];
    [h1 setImage:[UIImage imageNamed:@"header1.jpg"]];
    [_heartView addSubview:h1];
    [self addSubview:_heartView];
    
    
    _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, MaxY(_heartView), Main_Screen_Width, 40)];
    
    [self addSubview:_footerView];
    
    [self setFrame:CGRectMake(0, 0, 100, MaxY(_footerView))];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
