//
//  RunViewController.m
//  AirRun
//
//  Created by jasonWu on 4/1/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import "RunViewController.h"
#import "MapViewDelegate.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "WGS84TOGCJ02.h"
#import "RunCardView.h"
#import "RESideMenu.h"

typedef enum : NSUInteger {
    RunViewControllerRunStateStop,
    RunViewControllerRunStateRunning,
    RunViewControllerRunStatePause,
} RunViewControllerRunState;

@interface RunViewController () <CLLocationManagerDelegate>

@property (strong, nonatomic) MKMapView *mapView;
@property (strong, nonatomic) MapViewDelegate *mapViewDelegate;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSMutableArray *points;
@property (strong, nonatomic) CLLocation *currentLocation;

@property (assign, nonatomic) RunViewControllerRunState runState;

@property (strong, nonatomic) UIButton *startButton;
@property (strong, nonatomic) UIButton *contiuneButton;
@property (strong, nonatomic) UIButton *completeButton;

@property (strong, nonatomic) RunCardView *runcardView;

@property (strong, nonatomic) NSTimer *runTimer;

@end

@implementation RunViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _runState = RunViewControllerRunStateStop;
    _points = [[NSMutableArray alloc] init];
    
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithTitle:@"cehua" style:UIBarButtonItemStylePlain target:self action:@selector(menuButtonTouch:)];
    self.navigationItem.leftBarButtonItem = menuButton;
    
    [self p_setMapView];
    [self p_setLocationManager];
    [self p_setLayout];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    _runTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(runTimerEvent:) userInfo:nil repeats:YES];
    if (_runState != RunViewControllerRunStateRunning) {
        [_runTimer setFireDate:[NSDate distantFuture]];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [_runTimer invalidate];
    _runTimer = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Layout
- (void)p_setMapView {
    
    self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-64)];
    _mapViewDelegate = [[MapViewDelegate alloc] initWithMapView:_mapView];
    
    self.mapView.delegate = _mapViewDelegate;
    self.mapView.mapType = MKMapTypeStandard;
    self.mapView.showsUserLocation = YES;
    [self.view addSubview:_mapView];
    
}

- (void)p_setLocationManager {
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.distanceFilter = 5.0f;
    
    //检查是否是ios8 如果是就获得许可
    if ([_locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [_locationManager requestAlwaysAuthorization];
    }
    
    [_locationManager startUpdatingLocation];
    
    if (![CLLocationManager locationServicesEnabled] ) {
    }
}

- (void)p_setLayout {
    
    _startButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_startButton setTitle:@"开始" forState:UIControlStateNormal];
    [_startButton setTintColor:[UIColor whiteColor]];
    _startButton.frame = CGRectMake(0, 0, 100, 100);
    _startButton.layer.cornerRadius = _startButton.bounds.size.width/2;
    _startButton.clipsToBounds = YES;
    _startButton.backgroundColor = [UIColor colorWithRed:97/255.0 green:187/255.0 blue:162/255.0 alpha:1];
    _startButton.center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height-50-_startButton.bounds.size.height/2);
    [_startButton addTarget:self action:@selector(startButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_startButton];
    [self p_addShowdowWithView:_startButton];
    
    _contiuneButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_contiuneButton setTitle:@"继续" forState:UIControlStateNormal];
    [_contiuneButton setTintColor:[UIColor whiteColor]];
    _contiuneButton.backgroundColor = [UIColor colorWithRed:97/255.0 green:187/255.0 blue:162/255.0 alpha:1];
    _contiuneButton.frame = CGRectMake(0, 0, 80, 80);
    _contiuneButton.layer.cornerRadius = _contiuneButton.bounds.size.width/2;
    _contiuneButton.center = CGPointMake(self.view.bounds.size.width/4, _startButton.center.y);
    [self p_addShowdowWithView:_contiuneButton];
    [_contiuneButton addTarget:self action:@selector(contiuneButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    _completeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_completeButton setTitle:@"完成" forState:UIControlStateNormal];
    [_completeButton setTintColor:[UIColor whiteColor]];
    _completeButton.backgroundColor = [UIColor colorWithRed:245/255.0 green:143/255.0 blue:71/255.0 alpha:1];
    _completeButton.frame = CGRectMake(0, 0, 80, 80);
    _completeButton.layer.cornerRadius = _completeButton.bounds.size.width/2;
    _completeButton.center = CGPointMake(self.view.bounds.size.width*3/4, _startButton.center.y);
    [self p_addShowdowWithView:_completeButton];
    [_completeButton addTarget:self action:@selector(completeButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    _runcardView = [[RunCardView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width-30, 200)];
    _runcardView.layer.cornerRadius = 5;
    _runcardView.clipsToBounds = YES;
    _runcardView.center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height-_runcardView.bounds.size.height/2-10);
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(runcardViewTap:)];
    [_runcardView addGestureRecognizer:tapGesture];
//    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(runcardViewPan:)];
//    [_runcardView addGestureRecognizer:panGesture];
    
}
#pragma mark - Event
#pragma mark Gesture Event

- (void)runcardViewTap:(UITapGestureRecognizer *)tapGesture {
    [_runcardView removeFromSuperview];
    [self.view addSubview:_contiuneButton];
    [self.view addSubview:_completeButton];
}

- (void)runcardViewPan:(UIPanGestureRecognizer *)panGesture {
    
    NSLog(@"pan");
    
}

#pragma mark Timer Event

- (void)runTimerEvent:(NSTimer *)timer {
    _runcardView.time += 1;
}

#pragma mark Button Event

- (void)menuButtonTouch:(UIButton *)sender {
    [self.sideMenuViewController presentLeftMenuViewController];
//    - (void)presentLeftMenuViewController;
}

- (void)contiuneButtonTouch:(UIButton *)sender {
    
    [_contiuneButton removeFromSuperview];
    [_completeButton removeFromSuperview];
    [self.view addSubview:_runcardView];
}

- (void)completeButtonTouch:(UIButton *)sender {
    
}

- (void)startButtonTouch:(UIButton *)sender {
    
    [sender removeFromSuperview];
    [self.view addSubview:_runcardView];
    _runState = RunViewControllerRunStateRunning;
    [_runTimer setFireDate:[NSDate distantPast]];
}

#pragma mark - Function

- (void)p_addShowdowWithView:(UIView *)view {
    
    view.layer.masksToBounds = NO;
    view.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    view.layer.shadowOpacity = 0.8;
    view.layer.shadowRadius = 4;
    view.layer.shadowOffset = CGSizeMake(1, 1.0);
    
}

- (CGFloat)p_getCalorie:(CGFloat)time speed:(CGFloat)speed{
    
    if (speed < 0.05) {
        return 0;
    }
    
    NSInteger weight = 60;
    NSInteger sex = 0;
//    NSDictionary *user = [public GetUserModel];
//    weight = [[user objectForKey:@"weight"] integerValue];
//    sex = [[user objectForKey:@"sex"] integerValue];
    if(weight == 0){
        if(sex == 0){
            weight = 70;
        }
        if(sex == 1){
            weight = 50;
        }
    }
    CGFloat K = 30.0/speed;
    CGFloat calorie = weight * time * K;
    return calorie;
}

#pragma mark - CLLocationManager Delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    CLLocation *newLocation = locations[0];
    NSLog(@"location: %@",newLocation);
    
    //更新坐标点
    if (newLocation.coordinate.latitude == 0 || newLocation.coordinate.longitude == 0) {
        return;
    }
    
    //判断是不是属于国内范围
    if (![WGS84TOGCJ02 isLocationOutOfChina:[newLocation coordinate]]) {
        //转换后的coord
        CLLocationCoordinate2D coord = [WGS84TOGCJ02 transformFromWGSToGCJ:[newLocation coordinate]];
        newLocation = [[CLLocation alloc] initWithCoordinate:coord
                                                    altitude:newLocation.altitude
                                          horizontalAccuracy:newLocation.horizontalAccuracy
                                            verticalAccuracy:newLocation.verticalAccuracy
                                                      course:newLocation.course
                                                       speed:newLocation.speed
                                                   timestamp:newLocation.timestamp];
    }
    
    if (_runState == RunViewControllerRunStateRunning) {//是在跑步过程中
        
        CLLocationDistance distance = [newLocation distanceFromLocation:_currentLocation];
        if (distance < 5.0) {
            return;
        }
        _runcardView.currentSpeed = newLocation.speed;
        _runcardView.distance += distance;
        _runcardView.speed = _runcardView.distance/_runcardView.time;
        _runcardView.kcal += [self p_getCalorie:2.0/3600.0 speed:_runcardView.currentSpeed*3.6];
        //距离上一次提醒已经超过1公里了-----进行公里提醒
//        if (self.selfRecord.distance - self.lastestDistance >= 1000) {
//            self.lastestDistance = self.selfRecord.distance;
//            self.kilometerCount ++;
//            
//            NSURL *url = [[NSBundle mainBundle] URLForResource:@"drum01" withExtension:@"mp3"];
//            MyAudioPlayer *audioPlayer = [MyAudioPlayer sharePlayerWithURL:url];
//            [audioPlayer play];
//            
//        }
    }
    
    self.currentLocation = newLocation;
    
    if (self.runState == RunViewControllerRunStateStop) {
        self.points = [[NSMutableArray alloc] initWithArray:@[newLocation,newLocation]];
        
    } else {
        [self.points addObject:newLocation];
    }
    
    [_mapViewDelegate drawGradientPolyLineWithPoints:self.points];
    
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(newLocation.coordinate.latitude-0.001215, newLocation.coordinate.longitude);
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(center, 250, 250);
    [self.mapView setRegion:region animated:YES];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
