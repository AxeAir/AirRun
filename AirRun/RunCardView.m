//
//  RunCardView.m
//  Run
//
//  Created by jasonWu on 4/1/15.
//  Copyright (c) 2015 jasonWu. All rights reserved.
//

#import "RunCardView.h"

const static NSInteger kTopCenterViewMargin = 30;

@interface RunCardView ()

@property (strong, nonatomic) UIImageView *bgView;

///
@property (strong, nonatomic) UIView *topView;
@property (strong, nonatomic) UILabel *gpsLable;
@property (strong, nonatomic) UILabel *distanceLabel;
@property (strong, nonatomic) UILabel *distanceUnitLabel;
@property (strong, nonatomic) CAShapeLayer *topLineLayer;

///
@property (strong, nonatomic) UIView *centerView;
@property (strong, nonatomic) UILabel *speedLabel;
@property (strong, nonatomic) UILabel *speedUnitLabel;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UILabel *timeUnitLabel;
@property (strong, nonatomic) UILabel *kcalLabel;
@property (strong, nonatomic) UILabel *kcalUnitLabel;
@property (strong, nonatomic) CAShapeLayer *centerLineLayer;

///
@property (strong, nonatomic) UIView *bottomView;
@property (strong, nonatomic) UIButton *photoButton;
@property (strong, nonatomic) UIButton *retractButton;
@property (strong, nonatomic) CAShapeLayer *divedLineLayer;

@end

@implementation RunCardView

#pragma mark - Set Method

- (void)setSpeed:(CGFloat)speed {
    
    _speed = speed;
    _speedLabel.text = [NSString stringWithFormat:@"%.1f",_speed*3.6];
    [_speedLabel sizeToFit];
    _speedLabel.center = CGPointMake(_speedUnitLabel.center.x, _centerView.bounds.size.height/2-_speedLabel.bounds.size.height/2);
}

- (void)setTime:(NSInteger)time {
    
    _time = time;
    _timeLabel.text = [self p_getTimeStringWithSeconds:_time];
    [_timeLabel sizeToFit];
    _timeLabel.center = CGPointMake(_centerView.bounds.size.width/2, _centerView.bounds.size.height/2 - _timeLabel.bounds.size.height/2);
    
}

- (void)setKcal:(CGFloat)kcal {
    
    _kcal = kcal;
    _kcalLabel.text = [NSString stringWithFormat:@"%.1f",_kcal];
    [_kcalLabel sizeToFit];
    _kcalLabel.center = CGPointMake(_kcalUnitLabel.center.x , _centerView.bounds.size.height/2-_kcalLabel.bounds.size.height/2);
}

- (void)setDistance:(CGFloat)distance {
    
    _distance = distance;
    _distanceLabel.text = [NSString stringWithFormat:@"%.2f",_distance/1000.0];
    [_distanceLabel sizeToFit];
    _distanceLabel.center = CGPointMake(_topView.bounds.size.width/2, _topView.bounds.size.height/2-_distanceLabel.bounds.size.height/3);
}

#pragma mark - Layout
- (void)layoutSubviews {
    
    if (!_bgView) {
        _bgView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:_bgView];
    }
    _bgView.frame = self.bounds;
    _bgView.image = [UIImage imageNamed:@"runcardviewbg"];
    
    [self p_setTopViewLayout];
    
    [self p_setCenterViewLayout];
    
    [self p_setBottomViewLayout];
    
}

- (void)p_setTopViewLayout {//0.35高度
    
    if (!_topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(kTopCenterViewMargin, 0, self.bounds.size.width - kTopCenterViewMargin*2, self.bounds.size.height*0.35)];
        [self addSubview:_topView];
    }
    _topView.frame = CGRectMake(kTopCenterViewMargin, 0, self.bounds.size.width - kTopCenterViewMargin*2, self.bounds.size.height*0.35);
    
    if (!_distanceLabel) {
        _distanceLabel = [[UILabel alloc] init];
        _distanceLabel.text = [NSString stringWithFormat:@"%.2f",_distance/1000.0];
        _distanceLabel.font = [UIFont systemFontOfSize:30];
        _distanceLabel.textColor = [UIColor whiteColor];
        [_distanceLabel sizeToFit];
        [_topView addSubview:_distanceLabel];
    }
    _distanceLabel.center = CGPointMake(_topView.bounds.size.width/2, _topView.bounds.size.height/2-_distanceLabel.bounds.size.height/3);
    
//    if (!_gpsLable) {
//        _gpsLable = [[UILabel alloc] init];
//        _gpsLable.text = @"GPS";
//        _gpsLable.textColor = [UIColor greenColor];
//        _gpsLable.font = [UIFont systemFontOfSize:14];
//        [_gpsLable sizeToFit];
//        [_topView addSubview:_gpsLable];
//    }
//    _gpsLable.center = CGPointMake(_topView.bounds.size.width-_gpsLable.bounds.size.width/2, _distanceLabel.frame.origin.y+ _gpsLable.bounds.size.height/2);

    if (!_distanceUnitLabel) {
        _distanceUnitLabel = [[UILabel alloc] init];
        _distanceUnitLabel.text = @"距离 km";
        _distanceUnitLabel.font = [UIFont systemFontOfSize:13];
        _distanceUnitLabel.textColor = [UIColor whiteColor];
        [_distanceUnitLabel setAlpha:0.8];
        [_distanceUnitLabel sizeToFit];
        [_topView addSubview:_distanceUnitLabel];
    }
   _distanceUnitLabel.center = CGPointMake(_topView.bounds.size.width/2, CGRectGetMaxY(_distanceLabel.frame) + _distanceUnitLabel.frame.size.height/2);
    
    
    if (_topLineLayer) {
        [_topLineLayer removeFromSuperlayer];
    }
    _topLineLayer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, _topView.bounds.size.height)];
    [path addLineToPoint:CGPointMake(_topView.bounds.size.width, _topView.bounds.size.height)];
    
    _topLineLayer.strokeColor = [UIColor colorWithRed:73/255.0 green:158/255.0 blue:227/255.0 alpha:0.6].CGColor;
    _topLineLayer.lineWidth = 1;
    _topLineLayer.path = path.CGPath;
    [_topView.layer addSublayer:_topLineLayer];
    
}

- (void)p_setCenterViewLayout {//0.35
    
    if (!_centerView) {
        _centerView = [[UIView alloc] initWithFrame:CGRectMake(kTopCenterViewMargin, CGRectGetMaxY(_topView.frame), self.bounds.size.width-kTopCenterViewMargin*2, self.bounds.size.height*0.35)];
        [self addSubview:_centerView];
    }
    _centerView.frame = CGRectMake(kTopCenterViewMargin, CGRectGetMaxY(_topView.frame), self.bounds.size.width-kTopCenterViewMargin*2, self.bounds.size.height*0.35);
    
    if (!_speedUnitLabel) {
        _speedUnitLabel = [[UILabel alloc] init];
        _speedUnitLabel.text = @"均速 km/h";
        [_speedUnitLabel setAlpha:0.8];
        _speedUnitLabel.textColor = [UIColor whiteColor];
        _speedUnitLabel.font = [UIFont systemFontOfSize:13];
        [_speedUnitLabel sizeToFit];
        [_centerView addSubview:_speedUnitLabel];
    }
    _speedUnitLabel.center = CGPointMake(_speedUnitLabel.bounds.size.width/2, _centerView.bounds.size.height/2 + _speedUnitLabel.bounds.size.height/2);
    
    if (!_speedLabel) {
        _speedLabel = [[UILabel alloc] init];
        _speedLabel.text = _time == 0?@"0.0":[NSString stringWithFormat:@"%.1f",_speed*3.6];
        _speedLabel.textColor = [UIColor whiteColor];
        _speedLabel.font = [UIFont systemFontOfSize:20];
        [_speedLabel sizeToFit];
        [_centerView addSubview:_speedLabel];
    }
    _speedLabel.center = CGPointMake(_speedUnitLabel.center.x, _centerView.bounds.size.height/2-_speedLabel.bounds.size.height/2);
    
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.text = [self p_getTimeStringWithSeconds:_time];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.font = [UIFont systemFontOfSize:20];
        [_timeLabel sizeToFit];
        [_centerView addSubview:_timeLabel];
    }
    _timeLabel.center = CGPointMake(_centerView.bounds.size.width/2, _centerView.bounds.size.height/2 - _timeLabel.bounds.size.height/2);
    
    if (!_timeUnitLabel) {
        _timeUnitLabel = [[UILabel alloc] init];
        _timeUnitLabel.text = @"时间";
        [_timeUnitLabel setAlpha:0.8];
        [_timeUnitLabel sizeToFit];
        _timeUnitLabel.textColor = [UIColor whiteColor];
        _timeUnitLabel.font = [UIFont systemFontOfSize:14];
        [_centerView addSubview:_timeUnitLabel];

    }
    _timeUnitLabel.center = CGPointMake(_centerView.bounds.size.width/2, _centerView.bounds.size.height/2+_timeUnitLabel.bounds.size.height/2);
    
    if (!_kcalUnitLabel) {
        _kcalUnitLabel = [[UILabel alloc] init];
        _kcalUnitLabel.textColor = [UIColor whiteColor];
        _kcalUnitLabel.text = @"卡路里";
        [_kcalUnitLabel setAlpha:0.8];
        _kcalUnitLabel.font = [UIFont systemFontOfSize:14];
        [_kcalUnitLabel sizeToFit];
        [_centerView addSubview:_kcalUnitLabel];
    }
    _kcalUnitLabel.center = CGPointMake(_centerView.bounds.size.width-_kcalUnitLabel.bounds.size.width/2, _centerView.bounds.size.height/2+_kcalUnitLabel.bounds.size.height/2);
    
    if (!_kcalLabel) {
        _kcalLabel = [[UILabel alloc] init];
        _kcalLabel.text = [NSString stringWithFormat:@"%.1f",_kcal];
        _kcalLabel.textColor = [UIColor whiteColor];
        _kcalLabel.font = [UIFont systemFontOfSize:20];
        [_kcalLabel sizeToFit];
        [_centerView addSubview:_kcalLabel];
    }
    _kcalLabel.center = CGPointMake(_kcalUnitLabel.center.x , _centerView.bounds.size.height/2-_kcalLabel.bounds.size.height/2);
    
    
    if (_centerLineLayer) {
        [_centerLineLayer removeFromSuperlayer];
    }
    _centerLineLayer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, _centerView.bounds.size.height)];
    [path addLineToPoint:CGPointMake(_centerView.bounds.size.width, _centerView.bounds.size.height)];
    
    _centerLineLayer.strokeColor = [UIColor colorWithRed:73/255.0 green:158/255.0 blue:227/255.0 alpha:0.6].CGColor;
    _centerLineLayer.lineWidth = 1;
    _centerLineLayer.path = path.CGPath;
    [_centerView.layer addSublayer:_centerLineLayer];
    
}

- (void)p_setBottomViewLayout {
    
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_centerView.frame), self.bounds.size.width, self.bounds.size.height-5-CGRectGetMaxY(_centerView.frame))];
        [self addSubview:_bottomView];
    }
    _bottomView.frame =CGRectMake(0, CGRectGetMaxY(_centerView.frame), self.bounds.size.width, self.bounds.size.height-5-CGRectGetMaxY(_centerView.frame));
    
    if (!_retractButton) {
        _retractButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_retractButton setImage:[UIImage imageNamed:@"narrowup"] forState:UIControlStateNormal];
        [_retractButton addTarget:self action:@selector(retractButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
        [_retractButton sizeToFit];
        [_bottomView addSubview:_retractButton];
    }
    _retractButton.frame = CGRectMake(0, _bottomView.bounds.size.height-15, _bottomView.frame.size.width, 15);
    
}

#pragma mark - Event
#pragma mark Button Event

- (void)photoButtonTouch:(UIButton *)sender {
    if (_photoTouchBlock) {
        _photoTouchBlock(sender);
    }
}

- (void)retractButtonTouch:(UIButton *)sender {
    
    if (_retractTouchBlock) {
        _retractTouchBlock(sender);
    }
    
}

#pragma mark - Function

#pragma mark Private Function
- (void)p_addUnderLineAtView:(UIView *)view WithColor:(UIColor *)color {
    
    CAShapeLayer *lineLayer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, view.bounds.size.height)];
    [path addLineToPoint:CGPointMake(view.bounds.size.width, view.bounds.size.height)];
    
    lineLayer.strokeColor = color.CGColor;
    lineLayer.lineWidth = 1;
    lineLayer.path = path.CGPath;
    [view.layer addSublayer:lineLayer];
    
}

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
