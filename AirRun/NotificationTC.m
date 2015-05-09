//
//  NotificationTC.m
//  AirRun
//
//  Created by ChenHao on 4/13/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import "NotificationTC.h"
#import "UConstants.h"
#import "AirPickerView.h"
#import "DateHelper.h"
#import <AVOSCloud.h>

@interface NotificationTC ()
@property (nonatomic, strong) UISwitch *switchButton;
@property (nonatomic, strong) AVUser *user;

@end

@implementation NotificationTC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView.scrollEnabled = NO;
    _user = [AVUser currentUser];
    
}

/**
 *  页面即将离开的时候保存数据
 *
 *  @param animated <#animated description#>
 */
- (void)viewWillDisappear:(BOOL)animated
{
    [_user saveInBackground];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifer = @"editNotifacationCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifer];
    }
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, HEIGHT(cell))];
    [title setFont:[UIFont systemFontOfSize:14]];
    [cell.contentView addSubview:title];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    if (indexPath.row == 0) {
        title.text = @"推送提示";
        _switchButton = [[UISwitch alloc] initWithFrame:CGRectMake(Main_Screen_Width-65, 7, 60, 30)];
        [_switchButton addTarget:self action:@selector(switchNotificaton:) forControlEvents:UIControlEventValueChanged];
        if ([[_user objectForKey:@"pushNotification"] isEqualToString:@"on"]) {
            _switchButton.on = YES;
        }
        [cell addSubview:_switchButton];
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, HEIGHT(cell)-1, Main_Screen_Width-15, 0.5)];
        [line setBackgroundColor:RGBCOLOR(235, 235, 235)];
        [cell.contentView addSubview:line];
    }
    if (indexPath.row == 1) {
        title.text = @"提醒时间";
        NSString *localpushTime = [_user objectForKey:@"localpushTime"];
        if (localpushTime == nil || [localpushTime isEqualToString:@""]) {
            localpushTime = @"22:00";
        }
        cell.detailTextLabel.text = localpushTime;
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (indexPath.row == 1 && _switchButton.on) {
        
        NSString *localpushTime = [_user objectForKey:@"localpushTime"];
        if (localpushTime == nil || [localpushTime isEqualToString:@""]) {
            localpushTime = @"22:00";
        }
        AirPickerView *air = [[AirPickerView alloc] initWithTimePickerFrames:CGRectMake(0, Main_Screen_Height-300, Main_Screen_Width, 300) date:[DateHelper convertHourandMinuterToDate:localpushTime]];
    
        [air showTimeInView:self.view completeBlock:^(NSDate *date) {
            [cell.detailTextLabel setText:[DateHelper convertDateToHourandMinuter:date]];
            [_user setObject:[DateHelper convertDateToHourandMinuter:date] forKey:@"localpushTime"];
        }];
    }
}

- (void)switchNotificaton:(id)sender
{
    if (_switchButton.on) {
        [_user setObject:@"on" forKey:@"pushNotification"];
    }
    else
    {
        [_user setObject:@"off" forKey:@"pushNotification"];
    }
}

@end
