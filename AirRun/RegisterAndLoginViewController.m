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
#import "ValidateHelper.h"
#import "HUDHelper.h"
#import <AVOSCloud.h>
#import <AVOSCloudSNS.h>
#import "RESideMenu.h"
#import "RunViewController.h"
#import <AFURLSessionManager.h>

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - Override

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [_signUpView.nickNameField resignFirstResponder];
    [_signUpView.emailField resignFirstResponder];
    [_signUpView.passwordField resignFirstResponder];
    [_signInView.emailField resignFirstResponder];
    [_signInView.passwordField resignFirstResponder];
    
}

#pragma mark - Layout
- (void)p_layout {
    
    _bgImage = [[UIImageView alloc] initWithFrame:self.view.bounds];
    _bgImage.image = [UIImage imageNamed:@"bg.png"];
    [self.view addSubview:_bgImage];
    
    _changeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_changeButton setTitle:@"已有账号" forState:UIControlStateNormal];
    [_changeButton setTintColor:[UIColor whiteColor]];
    _changeButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_changeButton sizeToFit];
    _changeButton.center = CGPointMake(self.view.bounds.size.width-_changeButton.bounds.size.width/2-10, _changeButton.bounds.size.height/2+30);
    _changeButton.alpha = 0;
    [_changeButton addTarget:self action:@selector(changeButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_changeButton];
    
    _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 70, 70)];
    _iconImageView.image = [UIImage imageNamed:@"logotiny.png"];
    _iconImageView.clipsToBounds = YES;
    _iconImageView.layer.cornerRadius = _iconImageView.bounds.size.width/2;
    _iconImageView.layer.borderWidth = 1;
    _iconImageView.layer.borderColor = [UIColor blueColor].CGColor;
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
    [_weibo setImage:[UIImage imageNamed:@"weibologin"] forState:UIControlStateNormal];
    [_weibo sizeToFit];
    _weibo.center = CGPointMake(self.view.bounds.size.width/2-_weibo.bounds.size.width/2-20, self.view.bounds.size.height-10-_weibo.bounds.size.height/2);
    _weibo.alpha = 0;
    [_weibo addTarget:self action:@selector(weiboLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_weibo];
    
    _wechat = [UIButton buttonWithType:UIButtonTypeCustom];
    [_wechat setTitle:@"QQ" forState:UIControlStateNormal];
    [_wechat setTintColor:[UIColor whiteColor]];
    [_wechat setImage:[UIImage imageNamed:@"qqlogin"] forState:UIControlStateNormal];
    _wechat.titleLabel.font = [UIFont systemFontOfSize:12];
    [_wechat sizeToFit];
    _wechat.center = CGPointMake(self.view.bounds.size.width/2 + 20 + _wechat.bounds.size.width/2, self.view.bounds.size.height-10-_wechat.bounds.size.height/2);
    _wechat.alpha = 0;
    [_wechat addTarget:self action:@selector(qqlogin) forControlEvents:UIControlEventTouchUpInside];
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
    [_signInOrUpButton addTarget:self action:@selector(signInOrSignUpButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
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

- (void)signInOrSignUpButtonTouch:(UIButton *)sender {
    
    if (_state == RegisterAndLoginViewControllerStateSignIn) { //登陆状态
        
        NSString *email = _signInView.emailField.text;
        NSString *password = _signInView.passwordField.text;
        
        if (![ValidateHelper isValidateIsEmptyWithTextField:email]) {
            [HUDHelper showError:@"邮箱不能为空" addView:self.view delay:1];
            return;
        }
        
        if (![ValidateHelper isValidateIsEmptyWithTextField:password]) {
            [HUDHelper showError:@"密码不能为空" addView:self.view delay:1];
            return;
        }
        
        if (![ValidateHelper isValidateEmail:email]) {
            [HUDHelper showError:@"邮箱格式不正确" addView:self.view delay:1];
            return;
        }
        
        MBProgressHUD *hud = [[MBProgressHUD alloc] init];
        [HUDHelper showHUD:@"登陆中" andView:self.view andHUD:hud];
        [AVUser logInWithUsernameInBackground:email password:password block:^(AVUser *user, NSError *error) {
            if (user != nil) {
                [hud hide:YES];
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:@"updateAratar" object:nil];
                RunViewController *run = [[RunViewController alloc] init];
                [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:run] animated:YES];
                [self.sideMenuViewController hideMenuViewController];
            } else {
                [HUDHelper showError:@"登陆失败" addView:self.view addHUD:hud delay:2];
                NSLog(@"%@",error);
            }
        }];
        
    } else if (_state == RegisterAndLoginViewControllerStateSignUp) { //注册状态
        
        NSString *nickName = _signUpView.nickNameField.text;
        NSString *email = _signUpView.emailField.text;
        NSString *password = _signUpView.passwordField.text;
        
        if (![ValidateHelper isValidateIsEmptyWithTextField:nickName]) {
            [HUDHelper showError:@"昵称不能为空" addView:self.view delay:1];
            return;
        }
        if (![ValidateHelper isValidateIsEmptyWithTextField:email]) {
            [HUDHelper showError:@"邮箱不能为空" addView:self.view delay:1];
            return;
        }
        if (![ValidateHelper isValidateIsEmptyWithTextField:password]) {
            [HUDHelper showError:@"密码不能为空" addView:self.view delay:1];
            return;
        }
        if (![ValidateHelper isValidateEmail:email]) {
            [HUDHelper showError:@"邮箱格式不正确" addView:self.view delay:1];
            return;
        }
        
        AVUser *user = [AVUser user];
        user.username = email;
        user.password = password;
        user.email = email;
        [user setObject:nickName forKey:@"nickName"];
        
        MBProgressHUD *hud = [[MBProgressHUD alloc] init];
        [HUDHelper showHUD:@"注册中" andView:self.view andHUD:hud];
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                [hud hide:YES];
                RunViewController *run = [[RunViewController alloc] init];
                [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:run] animated:YES];
                [self.sideMenuViewController hideMenuViewController];
                
            } else {
                
            }
        }];
        
    }
    
    
}

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
#pragma mark Notification Event

- (void)keyboardShow:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    CGFloat animationDuration = [userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] floatValue];
    CGRect endFrame = [userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    
    CGFloat deltaY = 0;
    if (_state == RegisterAndLoginViewControllerStateSignIn) {//登陆
        deltaY = CGRectGetMaxY(_signInView.frame) - endFrame.origin.y;
    } else if (_state == RegisterAndLoginViewControllerStateSignUp) { //注册
        deltaY = CGRectGetMaxY(_signUpView.frame) - endFrame.origin.y;
    }
    
    if (deltaY > 0) {
        [UIView animateWithDuration:animationDuration animations:^{
            self.view.transform = CGAffineTransformMakeTranslation(0, -deltaY);
        }];
    }
    
}

- (void)keyboardHide:(NSNotification *)notification {
    
    NSDictionary *userInfo = notification.userInfo;
    CGFloat animationDuration = [userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] floatValue];
    [UIView animateWithDuration:animationDuration animations:^{
        self.view.transform = CGAffineTransformIdentity;
    }];
    
}

- (void)weiboLogin
{
    [AVOSCloudSNS setupPlatform:AVOSCloudSNSSinaWeibo withAppKey:@"151240750" andAppSecret:@"0488e8710bf0bcd29244f968cdcf2812" andRedirectURI:@"http://open.weibo.com/apps/151240750/privilege/oauth"];
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [HUDHelper showHUD:@"微博登陆中" andView:self.view andHUD:hud];
    [AVOSCloudSNS loginWithCallback:^(id object, NSError *error) {
        if (error) {
            [hud hide:YES];
            NSLog(@"%@",error);
            NSLog(@"微博登陆失败");
        }
        else if(object){
            [hud hide:YES];
            NSLog(@"%@",object);
            NSLog(@"微博登陆成功");
            
            [AVUser loginWithAuthData:object platform:AVOSCloudSNSPlatformWeiBo block:^(AVUser *user, NSError *error) {
                NSLog(@"%@",user);
                if ([[user objectForKey:@"firstSSO"] isEqualToString:@"ok"]) {
                    [[NSNotificationCenter defaultCenter]
                     
                     postNotificationName:@"updateAratar" object:nil];
                    RunViewController *run = [[RunViewController alloc] init];
                    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:run] animated:YES];
                    [self.sideMenuViewController hideMenuViewController];
                }
                //第一次登陆 ，获取登陆信息
                else{
                    NSString     *avatar = [object objectForKey:@"avatar"];
                    NSDictionary *rawuser = [object objectForKey:@"raw-user"];
                    NSString     *gender = [rawuser objectForKey:@"gender"];
                    NSString     *nickname = [object objectForKey:@"username"];
                    
                    
                    [user setObject:nickname forKey:@"nickName"];
                    [user setObject:@"ok" forKey:@"firstSSO"];
                    [user setObject:avatar forKey:@"weiboavatar"];
                    
                    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if (succeeded) {
                            [[NSNotificationCenter defaultCenter]
                             
                             postNotificationName:@"updateAratar" object:nil];
                            RunViewController *run = [[RunViewController alloc] init];
                            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:run] animated:YES];
                            [self.sideMenuViewController hideMenuViewController];
                        }
                        
                    }];
                    
                    
                }
                
                
            }];
        }
        NSLog(@"%@",error);
        
    } toPlatform:AVOSCloudSNSSinaWeibo];
}

- (void)qqlogin
{
    [AVOSCloudSNS setupPlatform:AVOSCloudSNSQQ withAppKey:@"1104472903" andAppSecret:@"9QpaWYoZhHRbMfRm" andRedirectURI:nil];
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [HUDHelper showHUD:@"QQ登录中" andView:self.view andHUD:hud];
    [AVOSCloudSNS loginWithCallback:^(id object, NSError *error) {
        
        if (error) {
            NSLog(@"QQ快速登陆失败");
        }
        else if(object){
            NSLog(@"QQ快速登陆成功");
            NSLog(@"%@",object);
            [AVUser loginWithAuthData:object platform:AVOSCloudSNSPlatformQQ block:^(AVUser *user, NSError *error) {
                [hud hide:YES];
                //
                if ([[user objectForKey:@"firstSSO"] isEqualToString:@"ok"]) {
                    [[NSNotificationCenter defaultCenter]
                     
                     postNotificationName:@"updateAratar" object:nil];
                    RunViewController *run = [[RunViewController alloc] init];
                    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:run] animated:YES];
                    [self.sideMenuViewController hideMenuViewController];
                }
                //第一次登陆 ，获取登陆信息
                else{
                    NSString     *avatar = [object objectForKey:@"avatar"];
                    NSDictionary *rawuser = [object objectForKey:@"raw-user"];
                    NSString     *gender = [rawuser objectForKey:@"gender"];
                    NSString     *nickname = [rawuser objectForKey:@"nickname"];
                    
                    [user setObject:gender forKey:@"gender"];
                    [user setObject:nickname forKey:@"nickName"];
                    [user setObject:@"ok" forKey:@"firstSSO"];
                    [user setObject:avatar forKey:@"qqavatar"];
                
                    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {

                        if (succeeded) {
                                
                            [[NSNotificationCenter defaultCenter]
                                 
                                postNotificationName:@"updateAratar" object:nil];
                            RunViewController *run = [[RunViewController alloc] init];
                            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:run] animated:YES];
                            [self.sideMenuViewController hideMenuViewController];
                            }
                            
                        }];
                
                   
                }

            }];
        }
        NSLog(@"%@",error);
        
    } toPlatform:AVOSCloudSNSQQ];

}




@end
