//
//  LeftSideViewController.m
//  AirRun
//
//  Created by ChenHao on 3/31/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import "LeftSideViewController.h"
#import "HeaderView.h"
#import "RunCompleteCardsVC.h"
#import "RunViewController.h"
#import "UConstants.h"
#import "RegisterAndLoginViewController.h"
#import "SettingViewController.h"
#import "TimelineController.h"
#import <AVOSCloud.h>
#import "ProfileViewController.h"
#import "NavViewController.h"

@interface LeftSideViewController ()

@property (strong, readwrite, nonatomic) UITableView *tableView;
@property (strong, nonatomic) HeaderView *header;

@end

@implementation LeftSideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = ({
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,50, self.view.frame.size.width*0.7, self.view.frame.size.height) style:UITableViewStylePlain];
        tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.opaque = NO;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.backgroundView = nil;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.bounces = NO;
        tableView;
    });
    [self.view addSubview:self.tableView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0:
            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[[RunViewController alloc] init]]
                                                         animated:NO];
            [self.sideMenuViewController setPanGestureEnabled:YES];
            [self.sideMenuViewController hideMenuViewController];
            break;
        case 1:
            [self.sideMenuViewController setContentViewController:[[NavViewController alloc] initWithRootViewController:[TimelineController alloc]]
                                                         animated:NO];
            [self.sideMenuViewController setPanGestureEnabled:YES];
            [self.sideMenuViewController hideMenuViewController];
            break;
        case 2:
            [self.sideMenuViewController setContentViewController:[[NavViewController alloc] initWithRootViewController:[[SettingViewController alloc] init]]
                                                         animated:NO];
            [self.sideMenuViewController setPanGestureEnabled:YES];
            [self.sideMenuViewController hideMenuViewController];
            
            break;

        default:
            break;
    }
}

#pragma mark -
#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
        return 28.0;
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    if (sectionIndex == 0) {
        return 1;
    }
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 100.0;
    }
    return 0.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        _header = [[HeaderView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        [_header configUserwithBloak:^{
            
            AVUser *currentUser = [AVUser currentUser];
            if (currentUser != nil) {
                // 允许用户使用应用
                ProfileViewController *profile = [[ProfileViewController alloc] initWithStyle:UITableViewStyleGrouped];
                [self.sideMenuViewController setContentViewController:[[NavViewController alloc] initWithRootViewController:profile] animated:YES];
                [self.sideMenuViewController setPanGestureEnabled:YES];
                [self.sideMenuViewController hideMenuViewController];
                
            } else {
                //缓存用户对象为空时，可打开用户注册界面…
                RegisterAndLoginViewController *RegisterAndLogin = [[RegisterAndLoginViewController alloc] init];
                [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:RegisterAndLogin] animated:YES];
                [self.sideMenuViewController setPanGestureEnabled:NO];
                [self.sideMenuViewController hideMenuViewController];
            }
        }];
        
        return _header;
    }
    return nil;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        UIView *selectbg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        [selectbg setBackgroundColor:RGBACOLOR(200, 200, 200, 0.2)];
        [cell setSelectedBackgroundView:selectbg];
    }
    if (indexPath.section == 0) {
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(35, 4, 100, 20)];
        [title setTextColor:[UIColor whiteColor]];
        [title setFont:[UIFont systemFontOfSize:12]];
        [title setTextColor:[UIColor grayColor]];
        title.text = [[AVUser currentUser] objectForKey:@"introduction"];
        [cell addSubview:title];
        UIView *topline = [[UIView alloc] initWithFrame:CGRectMake(30, 1, WIDTH(cell)-30, 1)];
        [topline setBackgroundColor:RGBACOLOR(100, 100, 100, 0.4)];
        [cell.contentView addSubview:topline];
        
        UIView *bottomline = [[UIView alloc] initWithFrame:CGRectMake(30, 27, WIDTH(cell)-30, 1)];
        [bottomline setBackgroundColor:RGBACOLOR(100, 100, 100, 0.4)];
        [cell.contentView addSubview:bottomline];
    }
    
    if (indexPath.section == 1) {
        NSArray *titles = @[@"跑步", @"运动数据", @"设置"];
        NSArray *images = @[@"runner", @"timeline", @"setting",@"info"];
        
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(30, 11, 22, 22)];
        [image setImage:[UIImage imageNamed:[images objectAtIndex:indexPath.row]]];
        
        [cell addSubview:image];
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(image)+10, 11, 100, 22)];
        [title setTextColor:[UIColor whiteColor]];
        [title setText:titles[indexPath.row]];
        [title setFont:[UIFont systemFontOfSize:16]];
        [cell addSubview:title];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    
    return cell;
}

@end
