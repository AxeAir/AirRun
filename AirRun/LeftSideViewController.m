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
#import "SettingViewController.h"
@interface LeftSideViewController ()

@property (strong, readwrite, nonatomic) UITableView *tableView;
@property (strong, nonatomic) HeaderView *header;

@end

@implementation LeftSideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,50, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
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
                                                         animated:YES];
            [self.sideMenuViewController hideMenuViewController];
            break;
        case 1:
//            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[[DEMOSecondViewController alloc] init]]
//                                                         animated:YES];
//            [self.sideMenuViewController hideMenuViewController];
            break;
        case 3:
            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[[SettingViewController alloc] init]]
                                                         animated:YES];
            [self.sideMenuViewController hideMenuViewController];
            
            break;
        case 4:
        {
            RunCompleteCardsVC *runVC = [[RunCompleteCardsVC alloc] init];
            [self.sideMenuViewController setContentViewController:runVC animated:YES];
            [self.sideMenuViewController hideMenuViewController];
        }
            break;
        default:
            break;
    }
}

#pragma mark -
#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 100.0;
    }
    return 10.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        _header = [[HeaderView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        [_header configUserInfo:nil withBloak:^{
            
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
        cell.textLabel.textColor = [UIColor whiteColor];
        UIView *selectbg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        [selectbg setBackgroundColor:[UIColor colorWithHue:1 saturation:1 brightness:1 alpha:0.2]];
        [cell setSelectedBackgroundView:selectbg];
    }
    
    NSArray *titles = @[@"跑步", @"运动数据", @"运动记录", @"设置",@"GoGoGo"];
    NSArray *images = @[@"setting", @"setting", @"setting", @"setting" , @"setting"];
    
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(50, 12, 30, 30)];
    [image setImage:[UIImage imageNamed:[images objectAtIndex:indexPath.row]]];
    
    [cell addSubview:image];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(image)+10, 12, 100, 30)];
    [title setTextColor:[UIColor whiteColor]];
    [title setText:titles[indexPath.row]];
    [cell addSubview:title];
    //cell.textLabel.text = titles[indexPath.row];
    //cell.imageView.image = [UIImage imageNamed:images[indexPath.row]];
    
    return cell;
}




@end
