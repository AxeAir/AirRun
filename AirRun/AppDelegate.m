//
//  AppDelegate.m
//  AirRun
//
//  Created by ChenHao on 3/30/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import "AppDelegate.h"
#import "RunViewController.h"
#import "LeftSideViewController.h"
#import <AVOSCloud.h>
#import "DocumentHelper.h"
#import "UConstants.h"
#import "RunningRecord.h"
#import "RunningImage.h"
#import <AVOSCloudSNS.h>
#import <CoreData+MagicalRecord.h>
#import "RegisterAndLoginViewController.h"
#import "SettingViewController.h"
#import "UConstants.h"
#import "ZWIntroductionViewController.h"
#import "RunManager.h"
#import "WeatherManager.h"


@interface AppDelegate ()

@property (nonatomic, strong) ZWIntroductionViewController *introductionView;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [AVOSCloud setApplicationId:@"8idak6ebtenkwv4pv2caugmbuws9flvwse7k2275cm4s2vz7"
                      clientKey:@"140a1m8lrhg0s0lyzasvsrg3ou5zfrd13nqkdg13zytwytk5"];
    [RunningRecord registerSubclass];
    [RunningImage registerSubclass];
    [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:@"AexAir.sqlite"];
    
    [WXApi registerApp:@"wx54fac834bc555603"];
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [DocumentHelper creatFolderAtDocument:kMapImageFolder];//创建图片文件夹
    [DocumentHelper creatFolderAtDocument:kPathImageFolder];
    [DocumentHelper creatFolderAtDocument:kHeartImage];
    
    UINavigationController *navigationController = nil;
    
    if ([AVUser currentUser]==nil) {
         navigationController = [[UINavigationController alloc] initWithRootViewController:[[RegisterAndLoginViewController alloc] init]];
    }
    else
    {
         navigationController = [[UINavigationController alloc] initWithRootViewController:[[RunViewController alloc] init]];
    }
    
    LeftSideViewController *leftMenuViewController = [[LeftSideViewController alloc] init];
    
    RESideMenu *sideMenuViewController = [[RESideMenu alloc] initWithContentViewController:navigationController
                                                                    leftMenuViewController:leftMenuViewController
                                                                   rightMenuViewController:nil];
    sideMenuViewController.backgroundImage = [UIImage imageNamed:@"seabg"];
    sideMenuViewController.menuPreferredStatusBarStyle = 1; // UIStatusBarStyleLightContent
    sideMenuViewController.delegate = self;
    sideMenuViewController.contentViewShadowColor = [UIColor blackColor];
    sideMenuViewController.contentViewShadowOffset = CGSizeMake(0, 0);
    sideMenuViewController.contentViewShadowOpacity = 0.6;
    sideMenuViewController.contentViewShadowRadius = 12;
    sideMenuViewController.contentViewShadowEnabled = YES;
    self.window.rootViewController = sideMenuViewController;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    if (FSystenVersion>=8) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert
                                                | UIUserNotificationTypeBadge
                                                | UIUserNotificationTypeSound
                                                                                 categories:nil];
        [application registerUserNotificationSettings:settings];
        [application registerForRemoteNotifications];
    }
    else
    {
        // Register for push notifications
        [application registerForRemoteNotificationTypes:
         UIRemoteNotificationTypeBadge |
         UIRemoteNotificationTypeAlert |
         UIRemoteNotificationTypeSound];
    }
    
    // Added Introduction View Controller
    NSArray *coverImageNames = @[@"finish", @"finish", @"finish"];
    NSArray *backgroundImageNames = @[@"seabg", @"seabg", @"seabg"];
    self.introductionView = [[ZWIntroductionViewController alloc] initWithCoverImageNames:coverImageNames backgroundImageNames:backgroundImageNames];
    
    // Example 2
    //    UIButton *enterButton = [UIButton new];
    //    [enterButton setBackgroundImage:[UIImage imageNamed:@"bg_bar"] forState:UIControlStateNormal];
    //    self.introductionView = [[ZWIntroductionViewController alloc] initWithCoverImageNames:coverImageNames backgroundImageNames:backgroundImageNames button:enterButton];
    
    //[self.window addSubview:self.introductionView.view];
    
    __weak AppDelegate *weakSelf = self;
    self.introductionView.didSelectedEnter = ^() {
        [weakSelf.introductionView.view removeFromSuperview];
        weakSelf.introductionView = nil;
        
        // enter main view , write your code ...
        //        ViewController *mainVC = [[ViewController alloc] init];
        //        weakSelf.window.rootViewController = mainVC;
        
    };
    
    return YES;

    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    RunManager *runManger = [RunManager shareInstance];
    if (runManger.runState != RunStateStop) {
        [runManger saveToUserDefault];
    }
    
    [MagicalRecord cleanUp];
    
}

-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    
    NSString *string =[url absoluteString];
    if ([string hasPrefix:@"weixin"]) {
        return [WXApi handleOpenURL:url delegate:self];
    }else
        return [AVOSCloudSNS handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [WXApi handleOpenURL:url delegate:self];
}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    AVInstallation *currentInstallation = [AVInstallation currentInstallation];
    NSLog(@"%@",deviceToken);
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"%@",error);
}
@end
