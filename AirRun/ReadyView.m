//
//  ReadyView.m
//  AirRun
//
//  Created by JasonWu on 4/8/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import "ReadyView.h"

@interface ReadyView ()

@property (strong, nonatomic) UIImageView *bgImage;

@property (strong, nonatomic) UIView *divideView;

@property (strong, nonatomic) UILabel *textLable;
@property (strong, nonatomic) NSString *text;

@end

@implementation ReadyView

- (instancetype)initWithText:(NSString *)text {
    self = [super init];
    if (self) {
        _text = text;
        [self p_commonInit];
    }
    return  self;
}

- (void)p_commonInit {
    
    _bgImage = [[UIImageView alloc] initWithFrame:self.bounds];
    _bgImage.image = [UIImage imageNamed:@"bg1.png"];
//    [_bgImage setContentScaleFactor:[[UIScreen mainScreen] scale]];
//    _bgImage.contentMode =  UIViewContentModeScaleAspectFill;
    _bgImage.contentMode = UIViewContentModeScaleToFill;
    [self addSubview:_bgImage];
    
    _divideView = [[UIView alloc] initWithFrame:CGRectMake(15, 0, self.bounds.size.width-30, 1)];
    _divideView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_divideView];
    
    _textLable = [[UILabel alloc] init];
    _textLable.text = _text;
    [_textLable sizeToFit];
    _textLable.textColor = [UIColor whiteColor];
    [self addSubview:_textLable];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _divideView.frame = CGRectMake(15, 0, self.bounds.size.width-30, 1);
    _textLable.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    _bgImage.frame = self.bounds;
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
