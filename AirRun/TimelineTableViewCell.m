//
//  TimelineTableViewCell.m
//  AirRun
//
//  Created by ChenHao on 4/4/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import "TimelineTableViewCell.h"
#import "UConstants.h"
#import "DocumentHelper.h"

@interface TimelineTableViewCell()

@property (nonatomic, strong) RunningRecordEntity *runningRecord;
@property (nonatomic, strong) NSIndexPath *currentPath;

@property (nonatomic, strong) UIView *mainView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIView *heartView;
@property (nonatomic, strong) UIView *heartImageView;
@property (nonatomic, strong) UIView *footerView;

@property (nonatomic, strong) UIImageView *mapImageView;

@property (nonatomic, strong) UIImageView *distanceIconImageView;
@property (nonatomic, strong) UIImageView *speedIconImageView;
@property (nonatomic, strong) UIImageView *timeIconImageView;
@property (nonatomic, strong) UIImageView *kcalIconImageView;

@property (nonatomic, strong) UILabel *distanceLabel;
@property (nonatomic, strong) UILabel *speedLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *kcalLabel;
@property (nonatomic, strong) UILabel *kcalTextLabel;

@property (nonatomic, strong) UILabel *heartLabel;

@property (nonatomic, strong) NSArray *kcals;

@end


@implementation TimelineTableViewCell

- (void)config:(RunningRecordEntity *)runningRecord rowAtIndexPath:(NSIndexPath *)indexPath
{
    _runningRecord = runningRecord;
    _currentPath = indexPath;
    [self commonInit];
}

- (void)commonInit
{
    _kcals = @[
                       @{@"name":@"冰淇淋",@"kcal":@64,@"dw":@"个",@"image":@"ice"},
                       @{@"name":@"蛋糕",@"kcal":@230,@"dw":@"块",@"image":@"cake"},
                       @{@"name":@"米饭",@"kcal":@174,@"dw":@"碗",@"image":@"rice"},
                       @{@"name":@"煎蛋",@"kcal":@100,@"dw":@"个",@"image":@"egg"},
                       @{@"name":@"肉丝",@"kcal":@300,@"dw":@"盆",@"image":@"rose"},
                       ];
    //主页面
    _mainView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, Main_Screen_Width-20, 200)];

    [[_mainView layer] setShadowOffset:CGSizeMake(0, 1)]; //为阴影偏移量,默认为(左右,上下)
    [[_mainView layer] setShadowRadius:1]; //为阴影四角圆角半径,默认值为
    [[_mainView layer] setShadowOpacity:0.5]; //为阴影透明度(取值为[0,1])
    [[_mainView layer] setShadowColor:[UIColor grayColor].CGColor]; //为阴影颜色
    [_mainView setBackgroundColor:[UIColor whiteColor]];
    [[_mainView layer] setCornerRadius:4];
    [self.contentView addSubview:_mainView];
    
    [self createHeaderView];
    
    [self createMapImage];
   
    NSArray *heartImages = [RunningImageEntity getHeartArrayByIdentifer:_runningRecord.identifer];

    if (([_runningRecord.heart isEqualToString:@""]|| _runningRecord.heart ==nil) && [heartImages count]==0) {
        
        _footerView = [self createFooterView:MaxY(_mapImageView)];
        
        [_mainView addSubview:_footerView];
        [_mainView setFrame:CGRectMake(10, 10, Main_Screen_Width-20, MaxY(_footerView))];
        [self setFrame:CGRectMake(0, 0, WIDTH(_mainView), MaxY(_footerView))];
    }
    else
    {
        _heartView = [self createHeartView:MaxY(_mapImageView)];
        [_mainView addSubview:_heartView];
        
        _footerView = [self createFooterView:MaxY(_heartView)];
        
        [_mainView addSubview:_footerView];
        [_mainView setFrame:CGRectMake(10, 10, Main_Screen_Width-20, MaxY(_footerView))];
        [self setFrame:CGRectMake(0, 0, WIDTH(_mainView), MaxY(_footerView))];
    }
    [self setFrame:CGRectMake(0, 0, 100, MaxY(_footerView)+20)];
}

- (void)createHeaderView
{
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(_mainView), 50)];
    [_mainView addSubview:_headerView];
    
    UIImageView *kcalview= [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
    [kcalview setImage:[UIImage imageNamed:@"cal"]];
    [_headerView addSubview:kcalview];

    NSInteger index =  arc4random()%4;
    NSDictionary *selectDic = [_kcals objectAtIndex:index];

    _kcalTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 15, 300,25)];
    NSString *str = [NSString stringWithFormat:@"%ld Kcal   ≈   %.1f %@%@",[_runningRecord.kcar integerValue],[_runningRecord.kcar integerValue]/[[selectDic objectForKey:@"kcal"] floatValue],[selectDic objectForKey:@"dw"],[selectDic objectForKey:@"name"]];
    [_kcalTextLabel setText:str];
    [_kcalTextLabel setTextColor:RGBCOLOR(255, 164, 74)];
    [_kcalTextLabel sizeToFit];
    [_headerView addSubview:_kcalTextLabel];
    
    //UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(MaxX(kcal), 10, 30, 30)];
    //[icon setImage:[UIImage imageNamed:[selectDic objectForKey:@"image"]]];
    UIButton *shareButton = [[UIButton alloc] initWithFrame:CGRectMake(MaxX(_mainView) -50, 10, 30, 30)];
    [shareButton setImage:[UIImage imageNamed:@"dot"] forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(TouchMore:) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:shareButton];
    //[_headerView addSubview:icon];
}

- (void)createMapImage
{
    //地图截图
    _mapImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, MaxY(_headerView), WIDTH(_mainView)-20, 150)];
    _mapImageView.userInteractionEnabled = YES;
    [_mainView addSubview:_mapImageView];
    [_mapImageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
    _mapImageView.contentMode =  UIViewContentModeScaleAspectFill;
    _mapImageView.clipsToBounds = YES;
    
    NSString *imageName = [NSString stringWithFormat:@"%@.jpg",_runningRecord.identifer];
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:[DocumentHelper documentsFile:imageName AtFolder:kMapImageFolder]];
    [_mapImageView setImage:image];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disSelctMap:)];
    [_mapImageView addGestureRecognizer:tap];
    [_mapImageView addSubview:[self createDataView]];
}

- (UIView *)createDataView
{
    UIView *dataview = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT(_mapImageView)-36, WIDTH(_mapImageView), 36)];
    
    UIView *bgMask = [[UIView alloc] initWithFrame:CGRectMake(0, 0, dataview.frame.size.width, dataview.frame.size.height)];
    [bgMask setBackgroundColor:RGBACOLOR(107, 107, 107, 0.8)];
    [dataview addSubview:bgMask];
  
        _distanceIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20,8, 20, 20)];
        [_distanceIconImageView setImage:[UIImage imageNamed:@"distancetiny"]];
    
        [dataview addSubview:_distanceIconImageView];
    
    
        _distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(_distanceIconImageView)+5, 8, 100, 20)];
        [_distanceLabel setTextColor:RGBCOLOR(207, 207, 207)];
        [dataview addSubview:_distanceLabel];
    

        [_distanceLabel setText:[NSString stringWithFormat:@"%.2f km",[_runningRecord.distance integerValue]/1000.0]];
    
    
    
        _speedIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20+(Main_Screen_Width-40)/3, 8, 20, 20)];
        [_speedIconImageView setImage:[UIImage imageNamed:@"speedtiny"]];
        [dataview addSubview:_speedIconImageView];
    
    
 
        _speedLabel = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(_speedIconImageView)+5, 8, 100, 20)];
        [_speedLabel setTextColor:RGBCOLOR(207, 207, 207)];
        [dataview addSubview:_speedLabel];
    
        [_speedLabel setText:[NSString stringWithFormat:@"%.1lf km/h",[_runningRecord.averagespeed floatValue]]];
    
    
        _timeIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20+(Main_Screen_Width-40)/3*2, 8, 20, 20)];
        [_timeIconImageView setImage:[UIImage imageNamed:@"timetiny"]];
        [dataview addSubview:_timeIconImageView];
    

        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(_timeIconImageView)+5, 8, 100, 20)];
        [_timeLabel setTextColor:RGBCOLOR(207, 207, 207)];
        [dataview addSubview:_timeLabel];
        [_timeLabel setText:[NSString stringWithFormat:@"%@",[self formatTime:(long)[_runningRecord.time integerValue]]]];

    
    return dataview;
}


- (UIView *)createFooterView:(CGFloat)top
{
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, top, Main_Screen_Width, 40)];
    
    UIImageView *clockImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 13, 14, 14)];
    [clockImageView setImage:[UIImage imageNamed:@"timetiny"]];
    [footer addSubview:clockImageView];
    
    UILabel *detailTime = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, 200, 40)];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM月dd日 HH:mm"];
    
    [detailTime setText:[formatter stringFromDate:_runningRecord.finishtime]];
    [detailTime setTextColor:RGBCOLOR(138, 138, 138)];
    [detailTime setFont:[UIFont systemFontOfSize:14]];
    [footer addSubview:detailTime];
    
    UIView *location = [self createLocationView];

    [footer addSubview:location];
    
    return footer;
}

- (UIView *)createHeartView:(CGFloat)top
{
    UIView *heart = [[UIView alloc] initWithFrame:CGRectMake(30, top, Main_Screen_Width-80, 200)];
    
    UILabel *runningRecord = [[UILabel alloc] initWithFrame:CGRectMake((WIDTH(heart)-100)/2, 5, 100, 20)];
    runningRecord.text = @"跑步记录";
    [runningRecord setFont:[UIFont boldSystemFontOfSize:14]];
    [runningRecord setTextColor:RGBCOLOR(170, 170, 170)];
    [runningRecord setTextAlignment:NSTextAlignmentCenter];
    [runningRecord setBackgroundColor:[UIColor whiteColor]];
    
    UIView *splitLine = [[UIView alloc] initWithFrame:CGRectMake(20, HEIGHT(runningRecord)/2+5, WIDTH(heart)-40, 1)];
    [splitLine setBackgroundColor:RGBCOLOR(227, 227, 277)];
    
    [heart addSubview:splitLine];
    [heart addSubview:runningRecord];
    
    if(_runningRecord.heart !=nil && ![_runningRecord.heart isEqualToString:@""])
    {
        _heartLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, MaxY(runningRecord)+5, WIDTH(heart), 20)];
        _heartLabel.text = _runningRecord.heart;
        [_heartLabel setFont:[UIFont systemFontOfSize:14]];
        [_heartLabel setTextColor:RGBCOLOR(143, 143, 143)];
        _heartLabel.numberOfLines = 0;
        [_heartLabel sizeToFit];
        
    }
    else
    {
        _heartLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, MaxY(runningRecord), WIDTH(heart), 0)];
    }
    [heart addSubview:_heartLabel];
    
    
    NSArray *date = [RunningImageEntity getHeartArrayByIdentifer:_runningRecord.identifer];
    if ([date count]!=0) {
        _heartImageView = [[UIView alloc] initWithFrame:CGRectMake(0, MaxY(_heartLabel), WIDTH(heart), 80)];

        NSInteger imagewidth = (Main_Screen_Width-80-40)/5;
        NSInteger index= 0;
        for (RunningImageEntity *o in date) {
            
            UIImageView *view = [[UIImageView alloc] init];
            if (![o.localpath isEqualToString:@""] && o.localpath !=nil) {
                [view setImage:[UIImage imageWithContentsOfFile:[DocumentHelper DocumentPath:o.localpath]]];
            }
            else
            {
                AVFile *file = [AVFile fileWithURL:o.remotepath];
                [file getThumbnail:YES width:100 height:100 withBlock:^(UIImage *image, NSError *error) {
                    [view setImage:image];
                }];
                
            }
            [view setFrame:CGRectMake((imagewidth+10)*index, 12.5, imagewidth, imagewidth)];
            [[view layer] setCornerRadius:5];
            [[view layer] setMasksToBounds:YES];
            [_heartImageView addSubview:view];
            index ++;
        }
    }
    else
    {
        _heartImageView = [[UIView alloc] initWithFrame:CGRectMake(0, MaxY(_heartLabel), WIDTH(heart), 0)];
    }
    
    [heart addSubview:_heartImageView];
    [heart setFrame:CGRectMake(30, top, Main_Screen_Width-80, MaxY(_heartImageView))];
    
    return heart;
}

- (UIView *)createLocationView
{
    UIView *location = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 75, 20)];
    [location setBackgroundColor:RGBCOLOR(237, 237, 237)];
    
    UIImageView *locationImageView = [[UIImageView alloc] initWithFrame:CGRectMake(3, 3, 14, 14)];
    [locationImageView setImage:[UIImage imageNamed:@"location"]];
    [location addSubview:locationImageView];
    
    UILabel *cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(locationImageView)+3, 3, 0, 0)];
    cityLabel.text = _runningRecord.city;
    [cityLabel setFont:[UIFont systemFontOfSize:12]];
    [cityLabel setTextColor:RGBCOLOR(143, 143, 143)];
    [cityLabel sizeToFit];
    [location addSubview:cityLabel];
    
    [location setFrame:CGRectMake(Main_Screen_Width-WIDTH(cityLabel)-30 -20, 10, WIDTH(cityLabel)+25, 20)];
    return location;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}


#pragma mark Action
- (void)disSelctMap:(id)sender
{
    if ([_delegate respondsToSelector:@selector(TimelineTableViewCellDidSelcct:Kcal:)]) {
        [_delegate TimelineTableViewCellDidSelcct:_runningRecord Kcal:_kcalTextLabel.text];
    }
}

- (void)TouchMore:(id)sender
{
    if ([_delegate respondsToSelector:@selector(TimelineTableViewCellDidSelcctDelete:rowAtIndexPath:)]) {
        [_delegate TimelineTableViewCellDidSelcctDelete:_runningRecord rowAtIndexPath:_currentPath];
    }
}


#pragma mark function
- (NSString *)formatTime:(NSInteger)seconds
{
    if (seconds > 3600) {
        return [NSString stringWithFormat:@"%0.2ld:%0.2ld:%0.2ld",seconds/3600,seconds/60,seconds%60];
    }
    else
    {
        return [NSString stringWithFormat:@"%0.2ld:%0.2ld",seconds/60,seconds%60];
    }
    return nil;
}

@end
