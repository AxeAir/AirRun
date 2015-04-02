//
//  RunSimpleCardView.m
//  AirRun
//
//  Created by jasonWu on 4/2/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import "RunSimpleCardView.h"

@interface RunSimpleCardView ()

@property (strong, nonatomic) UIView *bgView;

@property (strong, nonatomic) UILabel *distanceLabel;
@property (strong, nonatomic) UILabel *distanceUnitLable;

@property (strong, nonatomic) UILabel *timeLable;
@property (strong, nonatomic) UILabel *timeUnitLable;

@property (strong, nonatomic) UIButton *retractButton;


@end

@implementation RunSimpleCardView

- (void)layoutSubviews {
    
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:self.bounds];
        _bgView.backgroundColor = [UIColor colorWithRed:85/255.0 green:150/255.0 blue:204/255.0 alpha:0.9];
        [self addSubview:_bgView];
    }
    _bgView.frame = self.bounds;
    
    [self p_setLayout];
    
}

- (void)p_setLayout {
    
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
    
    if (!_timeLable) {
        _timeLable = [[UILabel alloc] init];
        _timeLable.text = [self p_getTimeStringWithSeconds:_time];
        _timeLable.textColor = [UIColor whiteColor];
        _timeLable.font = [UIFont systemFontOfSize:20];
        [_timeLable sizeToFit];
        [self addSubview:_timeLable];
    }
    _timeLable.center = CGPointMake(self.bounds.size.width/2-_timeLable.bounds.size.width/2, self.bounds.size.height/2-_timeLable.bounds.size.height/2);

    
    if (!_timeUnitLable) {
        _timeUnitLable = [[UILabel alloc] init];
        _timeUnitLable.text = @"时间";
        _timeUnitLable.textColor = [UIColor whiteColor];
        _timeUnitLable.font = [UIFont systemFontOfSize:14];
        [_timeUnitLable sizeToFit];
        [self addSubview:_timeUnitLable];
    }
    _timeUnitLable.center = CGPointMake(_timeLable.center.x , self.bounds.size.height/2 + _timeUnitLable.bounds.size.height/2);
    
    if (!_retractButton) {
        _retractButton = [UIButton buttonWithType: UIButtonTypeSystem];
        [_retractButton setImage:[UIImage imageNamed:@"setting.png"] forState:UIControlStateNormal];
        [_retractButton setTintColor:[UIColor whiteColor]];
        [_retractButton sizeToFit];
        [self addSubview:_retractButton];
    }
    _retractButton.center = CGPointMake(self.bounds.size.width-15-_retractButton.bounds.size.width/2, self.bounds.size.height/2);
    
    CAShapeLayer *lineLayer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(_retractButton.frame.origin.x-15, 5)];
    [path addLineToPoint:CGPointMake(_retractButton.frame.origin.x-15, self.bounds.size.height-5)];
    lineLayer.lineWidth = 1;
    lineLayer.strokeColor = [UIColor colorWithRed:145/255.0 green:194/255.0 blue:235/255.0 alpha:1].CGColor;
    lineLayer.path = path.CGPath;
    [self.layer addSublayer:lineLayer];
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
