//
//  SignInView.m
//  AirRun
//
//  Created by jasonWu on 4/3/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import "SignInView.h"

@interface SignInView ()

@property (strong, nonatomic) UIView *emailView;
@property (strong, nonatomic) UIImageView *emailImageView;

@property (strong, nonatomic) UIView *lineView;

@property (strong, nonatomic) UIView *passwordView;
@property (strong, nonatomic) UIImageView *passwordImageView;

@end

@implementation SignInView

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self p_layoutEmailView];
    [self p_layoutPassword];
}

- (void)p_layoutEmailView {
    
    if (!_emailView) {
        _emailView = [[UIView alloc] init];
        [self addSubview:_emailView];
    }
    _emailView.frame = CGRectMake(15, 0, self.bounds.size.width-15, self.bounds.size.height/2);
    
    if (!_emailImageView) {
        _emailImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        _emailImageView.image = [UIImage imageNamed:@"email"];
        [_emailView addSubview:_emailImageView];
    }
    _emailImageView.center = CGPointMake(15+_emailImageView.bounds.size.width/2, _emailView.bounds.size.height/2);
    
    if (!_emailField) {
        _emailField = [[UITextField alloc] init];
        _emailField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"邮箱"
                                                                            attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],
                                                                                         NSFontAttributeName:[UIFont systemFontOfSize:14]}];
        _emailField.borderStyle = UITextBorderStyleNone;
        [_emailField setKeyboardType:UIKeyboardTypeEmailAddress];
        [_emailView addSubview:_emailField];
    }
    _emailField.frame = CGRectMake(CGRectGetMaxX(_emailImageView.frame)+15, _emailView.bounds.size.height/2-15, _emailView.bounds.size.width-CGRectGetMaxX(_emailImageView.frame)-15, 30);
    
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
        [_emailView addSubview:_lineView];
    }
    _lineView.frame = CGRectMake(0, _emailView.bounds.size.height, _emailView.bounds.size.width, 1);
    
}

- (void)p_layoutPassword {
    
    if (!_passwordView) {
        _passwordView = [[UIView alloc] init];
        [self addSubview:_passwordView];
    }
    _passwordView.frame = CGRectMake(15, CGRectGetMaxY(_emailView.frame), self.bounds.size.width-15, self.bounds.size.height/2);
    
    if (!_passwordImageView) {
        _passwordImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        _passwordImageView.image = [UIImage imageNamed:@"passwordlock"];
        [_passwordView addSubview:_passwordImageView];
    }
    _passwordImageView.center = CGPointMake(15+_passwordImageView.bounds.size.width/2, _passwordView.bounds.size.height/2);
    
    if (!_passwordField) {
        _passwordField = [[UITextField alloc] init];
        _passwordField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"密码"
                                                                               attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],
                                                                                            NSFontAttributeName:[UIFont systemFontOfSize:14]}];
        _passwordField.borderStyle = UITextBorderStyleNone;
        _passwordField.secureTextEntry = YES;
        [_passwordField setKeyboardType:UIKeyboardTypeEmailAddress];
        [_passwordView addSubview:_passwordField];
    }
    _passwordField.frame = CGRectMake(CGRectGetMaxX(_passwordImageView.frame)+15, _passwordView.bounds.size.height/2-15, _passwordView.bounds.size.width-CGRectGetMaxX(_passwordImageView.frame)-15, 30);
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
