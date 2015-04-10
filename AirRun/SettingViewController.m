//
//  SettingViewController.m
//  AirRun
//
//  Created by ChenHao on 4/3/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import "SettingViewController.h"
#import "UConstants.h"
#import "ProfileViewController.h"
#import "RESideMenu.h"
#import <AVOSCloud.h>

@interface SettingViewController ()
@property (nonatomic, strong) AVUser *user;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"设置"];
    [[self.navigationController navigationBar] setBarTintColor:RGBCOLOR(85, 150, 204)];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navicon"] style:UIBarButtonItemStylePlain target:self action:@selector(menuButtonTouch:)];
    self.navigationItem.leftBarButtonItem = menuButton;
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    _user = [AVUser currentUser];
    
}

- (instancetype)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 3;
    }
    return 3;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifer = @"cellIdentifer";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (cell ==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    }
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, HEIGHT(cell))];
    [title setFont:[UIFont systemFontOfSize:14]];
    [cell.contentView addSubview:title];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    switch (indexPath.section) {
            
        case 0:
            if (indexPath.row == 0) {
                title.text = @"语音提示";
                UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, HEIGHT(cell)-1, Main_Screen_Width-15, 0.5)];
                [line setBackgroundColor:RGBCOLOR(235, 235, 235)];
                [cell setAccessoryType:UITableViewCellAccessoryNone];
                [cell.contentView addSubview:line];
                
                UISwitch *switchButton = [[UISwitch alloc] initWithFrame:CGRectMake(Main_Screen_Width-65, 7, 60, 30)];
                [switchButton addTarget:self action:@selector(switchVoiceButton:) forControlEvents:UIControlEventValueChanged];
                
                if ([_user objectForKey:@"voiceNotification"] == nil || [[_user objectForKey:@"voiceNotification"] isEqualToString:@"on"]) {
                    switchButton.on=YES;
                }
            
                [cell addSubview:switchButton];
            }
            if (indexPath.row == 1) {
                title.text = @"锻炼提醒";
                UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, HEIGHT(cell)-1, Main_Screen_Width-15, 0.5)];
                [line setBackgroundColor:RGBCOLOR(235, 235, 235)];
                [cell.contentView addSubview:line];
            }
            if (indexPath.row == 2) {
                title.text = @"同步数据";
            }
            
            break;
            
        case 1:
            if (indexPath.row == 0) {
                title.text = @"意见反馈";
                UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, HEIGHT(cell)-1, Main_Screen_Width-15, 0.5)];
                [line setBackgroundColor:RGBCOLOR(235, 235, 235)];
                [cell.contentView addSubview:line];
            }
            if (indexPath.row == 1) {
                title.text = @"评价我们";
                UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, HEIGHT(cell)-1, Main_Screen_Width-15, 0.5)];
                [line setBackgroundColor:RGBCOLOR(235, 235, 235)];
                [cell.contentView addSubview:line];
            }
            if (indexPath.row == 2) {
                title.text = @"关于我们";
            }
            
            
            break;
        default:
            break;
    }
    
    
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row ==2) {
                [[PersistenceManager shareManager] sync];
            }
        }
        break;
        case 1:
        {
            
            if (indexPath.row == 2) {
                
            }
        }
            break;
        default:
            break;
    }
}


- (void)menuButtonTouch:(UIButton *)sender {
    [self.sideMenuViewController presentLeftMenuViewController];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [_user saveInBackground];
}


- (void)switchVoiceButton:(id)sender
{
    UISwitch *switchButton = (UISwitch *)sender;
    if (switchButton.on) {
        [_user setObject:@"on" forKey:@"voiceNotification"];
    }
    else
    {
        [_user setObject:@"off" forKey:@"voiceNotification"];
    }
    
}


@end
