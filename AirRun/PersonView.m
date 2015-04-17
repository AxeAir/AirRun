//
//  PersonView.m
//  AirRun
//
//  Created by JasonWu on 4/9/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import "PersonView.h"

@interface PersonView ()

@property (strong, nonatomic) UIView *bgView;
@property (strong, nonatomic) UIImageView *headImage;
@property (strong, nonatomic) UIButton *infoButton;

@end

@implementation PersonView

- (void)setHeadImg:(UIImage *)headImg {
    _headImg = headImg;
    _headImage.image = headImg;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self p_commonInit];
        
    }
    return self;
}

- (void)p_commonInit {
    
    self.clipsToBounds = YES;
    
    _bgView = [[UIView alloc] initWithFrame:self.bounds];
    _bgView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.3];
    [self addSubview:_bgView];
    
    _headImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 65, 65)];
    _headImage.layer.cornerRadius = _headImage.bounds.size.width/2;
    _headImage.layer.borderColor = [UIColor whiteColor].CGColor;
    _headImage.layer.borderWidth = 1;
    [_headImage setContentScaleFactor:[[UIScreen mainScreen] scale]];
    _headImage.contentMode =  UIViewContentModeScaleAspectFill;
    _headImage.clipsToBounds = YES;
    _headImage.center = CGPointMake(10+_headImage.bounds.size.width/2, self.bounds.size.height/2);
    [self addSubview:_headImage];
    
    _nameLable = [[UILabel alloc] init];
    _nameLable.text = @"叶天雄";
    _nameLable.textColor = [UIColor whiteColor];
    [_nameLable sizeToFit];
    _nameLable.center = CGPointMake(CGRectGetMaxX(_headImage.frame)+10+_nameLable.bounds.size.width/2, self.bounds.size.height/2-_nameLable.bounds.size.height/2);
    [self addSubview:_nameLable];
    
    _engNameLable = [[UILabel alloc] init];
    _engNameLable.text = @"Yeticccc";
    _engNameLable.textColor = [UIColor whiteColor];
    [_engNameLable sizeToFit];
    _engNameLable.center = CGPointMake(CGRectGetMaxX(_headImage.frame)+10+_engNameLable.bounds.size.width/2, self.bounds.size.height/2+_engNameLable.bounds.size.height/2);
    [self addSubview:_engNameLable];
    
    _infoButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_infoButton setImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
    [_infoButton sizeToFit];
    _infoButton.center = CGPointMake(self.bounds.size.width-10-_infoButton.bounds.size.width/2, self.bounds.size.height/2);
    [self addSubview:_infoButton];
    
    _roleLable = [[UILabel alloc] init];
    _roleLable.text = @"产品设计";
    _roleLable.textAlignment = NSTextAlignmentCenter;
    _roleLable.textColor = [UIColor whiteColor];
    [_roleLable sizeToFit];
    _roleLable.center = CGPointMake(_infoButton.frame.origin.x-10-_roleLable.bounds.size.width/2, self.bounds.size.height/2);
    [self addSubview:_roleLable];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
