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
#import <BlurImageProcessor/ALDBlurImageProcessor.h>
#import "RunningRecordEntity.h"

@interface TimelineController ()

@property (nonatomic, strong) UIImageView *headerbackgroundImageView;
@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UIView *headerShadow;
@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation TimelineController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableHeaderView = [self tableHeaderView];
    [self.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    [self.tableView setBackgroundColor:RGBCOLOR(240, 240, 240)];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [RunningRecordEntity findAllWithCompleteBlocks:^(NSArray *arraydata) {
         _dataSource = arraydata;
        [self.tableView reloadData];
    } withErrorBlock:^{
        
    }];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
    record.weather = @"dd";
    record.heart = @"跑步记录跑步记录跑步记录跑步记录跑步记录跑步记录跑步记录跑步记录跑步记录跑步记录跑步记录跑步记录跑步记录";
    
    if (cell == nil) {
        cell = [[TimelineTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer runningRecord:record];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
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
    
    ALDBlurImageProcessor *blurImageProcessor = [[ALDBlurImageProcessor alloc] initWithImage: [UIImage imageNamed:@"header1.jpg"]];

    [blurImageProcessor asyncBlurWithRadius:50 iterations:7 successBlock:^(UIImage *blurredImage) {
        [_headerbackgroundImageView setImage:blurredImage];
    } errorBlock:^(NSNumber *errorCode) {
        
    }];
    [header addSubview:_headerbackgroundImageView];
    
    _headerShadow= [[UIView alloc] initWithFrame: CGRectMake((Main_Screen_Width-80)/2, 50, 80, 80)];
    
    // setup shadow layer and corner
    _headerShadow.layer.shadowColor = [UIColor redColor].CGColor;
    _headerShadow.layer.shadowOffset = CGSizeMake(0, 1);
    _headerShadow.layer.shadowOpacity = 1;
    _headerShadow.layer.shadowRadius = 9.0;
    _headerShadow.layer.cornerRadius = 4.0;
    _headerShadow.clipsToBounds = NO;
    
    // combine the views
    [header addSubview: _headerShadow];
    
    _headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    [_headerImageView setImage:[UIImage imageNamed:@"header1.jpg"]];
    [[_headerImageView layer] setMasksToBounds:YES];
    [[_headerImageView layer] setCornerRadius:40.0];
    [[_headerImageView layer] setShadowOffset:CGSizeMake(10, 10)];
    [[_headerImageView layer] setShadowColor:[UIColor redColor].CGColor];
    [[_headerImageView layer] setShadowRadius:20];
    [[_headerImageView layer] setShadowOpacity:1];
    
    [_headerShadow addSubview:_headerImageView];
    
    
    return header;
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
    if(offsetY < 0) {
        CGRect currentFrame = _headerbackgroundImageView.frame;
        currentFrame.origin.y = offsetY;
        currentFrame.size.height = 200+(-1)*offsetY;
        NSLog(@"height:%f", currentFrame.size.height);
        _headerbackgroundImageView.frame = currentFrame;
    }
    
    CGFloat sectionHeaderHeight = 20;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
    
}

@end
