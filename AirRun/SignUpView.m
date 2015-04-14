//
//  SignUpView.m
//  AirRun
//
//  Created by jasonWu on 4/3/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import "SignUpView.h"

@interface SignUpView () <UITextFieldDelegate>

@property (strong, nonatomic) UIView *nickNameView;
@property (strong, nonatomic) UIImageView *nickNameImageView;
@property (strong, nonatomic) UIView *nickNameUnderLine;

@property (strong, nonatomic) UIView *emailView;
@property (strong, nonatomic) UIImageView *emailImageView;
@property (strong, nonatomic) UIView *emailUnderLine;

@property (strong, nonatomic) UIView *passwordView;
@property (strong, nonatomic) UIImageView *passwordImageView;

@end

@implementation SignUpView

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self p_layoutNickNameView];
    [self p_layoutEmailView];
    [self p_layoutPasswordView];
    
}

- (void)p_layoutNickNameView {
    
    if (!_nickNameView) {
        _nickNameView = [[UIView alloc] init];
        [self addSubview:_nickNameView];
    }
    _nickNameView.frame = CGRectMake(15, 0, self.bounds.size.width-15, self.bounds.size.height/3);
    
    if (!_nickNameImageView) {
        _nickNameImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        _nickNameImageView.image = [UIImage imageNamed:@"nickname"];
        [_nickNameView addSubview:_nickNameImageView];
    }
    _nickNameImageView.center = CGPointMake(15+_nickNameImageView.bounds.size.width/2, _nickNameView.bounds.size.height/2);
    
    if (!_nickNameField) {
        _nickNameField = [[UITextField alloc] init];
        _nickNameField.borderStyle = UITextBorderStyleNone;
        _nickNameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"昵称"
                                                                               attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],
                                                                                            NSFontAttributeName:[UIFont systemFontOfSize:14]}];
        [_nickNameField setKeyboardType:UIKeyboardTypeEmailAddress];
        _nickNameField.textColor = [UIColor whiteColor];
        [_nickNameView addSubview:_nickNameField];
    }
    _nickNameField.frame = CGRectMake(CGRectGetMaxX(_nickNameImageView.frame)+15, _nickNameView.bounds.size.height/2-15, _nickNameView.bounds.size.width-CGRectGetMaxX(_nickNameImageView.frame)-15, 30);
    
    if (!_nickNameUnderLine) {
        _nickNameUnderLine = [[UIView alloc] init];
        _nickNameUnderLine.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
        [_nickNameView addSubview:_nickNameUnderLine];
    }
    _nickNameUnderLine.frame = CGRectMake(0, _nickNameView.bounds.size.height, _nickNameView.bounds.size.width, 1);
}

- (void)p_layoutEmailView {
    
    if (!_emailView) {
        _emailView = [[UIView alloc] init];
        [self addSubview:_emailView];
    }
    _emailView.frame = CGRectMake(15, CGRectGetMaxY(_nickNameView.frame), self.bounds.size.width-15, self.bounds.size.height/3);
    
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
        _emailField.textColor = [UIColor whiteColor];
        [_emailField setKeyboardType:UIKeyboardTypeEmailAddress];
        [_emailView addSubview:_emailField];
    }
    _emailField.frame = CGRectMake(CGRectGetMaxX(_emailImageView.frame)+15, _emailView.bounds.size.height/2-15, _emailView.bounds.size.width-CGRectGetMaxX(_emailImageView.frame)-15, 30);
    
    if (!_emailUnderLine) {
        _emailUnderLine = [[UIView alloc] init];
        _emailUnderLine.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
        [_emailView addSubview:_emailUnderLine];
    }
    _emailUnderLine.frame = CGRectMake(0, _emailView.bounds.size.height, _emailView.bounds.size.width, 1);
    
}

- (void)p_layoutPasswordView {
    
    if (!_passwordView) {
        _passwordView = [[UIView alloc] init];
        [self addSubview:_passwordView];
    }
    _passwordView.frame = CGRectMake(15, CGRectGetMaxY(_emailView.frame), self.bounds.size.width-15, self.bounds.size.height/3);
    
    if (!_passwordImageView) {
        _passwordImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        _passwordImageView.image = [UIImage imageNamed:@"password"];
        [_passwordView addSubview:_passwordImageView];
    }
    _passwordImageView.center = CGPointMake(15+_passwordImageView.bounds.size.width/2, _passwordView.bounds.size.height/2);
    
    if (!_passwordField) {
        _passwordField = [[UITextField alloc] init];
        _passwordField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"密码"
                                                                               attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],
                                                                                            NSFontAttributeName:[UIFont systemFontOfSize:14]}];
        _passwordField.borderStyle = UITextBorderStyleNone;
        _passwordField.textColor = [UIColor whiteColor];
        _passwordField.secureTextEntry = YES;
        [_passwordField setKeyboardType:UIKeyboardTypeEmailAddress];
        [_passwordView addSubview:_passwordField];
        _passwordField.delegate = self;
    }
    _passwordField.frame = CGRectMake(CGRectGetMaxX(_passwordImageView.frame)+15, _passwordView.bounds.size.height/2-15, _passwordView.bounds.size.width-CGRectGetMaxX(_passwordImageView.frame)-15, 30);
    
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if ([textField.text length]>=5) {
        _passwordImageView.image = [UIImage imageNamed:@"passwordlock"];
    } else {
        _passwordImageView.image = [UIImage imageNamed:@"password"];
    }
    
    return YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code  
}
*/

@end
