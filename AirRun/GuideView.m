//
//  GuideView.m
//  AirRun
//
//  Created by JasonWu on 4/8/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import "GuideView.h"

@interface GuideView ()

@property (strong, nonatomic) UIButton *closeButton;
@property (strong, nonatomic) UILabel *titleLable;
@property (strong, nonatomic) UITextView *textView;

@end

@implementation GuideView

#pragma mark - Set

- (void)setContent:(NSString *)content {
    _content = content;
    _textView.text = _content;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    _titleLable.text = _title;
    [_titleLable sizeToFit];
    _titleLable.center = CGPointMake(self.bounds.size.width/2, 30+_titleLable.bounds.size.height/2);
}

#pragma mark - Init
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self p_commonInit];
    }
    return self;
}

- (void)p_commonInit {
    
    self.layer.cornerRadius = 5;
    self.clipsToBounds = YES;
    self.backgroundColor = [UIColor whiteColor];
    
    _closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_closeButton setImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
    [_closeButton sizeToFit];
    _closeButton.center = CGPointMake(self.bounds.size.width-5-_closeButton.bounds.size.width/2, 5+_closeButton.bounds.size.height/2);
    [_closeButton addTarget:self action:@selector(closeButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_closeButton];
    
    _titleLable = [[UILabel alloc] init];
    _titleLable.text = @"我们不建议您在这样的情况下跑步";
    _titleLable.font = [UIFont systemFontOfSize:18];
    [_titleLable sizeToFit];
    [self addSubview:_titleLable];
    _titleLable.center = CGPointMake(self.bounds.size.width/2, 30+_titleLable.bounds.size.height/2);
    
    _topImage = [[UIImageView alloc] initWithFrame:CGRectMake(45, CGRectGetMaxY(_titleLable.frame) + 20, self.bounds.size.width-90, 100)];
    _topImage.backgroundColor = [UIColor purpleColor];
    [self addSubview:_topImage];
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(_topImage.frame)+20, self.bounds.size.width-60, self.bounds.size.height/2)];
    _textView.text = @"老天搞不定,我自己摆平 老天搞不定,我自己摆平 老天搞不定,我自己摆平 老天搞不定,我自己摆平 老天搞不定,我自己摆平 老天搞不定,我自己摆平 老天搞不定,我自己摆平 老天搞不定,我自己摆平 老天搞不定,我自己摆平 老天搞不定,我自己摆平 老天搞不定,我自己摆平 老天搞不定,我自己摆平 老天搞不定,我自己摆平 老天搞不定,我自己摆平 老天搞不定,我自己摆平 老天搞不定,我自己摆平 老天搞不定,我自己摆平";
    [self addSubview:_textView];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _closeButton.center = CGPointMake(self.bounds.size.width-5-_closeButton.bounds.size.width/2, 5+_closeButton.bounds.size.height/2);
    
    _titleLable.center = CGPointMake(self.bounds.size.width/2, 30+_titleLable.bounds.size.height/2);
    _topImage.frame = CGRectMake(45, CGRectGetMaxY(_titleLable.frame) + 20, self.bounds.size.width-90, 100);
    _textView.frame = CGRectMake(30, CGRectGetMaxY(_topImage.frame)+20, self.bounds.size.width-60, self.bounds.size.height/2);
}

#pragma mark - Event
#pragma mark Button Event

- (void)closeButtonTouch:(UIButton *)sender {
    if (_closeBlock) {
        _closeBlock(self);
    }
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
