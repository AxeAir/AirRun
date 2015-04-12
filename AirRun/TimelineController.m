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

@interface TimelineController () <TimelineTableViewCellDelegate>

@property (nonatomic, strong) UIImageView  *headerbackgroundImageView;
@property (nonatomic, strong) UIImageView  *headerImageView;
@property (nonatomic, strong) NSArray      *dataSource;
@property (nonatomic, strong) UIButton     *navButton;
@property (nonatomic, strong) UILabel      *nameLabel;

@end

@implementation TimelineController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableHeaderView = [self tableHeaderView];
    [self.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    [self.tableView setBackgroundColor:RGBCOLOR(240, 240, 240)];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    
    _navButton = [[UIButton alloc] init];
    [_navButton setImage:[UIImage imageNamed:@"navicon"] forState:UIControlStateNormal];
    [_navButton setFrame:CGRectMake(15, 25, 32, 32)];
    [_navButton addTarget:self action:@selector(menuButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_navButton];
    
    
    [RunningRecordEntity findAllWithCompleteBlocks:^(NSArray *arraydata) {
        _dataSource = arraydata;
        [self.tableView reloadData];
    } withErrorBlock:^{
        
    }];
   
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.tableView removeObserver:self forKeyPath:@"contentOffset"];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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
        cell = [[TimelineTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer runningRecord:record];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.delegate = self;
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TimelineTableViewCell *cell = (TimelineTableViewCell*)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
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
    
    AVFile *avatarData = [[AVUser currentUser] objectForKey:@"avatar"];
    NSData *resumeData = [avatarData getData];
    
    if (resumeData!=nil) {
        UIImage *inputImage = [UIImage imageWithData:resumeData];
        GPUImagePicture *stillImageSource = [[GPUImagePicture alloc] initWithImage:inputImage];
        GPUImageiOSBlurFilter *stillImageFilter = [[GPUImageiOSBlurFilter alloc] init];
        
        [stillImageFilter setBlurRadiusInPixels:4];
        [stillImageSource addTarget:stillImageFilter];
        [stillImageFilter useNextFrameForImageCapture];
        [stillImageSource processImage];
        
        UIImage *currentFilteredVideoFrame = [stillImageFilter imageFromCurrentFramebuffer];
        
        [_headerbackgroundImageView setImage:currentFilteredVideoFrame];
    }
    else
    {
        UIImage *inputImage = [UIImage imageNamed:@"defaultTimeline"];
        GPUImagePicture *stillImageSource = [[GPUImagePicture alloc] initWithImage:inputImage];
        GPUImageiOSBlurFilter *stillImageFilter = [[GPUImageiOSBlurFilter alloc] init];
        
        [stillImageFilter setBlurRadiusInPixels:4];
        [stillImageSource addTarget:stillImageFilter];
        [stillImageFilter useNextFrameForImageCapture];
        [stillImageSource processImage];
        
        UIImage *currentFilteredVideoFrame = [stillImageFilter imageFromCurrentFramebuffer];
        
        [_headerbackgroundImageView setImage:currentFilteredVideoFrame];
        
    }
    
    [header addSubview:_headerbackgroundImageView];
    
    _headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake((Main_Screen_Width-80)/2, 50, 80, 80)];
    
    if (resumeData!=nil) {
        [_headerImageView setImage:[UIImage imageWithData:resumeData]];
    }
    else
    {
        [_headerImageView setImage:[UIImage imageNamed:@"weiboshare"]];
    }
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

- (void)TimelineTableViewCellDidSelcct:(RunningRecordEntity *)record {
    
    RecordDetailViewController *vc = [[RecordDetailViewController alloc] init];
    vc.record = record;
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self.navigationController pushViewController:vc animated:YES];
    
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

- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    NSLog(@"%f",offsetY);
    
    [_navButton setFrame:CGRectMake(15, 25, 32, 32)];
    
    if(offsetY < 0) {
        CGRect currentFrame = _headerbackgroundImageView.frame;
        currentFrame.origin.y = offsetY;
        currentFrame.size.height = 200+(-1)*offsetY;
        NSLog(@"height:%f", currentFrame.size.height);
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
