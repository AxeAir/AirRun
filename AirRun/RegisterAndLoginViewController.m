//
//  RegisterAndLoginViewController.m
//  AirRun
//
//  Created by jasonWu on 4/3/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import "RegisterAndLoginViewController.h"
#import "SignUpView.h"
#import "SignInView.h"

typedef enum : NSUInteger {
    RegisterAndLoginViewControllerStateSignUp,
    RegisterAndLoginViewControllerStateSignIn,
    
} RegisterAndLoginViewControllerState;

@interface RegisterAndLoginViewController ()

@property (assign, nonatomic) RegisterAndLoginViewControllerState state;

@property (strong, nonatomic) UIImageView *bgImage;
@property (strong, nonatomic) UIButton *changeButton;
@property (strong, nonatomic) UIImageView *iconImageView;
@property (strong, nonatomic) UILabel *appNameLabel;

@property (strong, nonatomic) SignUpView *signUpView;
@property (strong, nonatomic) SignInView *signInView;

@property (strong, nonatomic) UIButton *signInOrUpButton;

@property (strong, nonatomic) UIButton *weibo;
@property (strong, nonatomic) UIButton *wechat;

@end

@implementation RegisterAndLoginViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _state = RegisterAndLoginViewControllerStateSignUp;
    [self p_layout];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    [self p_startAnimation];
    
}

#pragma mark - Layout
- (void)p_layout {
    
    _bgImage = [[UIImageView alloc] initWithFrame:self.view.bounds];
    _bgImage.image = [UIImage imageNamed:@"bg.png"];
    [self.view addSubview:_bgImage];
    
    _changeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_changeButton setTitle:@"已有账号" forState:UIControlStateNormal];
    [_changeButton setTintColor:[UIColor whiteColor]];
    _changeButton.titleLabel.font = [UIFont systemFontOfSize:11];
    [_changeButton sizeToFit];
    _changeButton.center = CGPointMake(self.view.bounds.size.width-_changeButton.bounds.size.width/2-5, _changeButton.bounds.size.height/2+20);
    _changeButton.alpha = 0;
    [_changeButton addTarget:self action:@selector(changeButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_changeButton];
    
    _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 70, 70)];
    _iconImageView.image = [UIImage imageNamed:@"setting.png"];
    _iconImageView.center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2-_iconImageView.bounds.size.height/2-20);
    [self.view addSubview:_iconImageView];
    
    _appNameLabel = [[UILabel alloc] init];
    _appNameLabel.text = @"轻跑";
    _appNameLabel.textColor = [UIColor whiteColor];
    _appNameLabel.font = [UIFont systemFontOfSize:14];
    [_appNameLabel sizeToFit];
    _appNameLabel.center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2+_appNameLabel.bounds.size.height/2+20);
    [self.view addSubview:_appNameLabel];
    
    _weibo = [UIButton buttonWithType:UIButtonTypeSystem];
    [_weibo setTitle:@"微博" forState:UIControlStateNormal];
    [_weibo setTintColor:[UIColor whiteColor]];
    _weibo.titleLabel.font = [UIFont systemFontOfSize:12];
    [_weibo setImage:[UIImage imageNamed:@"setting.png"] forState:UIControlStateNormal];
    [_weibo sizeToFit];
    _weibo.center = CGPointMake(self.view.bounds.size.width/2-_weibo.bounds.size.width/2-20, self.view.bounds.size.height-10-_weibo.bounds.size.height/2);
    _weibo.alpha = 0;
    [self.view addSubview:_weibo];
    
    _wechat = [UIButton buttonWithType:UIButtonTypeSystem];
    [_wechat setTitle:@"微信" forState:UIControlStateNormal];
    [_wechat setTintColor:[UIColor whiteColor]];
    [_wechat setImage:[UIImage imageNamed:@"setting.png"] forState:UIControlStateNormal];
    _wechat.titleLabel.font = [UIFont systemFontOfSize:12];
    [_wechat sizeToFit];
    _wechat.center = CGPointMake(self.view.bounds.size.width/2 + 20 + _wechat.bounds.size.width/2, self.view.bounds.size.height-10-_wechat.bounds.size.height/2);
    _wechat.alpha = 0;
    [self.view addSubview:_wechat];
    
}

- (void)p_layoutAfterAnimation {
    
    _signUpView = [[SignUpView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width-20, 150)];
    _signUpView.center = CGPointMake(self.view.bounds.size.width/2, CGRectGetMaxY(_iconImageView.frame) + 60 +_signUpView.bounds.size.height/2);
    _signUpView.layer.cornerRadius = 5;
    _signUpView.layer.borderWidth = 1;
    _signUpView.layer.borderColor = [UIColor colorWithWhite:0 alpha:0.1].CGColor;
    _signUpView.alpha = 0;
    [self.view addSubview:_signUpView];
    
    _signInView = [[SignInView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width-20, 100)];
    _signInView.center = CGPointMake(self.view.bounds.size.width+10+_signInView.bounds.size.width/2, CGRectGetMaxY(_iconImageView.frame)+60+_signInView.bounds.size.height/2);
    _signInView.layer.cornerRadius = 5;
    _signInView.layer.borderWidth = 1;
    _signInView.layer.borderColor = [UIColor colorWithWhite:0 alpha:0.1].CGColor;
    [self.view addSubview:_signInView];
    
    
    _signInOrUpButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_signInOrUpButton setTitle:@"注册" forState:UIControlStateNormal];
    [_signInOrUpButton setTintColor:[UIColor whiteColor]];
    _signInOrUpButton.frame = CGRectMake(0, 0, self.view.bounds.size.width-50, 40);
    _signInOrUpButton.center = CGPointMake(self.view.bounds.size.width/2,CGRectGetMaxY(_signUpView.frame)+30+_signInOrUpButton.bounds.size.height/2 );
    _signInOrUpButton.layer.cornerRadius = 5;
    _signInOrUpButton.layer.borderWidth = 1;
    _signInOrUpButton.layer.borderColor = [UIColor whiteColor].CGColor;
    _signInOrUpButton.alpha = 0;
    [self.view addSubview:_signInOrUpButton];
    
}

#pragma mark - Animation

- (void)p_startAnimation {
    
    [UIView animateWithDuration:3 animations:^{
        _iconImageView.center = CGPointMake(self.view.bounds.size.width/2, 70+_iconImageView.bounds.size.height/2);
        _appNameLabel.center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height-50-_appNameLabel.bounds.size.height/2);
        _appNameLabel.alpha = 0;
    } completion:^(BOOL finished) {
        [_appNameLabel removeFromSuperview];
        [self p_layoutAfterAnimation];
        
        //出现注册界面
        [UIView animateWithDuration:0.3 animations:^{
            _signUpView.alpha = 1;
        } completion:^(BOOL finished) {
            
            //出现按钮界面
            [UIView animateWithDuration:0.3 animations:^{
                _signInOrUpButton.alpha = 1;
            } completion:^(BOOL finished) {
                
                //出现微博微信登陆界面
                [UIView animateWithDuration:0.3 animations:^{
                    _wechat.alpha = 1;
                    _weibo.alpha = 1;
                    _changeButton.alpha = 1;
                }];
                
            }];
            
        }];
        
    }];
    
}


#pragma mark - Event
#pragma mark Button Event

- (void)changeButtonTouch:(UIButton *)sender {
    
    sender.userInteractionEnabled = NO;
    
    if (_state == RegisterAndLoginViewControllerStateSignIn) {
        _state = RegisterAndLoginViewControllerStateSignUp;
        [_changeButton setTitle:@"已有账号" forState:UIControlStateNormal];
        [_signInOrUpButton setTitle:@"注册" forState:UIControlStateNormal];
        
        [UIView animateWithDuration:0.3 animations:^{
            _signInView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.3 animations:^{
                _signUpView.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                sender.userInteractionEnabled = YES;
            }];
            
        }];
        
        
        
    } else if (_state == RegisterAndLoginViewControllerStateSignUp) {
        _state = RegisterAndLoginViewControllerStateSignIn;
        [_changeButton setTitle:@"马上注册" forState:UIControlStateNormal];
        [_signInOrUpButton setTitle:@"登陆" forState:UIControlStateNormal];
        
        [UIView animateWithDuration:0.3 animations:^{
            
            _signUpView.transform = CGAffineTransformMakeTranslation(-self.view.bounds.size.width, 0);
            
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.3 animations:^{
                _signInView.transform = CGAffineTransformMakeTranslation(-self.view.bounds.size.width, 0);
            } completion:^(BOOL finished) {
                sender.userInteractionEnabled = YES;
            }];
            
        }];
        
    }
    
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end