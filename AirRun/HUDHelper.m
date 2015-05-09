//
//  HUDHelper.m
//  SportManV2
//
//  Created by ChenHao on 3/8/15.
//  Copyright (c) 2015 JasonWu. All rights reserved.
//

#import "HUDHelper.h"


@implementation HUDHelper




+ (void)showHUD:(NSString *)text andView:(UIView *)view andHUD:(MBProgressHUD *)hud
{
    [view addSubview:hud];
    hud.labelText = text;//显示提示
    hud.dimBackground = YES;//使背景成黑灰色，让MBProgressHUD成高亮显示
    hud.square = YES;//设置显示框的高度和宽度一样
    [hud show:YES];
}


+ (void)showHUDWithoutMask:(NSString *)text andView:(UIView *)view andHUD:(MBProgressHUD *)hud
{
    [view addSubview:hud];
    hud.labelText = text;//显示提示
    hud.square = YES;//设置显示框的高度和宽度一样
    [hud show:YES];
}

+ (void)showComplete:(NSString *)text addView:(UIView *)view delay:(NSInteger)delay
{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:hud];
    hud.mode = MBProgressHUDModeCustomView;
    hud.dimBackground = NO;
    hud.labelText = text;
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkmark"]];
    // Set custom view mode
    hud.mode = MBProgressHUDModeCustomView;
    [hud show:YES];
    [hud hide:YES afterDelay:delay];
    
}


+ (void)showError:(NSString *)text addView:(UIView *)view delay:(NSInteger)delay
{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:hud];
    hud.mode = MBProgressHUDModeCustomView;
    hud.dimBackground = NO;
    hud.labelText = text;
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wrong"]];
    // Set custom view mode
    hud.mode = MBProgressHUDModeCustomView;
    [hud show:YES];
    [hud hide:YES afterDelay:delay];
    
}


+ (void)showComplete:(NSString *)text addView:(UIView *)view addHUD:(MBProgressHUD *)hud delay:(NSInteger)delay
{
    [view addSubview:hud];
    hud.mode = MBProgressHUDModeCustomView;
    hud.dimBackground = NO;
    hud.labelText = text;
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkmark"]];
    // Set custom view mode
    [hud show:YES];
    [hud hide:YES afterDelay:delay];
}


+ (void)showError:(NSString *)text addView:(UIView *)view addHUD:(MBProgressHUD *)hud delay:(NSInteger)delay
{
    [view addSubview:hud];
    hud.mode = MBProgressHUDModeCustomView;
    hud.dimBackground = NO;
    hud.labelText = text;
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wrong"]];
    // Set custom view mode
    [hud show:YES];
    [hud hide:YES afterDelay:delay];
}

+ (void)showTextHUD:(NSString *)text addView:(UIView *)view delay:(NSInteger)delay
{
    MBProgressHUD *hud = [[MBProgressHUD alloc] init];
    [view addSubview:hud];
    hud.mode = MBProgressHUDModeText;
    hud.dimBackground = NO;
    hud.labelText = text;
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"no"]];
    // Set custom view mode
    [hud show:YES];
    [hud hide:YES afterDelay:delay];
}
@end
