//
//  AboutUsViewController.m
//  AirRun
//
//  Created by JasonWu on 4/9/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import "AboutUsViewController.h"
#import <AVOSCloud.h>
#import <Masonry.h>
#import "UConstants.h"
#import <MessageUI/MFMailComposeViewController.h>

@interface AboutUsViewController ()<UITableViewDataSource,UITableViewDelegate,MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) UIImageView *bgImage;
@property (strong, nonatomic) UIButton *closeButton;

@property (strong, nonatomic) UIScrollView *scrollView;


@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView      *headerView;
@property (nonatomic, strong) UIView      *footerView;
@property (nonatomic, strong) UIImageView *bgImageView;

@end

@implementation AboutUsViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"关于我们"];
    [self.view addSubview:self.bgImageView];
    [self.view addSubview:self.tableView];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self layout];
    [AVAnalytics beginLogPageView:@"关于我们页面"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [AVAnalytics endLogPageView:@"关于我们页面"];
}

#pragma mark - Layout

- (void)layout {
    
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self.view);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    
//

}


#pragma mark UITableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellidentifer = @"cellid";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellidentifer];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellidentifer];
    }
    UILabel *title = [[UILabel alloc] init];
    [title setFrame:CGRectMake(18, 0, 100, HEIGHT(cell))];
    [title setFont:[UIFont systemFontOfSize:14]];
    [cell.detailTextLabel setFont:[UIFont systemFontOfSize:14]];
    [cell addSubview:title];
    
    
    if (indexPath.row == 0 && indexPath.section ==0) {
        [title setText:@"启动页"];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    if (indexPath.row == 1 && indexPath.section ==0) {
        [title setText:@"微博"];
        [cell.detailTextLabel setText:@"@轻跑_记录你跑步的APP"];
    }
    if (indexPath.row == 2 && indexPath.section ==0) {
        [title setText:@"意见反馈"];
        [cell.detailTextLabel setText:@"info@mrchenhao.com"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row ==2) {
        [self sendMailInApp];
    }
}

#pragma mark - Mial

- (void)sendMailInApp
{
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    if (!mailClass) {
        //[self alertWithMessage:@"当前系统版本不支持应用内发送邮件功能，您可以使用mailto方法代替"];
        return;
    }
    
    
    if (![mailClass canSendMail]) {
        //[self alertWithMessage:@"用户没有设置邮件账户"];
        return;
    }
    [self displayMailPicker];
}

//调出邮件发送窗口
- (void)displayMailPicker
{
    MFMailComposeViewController *mailPicker = [[MFMailComposeViewController alloc] init];
    mailPicker.mailComposeDelegate = self;
    
    //设置主题
    [mailPicker setSubject: @"关于轻跑"];
    //添加收件人
    NSArray *toRecipients = [NSArray arrayWithObject: @"info@mrchenhao.com"];
    [mailPicker setToRecipients: toRecipients];
    
    NSString *emailBody = @"您好！<br/>我是";
    [mailPicker setMessageBody:emailBody isHTML:YES];
    [self presentViewController:mailPicker animated:YES completion:nil];
}


#pragma mark - 实现 MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    //关闭邮件发送窗口
    
    NSString *msg;
    switch (result) {
        case MFMailComposeResultCancelled:
            msg = @"用户取消编辑邮件";
            break;
        case MFMailComposeResultSaved:
            msg = @"用户成功保存邮件";
            break;
        case MFMailComposeResultSent:
            msg = @"用户点击发送，将邮件放到队列中，还没发送";
            break;
        case MFMailComposeResultFailed:
            msg = @"用户试图保存或者发送邮件失败";
            break;
        default:
            msg = @"";
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    //[self alertWithMessage:msg];
}





#pragma mark settter and getter

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.tableHeaderView = self.headerView;
        _tableView.tableFooterView = self.footerView;
        [_tableView setBackgroundColor:[UIColor clearColor]];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (UIView *)headerView
{
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 300)];
        [_headerView setBackgroundColor:[UIColor clearColor]];
        
        UIImageView *only_logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"only_logo"]];
        
        [_headerView addSubview:only_logoImageView];
        
        [only_logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_headerView);
        }];
        
        UILabel *airRunLabel = [[UILabel alloc] init];
        [_headerView addSubview:airRunLabel];
        [airRunLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
            make.top.equalTo(only_logoImageView.mas_bottom);
            make.centerX.equalTo(_headerView);
            }];
        [airRunLabel setFont:[UIFont systemFontOfSize:14]];
        [airRunLabel setTextColor:[UIColor whiteColor]];
        [airRunLabel setText:@"v1.2 (Build 1210)"];
    }
    return _headerView;
}

- (UIView *)footerView
{
    if (!_footerView) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height-300-44*3)];
        [_footerView setBackgroundColor:[UIColor whiteColor]];
    }
    return _footerView;
}

- (UIImageView *)bgImageView
{
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lowpoly"]];
    }
    return _bgImageView;
}



@end
