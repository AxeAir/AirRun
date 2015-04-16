//
//  RunPauseView.m
//  AirRun
//
//  Created by jasonWu on 4/3/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import "RunPauseView.h"

const static NSInteger Margin = 15;

@interface RunPauseView ()

@property (strong, nonatomic) UIImageView *bgView;

@property (strong, nonatomic) UILabel *speedLabel;
@property (strong, nonatomic) UILabel *speedUnitLable;

@property (strong, nonatomic) UILabel *timeLable;
@property (strong, nonatomic) UILabel *timeUnitLable;

@property (strong, nonatomic) UILabel *distanceLable;
@property (strong, nonatomic) UILabel *distanceUnitLable;

@property (strong, nonatomic) UILabel *kcalLabel;
@property (strong, nonatomic) UILabel *kcalUnitLabel;

@end

@implementation RunPauseView

- (void)setKcal:(CGFloat)kcal {
    
    _kcal = kcal;
    _kcalLabel.text = [NSString stringWithFormat:@"%.1f",_kcal];
    [_kcalLabel sizeToFit];
    _kcalLabel.center = CGPointMake(_kcalUnitLabel.center.x, self.bounds.size.height/2-_kcalLabel.bounds.size.height/2);
    
}


- (void)setSpeed:(CGFloat)speed {
    
    _speed = speed;
    _speedLabel.text = [NSString stringWithFormat:@"%.1f",_speed*3.6];
    [_speedLabel sizeToFit];
    _speedLabel.center = CGPointMake(_speedUnitLable.center.x, self.bounds.size.height/2-_speedLabel.bounds.size.height/2);
}

- (void)setTime:(NSInteger)time {
    
    _time = time;
    _timeLable.text = [self p_getTimeStringWithSeconds:_time];
    [_timeLable sizeToFit];
   _timeLable.center = CGPointMake(self.bounds.size.width/3+10, self.bounds.size.height/2-_timeLable.bounds.size.height/2);
    
}

- (void)setDistance:(CGFloat)distance {
    
    _distance = distance;
    _distanceLable.text = [NSString stringWithFormat:@"%.2f",_distance/1000.0];
    [_distanceLable sizeToFit];
    _distanceLable.center = CGPointMake(_distanceUnitLable.center.x, self.bounds.size.height/2-_distanceLable.bounds.size.height/2);
}



- (void)layoutSubviews {
    
    [self p_layout];
    
}

- (void)p_layout {
    
    if (!_bgView) {
        _bgView = [[UIImageView alloc] init];
        _bgView.image = [UIImage imageNamed:@"pauseViewBg"];
        [self addSubview:_bgView];
    }
    _bgView.frame = self.bounds;
    
    if (!_speedUnitLable) {
        _speedUnitLable = [[UILabel alloc] init];
        _speedUnitLable.text = @"均速 km/h";
        [_speedUnitLable setAlpha:0.8];
        [self p_commonSetLabel:_speedUnitLable WithFontSize:12];
    }
    _speedUnitLable.center = CGPointMake(Margin+_speedUnitLable.bounds.size.width/2, self.bounds.size.height/2+_speedUnitLable.bounds.size.height/2);
    
    if (!_speedLabel) {
        _speedLabel = [[UILabel alloc] init];
        _speedLabel.text = _time == 0?@"0.0":[NSString stringWithFormat:@"%.1f",_speed*3.6];
        [self p_commonSetLabel:_speedLabel WithFontSize:20];
    }
    _speedLabel.center = CGPointMake(_speedUnitLable.center.x, self.bounds.size.height/2-_speedLabel.bounds.size.height/2);
    
    if (!_timeUnitLable) {
        _timeUnitLable = [[UILabel alloc] init];
        _timeUnitLable.text = @"时间";
        [_timeUnitLable setAlpha:0.8];
        [self p_commonSetLabel:_timeUnitLable WithFontSize:12];
    }
    _timeUnitLable.center = CGPointMake(self.bounds.size.width/3+10, self.bounds.size.height/2+_timeUnitLable.bounds.size.height/2);
    
    if (!_timeLable) {
        _timeLable = [[UILabel alloc] init];
        _timeLable.text = [self p_getTimeStringWithSeconds:_time];
        [self p_commonSetLabel:_timeLable WithFontSize:20];
    }
    _timeLable.center = CGPointMake(_timeUnitLable.center.x, self.bounds.size.height/2-_timeLable.bounds.size.height/2);

    
    if (!_distanceUnitLable) {
        _distanceUnitLable = [[UILabel alloc] init];
        _distanceUnitLable.text = @"距离 km";
        [_distanceLable setAlpha:0.8];
        [self p_commonSetLabel:_distanceUnitLable WithFontSize:12];
    }
    _distanceUnitLable.center = CGPointMake(self.bounds.size.width*2/3-10, self.bounds.size.height/2+_distanceUnitLable.bounds.size.height/2);
    
    if (!_distanceLable) {
        _distanceLable = [[UILabel alloc] init];
        _distanceLable.text = [NSString stringWithFormat:@"%.2f",_distance/1000.0];
        [self p_commonSetLabel:_distanceLable WithFontSize:20];
    }
    _distanceLable.center = CGPointMake(_distanceUnitLable.center.x, self.bounds.size.height/2-_distanceLable.bounds.size.height/2);
    
    if (!_kcalUnitLabel) {
        _kcalUnitLabel = [[UILabel alloc] init];
        _kcalUnitLabel.text = @"卡路里";
        [_kcalUnitLabel setAlpha:0.8];
        [self p_commonSetLabel:_kcalUnitLabel WithFontSize:12];
    }
    _kcalUnitLabel.center = CGPointMake(self.bounds.size.width-Margin-_kcalUnitLabel.bounds.size.width/2, self.bounds.size.height/2+_kcalUnitLabel.bounds.size.height/2);
    
    if (!_kcalLabel) {
        _kcalLabel = [[UILabel alloc] init];
        _kcalLabel.text = @"0.0";
        [self p_commonSetLabel:_kcalLabel WithFontSize:20];
    }
    _kcalLabel.center = CGPointMake(_kcalUnitLabel.center.x, self.bounds.size.height/2-_kcalLabel.bounds.size.height/2);
    
}

- (void)p_commonSetLabel:(UILabel *)label WithFontSize:(CGFloat)size {
    
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:size];
    [label sizeToFit];
    [self addSubview:label];
    
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
