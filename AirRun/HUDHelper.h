//
//  HUDHelper.h
//  SportManV2
//
//  Created by ChenHao on 3/8/15.
//  Copyright (c) 2015 JasonWu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MBProgressHUD.h>


@interface HUDHelper : NSObject

+ (void)showHUD:(NSString *)text andView:(UIView *)view andHUD:(MBProgressHUD *)hud;

+ (void)showHUDWithoutMask:(NSString *)text andView:(UIView *)view andHUD:(MBProgressHUD *)hud;

#pragma mark only delay
+ (void)showComplete:(NSString *)text
             addView:(UIView *)view
               delay:(NSInteger)delay;

+ (void)showError:(NSString *)text
          addView:(UIView *)view
            delay:(NSInteger)delay;

#pragma mark delay and HUD
+ (void)showError:(NSString *)text
          addView:(UIView *)view
           addHUD:(MBProgressHUD *)hud
            delay:(NSInteger)delay;

+ (void)showComplete:(NSString *)text
             addView:(UIView *)view
              addHUD:(MBProgressHUD *)hud
               delay:(NSInteger)delay;

+ (void)showTextHUD:(NSString *)text
            addView:(UIView *)view
              delay:(NSInteger)delay;
@end
