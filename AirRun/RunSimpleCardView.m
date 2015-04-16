//
//  RunSimpleCardView.m
//  AirRun
//
//  Created by jasonWu on 4/2/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import "RunSimpleCardView.h"

@interface RunSimpleCardView ()

@property (strong, nonatomic) UIImageView *bgView;

@property (strong, nonatomic) UILabel *distanceLabel;
@property (strong, nonatomic) UILabel *distanceUnitLable;

@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UILabel *timeUnitLable;

@property (strong, nonatomic) UILabel *speedLabel;
@property (strong, nonatomic) UILabel *speedUnitLable;

@property (strong, nonatomic) UIButton *retractButton;
@property (strong, nonatomic) UIButton *photoButton;


@end

@implementation RunSimpleCardView

- (void)setSpeed:(CGFloat)speed {
    
    _speed = speed;
    _speedLabel.text = [NSString stringWithFormat:@"%.1f",_speed*3.6];
    [_speedLabel sizeToFit];
    _speedLabel.center = CGPointMake(_speedUnitLable.center.x, self.bounds.size.height/2-_speedLabel.bounds.size.height/2);
}

- (void)setTime:(NSInteger)time {
    
    _time = time;
    _timeLabel.text = [self p_getTimeStringWithSeconds:_time];
    [_timeLabel sizeToFit];
    CGFloat width = _photoButton.frame.origin.x - 15;
    _timeLabel.center = CGPointMake(width/2, self.bounds.size.height/2-_timeLabel.bounds.size.height/2);
    
}

- (void)setDistance:(CGFloat)distance {
    
    _distance = distance;
    _distanceLabel.text = [NSString stringWithFormat:@"%.2f",_distance/1000.0];
    [_distanceLabel sizeToFit];
    _distanceLabel.center = CGPointMake(_distanceUnitLable.center.x, self.bounds.size.height/2-_distanceLabel.bounds.size.height/2);
}


- (void)layoutSubviews {
    
    if (!_bgView) {
        _bgView = [[UIImageView alloc] initWithFrame:self.bounds];
        _bgView.image = [UIImage imageNamed:@"runSimpleCardBg"];
        [self addSubview:_bgView];
    }
    _bgView.frame = self.bounds;
    
    [self p_setLayout];
    
}

- (void)p_setLayout {
    
    if (!_photoButton) {
        _photoButton = [UIButton buttonWithType: UIButtonTypeSystem];
        [_photoButton setImage:[UIImage imageNamed:@"camera.png"] forState:UIControlStateNormal];
        [_photoButton setTintColor:[UIColor whiteColor]];
        [_photoButton sizeToFit];
        [self addSubview:_photoButton];
        [_photoButton addTarget:self action:@selector(photoButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
    }
    _photoButton.center = CGPointMake(self.bounds.size.width-15-_photoButton.bounds.size.width/2, self.bounds.size.height/2);
    
    if (!_distanceUnitLable) {
        _distanceUnitLable = [[UILabel alloc] init];
        _distanceUnitLable.text = @"距离km";
        _distanceUnitLable.textColor = [UIColor whiteColor];
        _distanceUnitLable.font = [UIFont systemFontOfSize:14];
        [_distanceUnitLable sizeToFit];
        [self addSubview:_distanceUnitLable];
    }
    _distanceUnitLable.center = CGPointMake(15+_distanceUnitLable.bounds.size.width/2, self.bounds.size.height/2+_distanceUnitLable.bounds.size.height/2);
    
    if (!_distanceLabel) {
        _distanceLabel = [[UILabel alloc] init];
        _distanceLabel.text = _distanceLabel.text = [NSString stringWithFormat:@"%.2f",_distance/1000.0];
        _distanceLabel.font = [UIFont systemFontOfSize:20];
        _distanceLabel.textColor = [UIColor whiteColor];
        [_distanceLabel sizeToFit];
        [self addSubview:_distanceLabel];
    }
    _distanceLabel.center = CGPointMake(_distanceUnitLable.center.x, self.bounds.size.height/2-_distanceLabel.bounds.size.height/2);
    
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.text = [self p_getTimeStringWithSeconds:_time];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.font = [UIFont systemFontOfSize:20];
        [_timeLabel sizeToFit];
        [self addSubview:_timeLabel];
    }
    CGFloat width = _photoButton.frame.origin.x - 15;
    _timeLabel.center = CGPointMake(width/2, self.bounds.size.height/2-_timeLabel.bounds.size.height/2);

    
    if (!_timeUnitLable) {
        _timeUnitLable = [[UILabel alloc] init];
        _timeUnitLable.text = @"时间";
        _timeUnitLable.textColor = [UIColor whiteColor];
        _timeUnitLable.font = [UIFont systemFontOfSize:14];
        [_timeUnitLable sizeToFit];
        [self addSubview:_timeUnitLable];
    }
    _timeUnitLable.center = CGPointMake(width/2 , self.bounds.size.height/2 + _timeUnitLable.bounds.size.height/2);
    
    
    if (!_speedUnitLable) {
        _speedUnitLable = [[UILabel alloc] init];
        _speedUnitLable.text = @"平均速度";
        _speedUnitLable.textColor = [UIColor whiteColor];
        _speedUnitLable.font = [UIFont systemFontOfSize:14];
        [_speedUnitLable sizeToFit];
        [self addSubview:_speedUnitLable];
    }
    _speedUnitLable.center = CGPointMake(_photoButton.frame.origin.x-18-_speedUnitLable.bounds.size.width/2, self.bounds.size.height/2+_speedUnitLable.bounds.size.height/2);
    
    if (!_speedLabel) {
        _speedLabel = [[UILabel alloc] init];
        _speedLabel.text = [NSString stringWithFormat:@"%.1f",_speed*3.6];
        _speedLabel.textColor = [UIColor whiteColor];
        _speedLabel.font = [UIFont systemFontOfSize:20];
        [_speedLabel sizeToFit];
        [self addSubview:_speedLabel];
    }
    _speedLabel.center = CGPointMake(_speedUnitLable.center.x, self.bounds.size.height/2-_speedLabel.bounds.size.height/2);
    
    if (!_retractButton) {
        _retractButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_retractButton setImage:[UIImage imageNamed:@"narrowup"] forState:UIControlStateNormal];
        [_retractButton addTarget:self action:@selector(retractButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_retractButton];
    }
    _retractButton.frame = CGRectMake(0, self.bounds.size.height-15, self.bounds.size.width, 15);
    
    CAShapeLayer *lineLayer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(_retractButton.frame.origin.x-15, 5)];
    [path addLineToPoint:CGPointMake(_retractButton.frame.origin.x-15, self.bounds.size.height-5)];
    lineLayer.lineWidth = 1;
    lineLayer.strokeColor = [UIColor colorWithRed:145/255.0 green:194/255.0 blue:235/255.0 alpha:1].CGColor;
    lineLayer.path = path.CGPath;
    [self.layer addSublayer:lineLayer];
}

#pragma mark - Event
#pragma mark - Button Event;

- (void)photoButtonTouch:(UIButton *)sender {
    if (_photoButtonBlock) {
        _photoButtonBlock(sender);
    }
}

- (void)retractButtonTouch:(UIButton *)sender {
    
    if (_retractButtonBlock) {
        _retractButtonBlock(sender);
    }
    
}

#pragma mark - Action
- (NSString *)p_getTimeStringWithSeconds:(NSInteger)seconds {
    
    NSInteger tempSeconds = seconds;
    
    NSString *hourStr = @"";
    NSInteger hour = seconds/(60*60);
    tempSeconds %= (60 * 60);
    if (hour > 0) {
        
        if (hour >= 10) {
            hourStr = [NSString stringWithFormat:@"%ld:",(long)hour];
        } else {
            hourStr = [NSString stringWithFormat:@"0%ld:",(long)hour];
        }
        
    }
    
    NSString *minuteStr = @"";
    NSInteger minute = tempSeconds/60;
    tempSeconds %= 60;
    if (minute < 10) {
        minuteStr = [NSString stringWithFormat:@"0%ld:",(long)minute];
    } else {
        minuteStr = [NSString stringWithFormat:@"%ld:",(long)minute];
    }
    
    NSString *secondsStr = @"";
    if (tempSeconds < 10) {
        secondsStr = [NSString stringWithFormat:@"0%ld",(long)tempSeconds];
    } else {
        secondsStr = [NSString stringWithFormat:@"%ld",(long)tempSeconds];
    }
    
    return [NSString stringWithFormat:@"%@%@%@",hourStr,minuteStr,secondsStr];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
