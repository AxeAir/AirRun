//
//  RecordDetailViewController.m
//  AirRun
//
//  Created by JasonWu on 4/9/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import "RecordDetailViewController.h"
#import <MapKit/MapKit.h>
#import "MapViewDelegate.h"
#import "RunningRecordEntity.h"
#import "DateHelper.h"
#import "RunningImageEntity.h"
#import "DocumentHelper.h"
#import "DateHelper.h"

@interface RecordDetailViewController ()

@property (weak, nonatomic) IBOutlet UIView *cardView;

@property (weak, nonatomic) IBOutlet UILabel *locationNameLabel;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UILabel *timeLable;
@property (weak, nonatomic) IBOutlet UILabel *tempertureAndPMLable;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) MapViewDelegate *mapViewDelegate;

@property (weak, nonatomic) IBOutlet UILabel *avgSpeedLable;
@property (weak, nonatomic) IBOutlet UILabel *durationLable;
@property (weak, nonatomic) IBOutlet UILabel *distanceLable;

@property (weak, nonatomic) IBOutlet UILabel *kcalLable;
@property (weak, nonatomic) IBOutlet UILabel *numAppleLabel;

@property (strong, nonatomic) NSMutableArray *path;
@property (strong, nonatomic) NSArray *imgEntities;

@end

@implementation RecordDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    [self p_getData];
    [self p_setNavgation];
    [self p_layout];
    [self p_setMapView];
    
}

- (void)p_getData {
   
    NSData *arrayData = [_record.path dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *dicArray = [NSJSONSerialization JSONObjectWithData:arrayData options:NSJSONReadingMutableContainers error:nil];
    _path = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dic in dicArray) {
        CLLocationCoordinate2D coordinate2D = CLLocationCoordinate2DMake([dic[@"latitude"] doubleValue], [dic[@"longitude"] doubleValue]);
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss zzz";
        CLLocation *loc = [[CLLocation alloc] initWithCoordinate:coordinate2D
                                                        altitude:[dic[@"altitude"] doubleValue]
                                              horizontalAccuracy:[dic[@"hAccuracy"] doubleValue]
                                                verticalAccuracy:[dic[@"vAccuracy"] doubleValue]
                                                          course:[dic[@"course"] doubleValue]
                                                           speed:[dic[@"speed"] doubleValue]
                                                       timestamp:[formatter dateFromString:dic[@"timestamp"]]];
        [_path addObject:loc];
    }
    
    _imgEntities = [RunningImageEntity getEntitiesWithArrtribut:@"recordid" WithValue:_record.identifer];
    
}

#pragma mark - Layout

- (void)p_setNavgation {
    
    self.title = @"详细记录";
    UIBarButtonItem *sharButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"setting.png"] style:UIBarButtonItemStylePlain target:self action:@selector(shareButtonTouch:)];
    self.navigationItem.rightBarButtonItem = sharButton;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
}

- (void)p_layout {
    _topView.layer.cornerRadius = 5;
    
    _cardView.layer.cornerRadius = 5;
    _cardView.layer.shadowOffset = CGSizeMake(1, 1);
    _cardView.layer.shadowRadius = 5;
    _cardView.layer.shadowOpacity = 0.5;
    
    _locationNameLabel.text = _record.city;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MM-dd HH:mm";
    _timeLable.text = [formatter stringFromDate:_record.finishtime];
    
    _tempertureAndPMLable.text = [NSString stringWithFormat:@"%@ ℃\nPM %ld",_record.weather,[_record.pm25 longValue]];
    
    _avgSpeedLable.text = [NSString stringWithFormat:@"%.1f",[_record.averagespeed floatValue]];
    _durationLable.text = [DateHelper converSecondsToTimeString:[_record.time integerValue]];
    _distanceLable.text = [NSString stringWithFormat:@"%.2f",[_record.distance floatValue]/1000];
    _kcalLable.text = [NSString stringWithFormat:@"%.0f",[_record.kcar floatValue]/1000];
//    @property (weak, nonatomic) IBOutlet UILabel *numAppleLabel;
}

- (void)p_setMapView {
    _mapViewDelegate = [[MapViewDelegate alloc] initWithMapView:_mapView];
    _mapView.delegate = _mapViewDelegate;
    
    [_mapViewDelegate drawPath:_path];
    
    for (RunningImageEntity *imgEntity in _imgEntities) {
        
        NSString *imgName = [imgEntity.image lastPathComponent];
        UIImage *img = [UIImage imageWithContentsOfFile:[DocumentHelper documentsFile:imgName AtFolder:kPathImageFolder]];
        CLLocation *loc = [[CLLocation alloc] initWithLatitude:[imgEntity.latitude doubleValue] longitude:[imgEntity.longitude doubleValue]];
        
        [_mapViewDelegate addimage:img AnontationWithLocation:loc];
    }
}



#pragma mark - Event
#pragma mark Button event
- (void)shareButtonTouch:(UIBarButtonItem *)button {
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end