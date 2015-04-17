//
//  TimelineController.m
//  AirRun
//
//  Created by ChenHao on 4/4/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import "TimelineController.h"
#import "UConstants.h"
#import "TimelineTableViewCell.h"
#import "RunningRecordEntity.h"
#import "RESideMenu.h"
#import <GPUImage.h>
#import "RecordDetailViewController.h"
#import "ImageHeler.h"
#import <UIActionSheet+BlocksKit.h>
#import "PhotoViewerController.h"
#import "DocumentHelper.h"

@interface TimelineController () <TimelineTableViewCellDelegate,UIActionSheetDelegate>

@property (nonatomic, strong) UIImageView  *headerbackgroundImageView;
@property (nonatomic, strong) UIImageView  *headerImageView;
@property (nonatomic, strong) NSMutableArray      *dataSource;
@property (nonatomic, strong) UIButton     *navButton;
@property (nonatomic, strong) UILabel      *nameLabel;

@end

@implementation TimelineController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableHeaderView = [self tableHeaderView];
    [self.tableView setBackgroundColor:RGBACOLOR(252, 248, 240, 1)];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    
    if (_dataSource == 0) {
        
        UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 200)];
        UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"defaulttimeline-1"]];
        [image setFrame:CGRectMake((Main_Screen_Width-200)/2, 0, 200, 200)];
        [footer addSubview:image];
        self.tableView.tableFooterView = footer;
    }
    
    
    _navButton = [[UIButton alloc] init];
    [_navButton setImage:[UIImage imageNamed:@"navicon"] forState:UIControlStateNormal];
    [_navButton setFrame:CGRectMake(15, 25, 32, 32)];
    [_navButton addTarget:self action:@selector(menuButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_navButton];
    
    [RunningRecordEntity findAllWithCompleteBlocks:^(NSArray *arraydata) {
        _dataSource = [[NSMutableArray alloc] initWithArray:arraydata];
        [self.tableView reloadData];
    } withErrorBlock:^{
        
    }];

}


- (void)viewWillDisappear:(BOOL)animated
{
    [AVAnalytics endLogPageView:@"Timeline页面"];
    [self.tableView removeObserver:self forKeyPath:@"contentOffset"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [AVAnalytics beginLogPageView:@"Timeline页面"];
    [self.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];

    self.navigationController.navigationBarHidden = YES;
    
}
    

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_dataSource count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifer = @"timelineCell";
    TimelineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    
    RunningRecordEntity *record = [_dataSource objectAtIndex:indexPath.row];
    
    if (cell == nil) {
        cell = [[TimelineTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    }
    else{
        for (UIView *v in cell.contentView.subviews) {
            [v removeFromSuperview];
        }
    }
    [cell config:record rowAtIndexPath:indexPath];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setBackgroundColor:RGBACOLOR(252, 248, 240, 1)];
    cell.delegate = self;
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TimelineTableViewCell *cell = (TimelineTableViewCell*)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0;
}

- (UIView *)tableHeaderView
{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 200)];
    
    _headerbackgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 200)];
  
    [ImageHeler configAvatarBackground:_headerbackgroundImageView];
    
    [header addSubview:_headerbackgroundImageView];
    
    _headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake((Main_Screen_Width-80)/2, 50, 80, 80)];
    
    [ImageHeler configAvatar:_headerImageView];
    [[_headerImageView layer] setMasksToBounds:YES];
    [[_headerImageView layer] setCornerRadius:40.0];
    [[_headerImageView layer] setShadowOffset:CGSizeMake(10, 10)];
    [[_headerImageView layer] setShadowColor:[UIColor redColor].CGColor];
    [[_headerImageView layer] setShadowRadius:20];
    [[_headerImageView layer] setShadowOpacity:1];
    [[_headerImageView layer] setBorderWidth:2];
    [[_headerImageView layer] setBorderColor:[UIColor whiteColor].CGColor];
    
    [header addSubview: _headerImageView];
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, MaxY(_headerImageView)+10, Main_Screen_Width, 20)];
    [_nameLabel setTextAlignment:NSTextAlignmentCenter];
    [_nameLabel setTextColor:[UIColor whiteColor]];
    [_nameLabel setText:[[AVUser currentUser] objectForKey:@"nickName"]];
    [header addSubview:_nameLabel];

    return header;
}

#pragma mark - Delegate

- (void)TimelineTableViewCellDidSelcct:(RunningRecordEntity *)record Kcal:(NSString *)kcalText{
    
    RecordDetailViewController *vc = [[RecordDetailViewController alloc] init];
    vc.record = record;
    vc.kaclText = kcalText;
    [self presentViewController:vc animated:YES completion:^{
        
    }];
}

- (void)TimelineTableViewCellDidSelcctDelete:(RunningRecordEntity *)record rowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UIActionSheet *actionsheet = [UIActionSheet bk_actionSheetWithTitle:@"删除"];
    
    [actionsheet bk_setDestructiveButtonWithTitle:@"删除" handler:^{
        NSArray *deleteArray = @[indexPath];
        [_dataSource removeObjectAtIndex:indexPath.row];
        [record deleteEntity];
        [self.tableView deleteRowsAtIndexPaths:deleteArray withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView reloadData];
        [self findButton];
    }];
    [actionsheet bk_setCancelButtonWithTitle:@"取消" handler:^{
        
    }];
    
    [actionsheet showInView:self.view];
}

- (void)TimelineTableViewCellDidTapImage:(NSArray *)path AtIndex:(NSInteger)index
{
    
    BOOL isLocalFull = YES;
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    for (RunningImageEntity *entity in path) {
        if (![entity.localpath isEqualToString:@""] && entity.localpath !=nil) {
            if ([DocumentHelper checkPathExist:[DocumentHelper DocumentPath:entity.localpath]]) {
                [temp addObject:[UIImage imageWithContentsOfFile:[DocumentHelper DocumentPath:entity.localpath]]];
            }
            else{
                isLocalFull = NO;
                break;
            }
        }
        else{
            isLocalFull =NO;
            break;
        }
    }
    if (isLocalFull) {
       [self presentViewController:[[PhotoViewerController alloc] initWithImageArray:temp AtIndex:index] animated:YES completion:^{
           
       }];
    }
    else
    {
        [self presentViewController:[[PhotoViewerController alloc] initWithURLArray:path AtIndex:index] animated:YES completion:^{
            
        }];
    }
    
    
    
}

#pragma mark KVC
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if (![keyPath isEqualToString:@"contentOffset"]) {
        return;
    }
    else
    {
        [self scrollViewDidScroll:self.tableView];
    }
}


- (void)findButton
{
    [_navButton removeFromSuperview];
    [self.view addSubview:_navButton];
}

- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
  
    [_navButton setFrame:CGRectMake(15, 25, 32, 32)];
    
    if(offsetY < 0) {
        CGRect currentFrame = _headerbackgroundImageView.frame;
        currentFrame.origin.y = offsetY;
        currentFrame.size.height = 200+(-1)*offsetY;
        _headerbackgroundImageView.frame = currentFrame;
        CGRect currentButton = _navButton.frame;
        currentButton.origin.y = offsetY+25;
        _navButton.frame = currentButton;
        
    }
    
    CGFloat sectionHeaderHeight = 20;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
    
}

- (void)menuButtonTouch:(UIButton *)sender {
    [self.sideMenuViewController presentLeftMenuViewController];
}


@end
