//
//  AppDelegate.h
//  AirRun
//
//  Created by ChenHao on 3/30/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESideMenu.h"
#import "WXApi.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate,RESideMenuDelegate,WXApiDelegate>

@property (strong, nonatomic) UIWindow *window;


@end

