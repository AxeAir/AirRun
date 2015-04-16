//
//  WeatherTitleView.m
//  AirRun
//
//  Created by JasonWu on 4/17/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import "WeatherTitleView.h"

@interface WeatherTitleView ()

@property (strong, nonatomic) UIImage *weatherImg;
@property (strong, nonatomic) NSString *weatherText;
@property (strong, nonatomic) NSString *pmText;

@property (strong, nonatomic) UIImageView *weatherImage;
@property (strong, nonatomic) UILabel *weatherLable;
@property (strong, nonatomic) UILabel *pmLable;

@end

@implementation WeatherTitleView

- (instancetype)initWithImage:(UIImage *)weatherImage WithWeatherString:(NSString *)weatherString WithPMString:(NSString *)pmString {
    self = [super init];
    if (self) {
        _weatherImg = weatherImage;
        _weatherText = weatherString;
        _pmText = pmString;
        
        [self p_commonInit];
    }
    return self;
}

- (void)p_commonInit {
    _weatherImage = [[UIImageView alloc] initWithImage:_weatherImg];
    [self addSubview:_weatherImage];
    
    _weatherLable = [[UILabel alloc] init];
    _weatherLable.text = _weatherText;
    _weatherLable.font = [UIFont systemFontOfSize:12];
    _weatherLable.textColor = [UIColor whiteColor];
    [_weatherLable sizeToFit];
    _weatherLable.center = CGPointMake(_weatherImage.frame.size.width + 3 +_weatherLable.bounds.size.width/2,  _weatherImage.frame.size.height/2-_weatherLable.bounds.size.height/2);
    [self addSubview:_weatherLable];
    
    _pmLable = [[UILabel alloc] init];
    _pmLable.text = _pmText;
    _pmLable.font = [UIFont systemFontOfSize:12];
    _pmLable.textColor = [UIColor whiteColor];
    [_pmLable sizeToFit];
    _pmLable.center = CGPointMake(_weatherImage.frame.size.width+3+_pmLable.bounds.size.width/2,  _weatherImage.frame.size.height/2+_pmLable.bounds.size.height/2);
    [self addSubview:_pmLable];
    
    CGFloat height = _weatherImage.frame.size.height > CGRectGetMaxY(_pmLable.frame)?_weatherImage.frame.size.height:CGRectGetMaxY(_pmLable.frame);
    CGFloat width = CGRectGetMaxX(_weatherLable.frame)>CGRectGetMaxX(_pmLable.frame)?CGRectGetMaxX(_weatherLable.frame):CGRectGetMaxX(_pmLable.frame);
    self.frame = CGRectMake(0, 0, width, height);
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
