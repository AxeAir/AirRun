//
//  SettingViewController.m
//  AirRun
//
//  Created by ChenHao on 4/3/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import "SettingViewController.h"
#import "UConstants.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"设置"];
    [[self.navigationController navigationBar] setBarTintColor:RGBCOLOR(85, 150, 204)];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
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
    if(section == 0)
    {
        return 1;
    }
    if (section == 1) {
        return 3;
    }
    return 3;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
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
    
    switch (indexPath.section) {
        case 0:
            
            break;
            
        case 1:
            if (indexPath.row == 0) {
                title.text = @"语音提示";
                UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, HEIGHT(cell)-1, Main_Screen_Width-15, 0.5)];
                [line setBackgroundColor:RGBCOLOR(235, 235, 235)];
                [cell.contentView addSubview:line];
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
            
        case 2:
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
    
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    return cell;
}


@end
