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

@end

@implementation RecordDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self p_setNavgation];
    [self p_layout];
    [self p_setMapView];
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
}

- (void)p_setMapView {
    _mapViewDelegate = [[MapViewDelegate alloc] initWithMapView:_mapView];
    _mapView.delegate = _mapViewDelegate;
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
