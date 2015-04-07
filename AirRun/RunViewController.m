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
#import "RunSimpleCardView.h"
#import <POP.h>
#import "RunViewControllerAnimation.h"
#import "RunPauseView.h"
#import "RunningRecord.h"
#import "RunCompleteCardsVC.h"
#import <AVFoundation/AVFoundation.h>
#import "CountView.h"
#import "RunningImage.h"
#import "DocumentHelper.h"
#import "DataBaseHelper.h"
#import <objc/runtime.h>

typedef enum : NSUInteger {
    RunViewControllerRunStateStop,
    RunViewControllerRunStateRunning,
    RunViewControllerRunStatePause,
} RunViewControllerRunState;

const static NSInteger RuncardViewHieght = 150;
const static NSInteger RunSimpleCardViewHeight = 70;
const static NSInteger PauseViewHeight = 50;

const char *INPOSITION = "InPosition";
const char *OUTPOSITION = "OutPosition";

@interface RunViewController () <CLLocationManagerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) AVAudioPlayer *audioPlayer;
@property (strong, nonatomic) CountView *countView;

@property (strong, nonatomic) UIBarButtonItem *photoButton;

@property (strong, nonatomic) MKMapView *mapView;
@property (strong, nonatomic) MapViewDelegate *mapViewDelegate;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSMutableArray *points;
@property (strong, nonatomic) NSMutableArray *imageArray;
@property (strong, nonatomic) CLLocation *currentLocation;

@property (assign, nonatomic) RunViewControllerRunState runState;

@property (strong, nonatomic) UIButton *startButton;
@property (strong, nonatomic) UIButton *pauseButton;
@property (strong, nonatomic) UIButton *contiuneButton;
@property (strong, nonatomic) UIButton *completeButton;

@property (strong, nonatomic) RunPauseView *pauseView;
@property (strong, nonatomic) RunCardView *runcardView;
@property (strong, nonatomic) RunSimpleCardView *runSimpleCardView;
@property (assign, nonatomic) CGPoint runCardViewLastPoint;
@property (assign, nonatomic) CGFloat runCardLastKmDistance;

@property (strong, nonatomic) NSTimer *runTimer;

@end

@implementation RunViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _runState = RunViewControllerRunStateStop;
    _points = [[NSMutableArray alloc] init];
    _imageArray = [[NSMutableArray alloc] init];
    
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithTitle:@"cehua" style:UIBarButtonItemStylePlain target:self action:@selector(menuButtonTouch:)];
    self.navigationItem.leftBarButtonItem = menuButton;
    
    _photoButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"setting.png"] style:UIBarButtonItemStylePlain target:self action:@selector(photoButtonTouch:)];
    self.navigationItem.rightBarButtonItem = _photoButton;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bg.png"]
                       forBarPosition:UIBarPositionAny
                           barMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    [self p_setMapView];
    [self p_setLocationManager];
    [self p_setLayout];
    [self p_setStartRunLayout];
    
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
    _startButton.center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height-10-_startButton.bounds.size.height/2);
    [_startButton addTarget:self action:@selector(startButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_startButton];
    
}

- (void)p_setStartRunLayout {
    
    _pauseButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_pauseButton setTitle:@"暂停" forState:UIControlStateNormal];
    [_pauseButton setTintColor:[UIColor whiteColor]];
    _pauseButton.frame = CGRectMake(0, 0, 100, 100);
    _pauseButton.layer.cornerRadius = _startButton.bounds.size.width/2;
    _pauseButton.clipsToBounds = YES;
    _pauseButton.backgroundColor = [UIColor colorWithRed:255/255.0 green:143/255.0 blue:94/255.0 alpha:1];
//    _pauseButton.center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height-50-_startButton.bounds.size.height/2);
    _pauseButton.center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height+_pauseButton.bounds.size.height/2+10);
    [_pauseButton addTarget:self action:@selector(pauseButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_pauseButton];
    
    _pauseView = [[RunPauseView alloc] initWithFrame:CGRectMake(0, -PauseViewHeight, self.view.bounds.size.width, PauseViewHeight)];
    [self.view addSubview:_pauseView];
    
    _contiuneButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_contiuneButton setTitle:@"继续" forState:UIControlStateNormal];
    [_contiuneButton setTintColor:[UIColor whiteColor]];
    _contiuneButton.backgroundColor = [UIColor colorWithRed:97/255.0 green:187/255.0 blue:162/255.0 alpha:1];
    _contiuneButton.frame = CGRectMake(0, 0, 80, 80);
    _contiuneButton.layer.cornerRadius = _contiuneButton.bounds.size.width/2;
    _contiuneButton.center = CGPointMake(-_contiuneButton.bounds.size.width/2-10, _startButton.center.y);
    [self.view addSubview:_contiuneButton];
    //    _contiuneButton.center = CGPointMake(self.view.bounds.size.width/4, _startButton.center.y);
    [self p_addShowdowWithView:_contiuneButton];
    [_contiuneButton addTarget:self action:@selector(contiuneButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    _completeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_completeButton setTitle:@"完成" forState:UIControlStateNormal];
    [_completeButton setTintColor:[UIColor whiteColor]];
    _completeButton.backgroundColor = [UIColor colorWithRed:245/255.0 green:143/255.0 blue:71/255.0 alpha:1];
    _completeButton.frame = CGRectMake(0, 0, 80, 80);
    _completeButton.layer.cornerRadius = _completeButton.bounds.size.width/2;
    _completeButton.center = CGPointMake(self.view.bounds.size.width+_completeButton.bounds.size.width/2+10, _startButton.center.y);
    [self.view addSubview:_completeButton];
    //    _completeButton.center = CGPointMake(self.view.bounds.size.width*3/4, _startButton.center.y);
    [self p_addShowdowWithView:_completeButton];
    [_completeButton addTarget:self action:@selector(completeButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    _runcardView = [[RunCardView alloc] initWithFrame:CGRectMake(0, -RuncardViewHieght, self.view.bounds.size.width, RuncardViewHieght)];
    _runcardView.clipsToBounds = YES;
    __weak RunViewController *this = self;
    _runcardView.retractTouchBlock = ^(UIButton * button) {
        
        [RunViewControllerAnimation view:this.pauseButton
                   SlideOutToCenterPoint: CGPointMake(this.view.bounds.size.width/2, this.view.bounds.size.height+this.pauseButton.bounds.size.height/2+10)
              AnimationWthiCompleteBlock:nil];
        
        [this.navigationController setNavigationBarHidden:YES animated:YES];
        [UIView animateWithDuration:0.5 animations:^{
            this.runcardView.frame = CGRectMake(0, -RuncardViewHieght, this.view.bounds.size.width, RuncardViewHieght);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3 animations:^{
                
                this.runSimpleCardView.frame = CGRectMake(0, 0, this.view.bounds.size.width, RunSimpleCardViewHeight);
            }];
            
        }];
        
    };
    [self.view addSubview:_runcardView];

    
    _runSimpleCardView = [[RunSimpleCardView alloc] initWithFrame:CGRectMake(0, -RunSimpleCardViewHeight, self.view.bounds.size.width, RunSimpleCardViewHeight)];
    _runSimpleCardView.clipsToBounds = YES;
    //    _runSimpleCardView.center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height+_runSimpleCardView.bounds.size.height/2);
    _runSimpleCardView.retractButtonBlock = ^(UIButton *button){
        
        [RunViewControllerAnimation view:this.pauseButton
                    SlideInToCenterPoint: CGPointMake(this.view.bounds.size.width/2, this.view.bounds.size.height-10- this.pauseButton.bounds.size.height/2)
              AnimationWthiCompleteBlock:^(POPAnimation *anim, BOOL finished){
                  [RunViewControllerAnimation scalAnimationWithView:this.pauseButton WithCompleteBlock:nil];
              }];
        
        [UIView animateWithDuration:0.3 animations:^{
            this.runSimpleCardView.frame = CGRectMake(0, -RunSimpleCardViewHeight, this.view.bounds.size.width, RunSimpleCardViewHeight);
        } completion:^(BOOL finished) {
            [this.navigationController setNavigationBarHidden:NO animated:YES];
            [UIView animateWithDuration:0.5 animations:^{
//                this.navigationController.navigationBar.frame = CGRectMake(0, 0, this.view.bounds.size.width, 64);
                this.runcardView.frame = CGRectMake(0, 64, this.view.bounds.size.width, RuncardViewHieght);
            }];
        }];

    };
    [self.view addSubview:_runSimpleCardView];
    
    
}
#pragma mark - Event
#pragma mark Timer Event

- (void)runTimerEvent:(NSTimer *)timer {
    _runcardView.time += 1;
    _runSimpleCardView.time = _runcardView.time;
}

#pragma mark Button Event

- (void)pauseButtonTouch:(UIButton *)sender {
    
    [RunViewControllerAnimation scalAnimationWithView:sender WithCompleteBlock:^(POPAnimation *anim, BOOL finished) {
        
        [self p_pause];
        [UIView animateWithDuration:0.3 animations:^{
            self.runcardView.frame = CGRectMake(0, -RuncardViewHieght, self.view.bounds.size.width, RuncardViewHieght);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3 animations:^{
                self.pauseView.frame = CGRectMake(0, 64, self.view.bounds.size.width, PauseViewHeight);
            }];
        }];

        
        [RunViewControllerAnimation view:_pauseButton
                   SlideOutToCenterPoint: CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height+_pauseButton.bounds.size.height/2+10)
              AnimationWthiCompleteBlock:^(POPAnimation *anim, BOOL finished) {
                  
                  [RunViewControllerAnimation view:_contiuneButton
                             SlideInToCenterPoint: CGPointMake(self.view.bounds.size.width/4,self.view.bounds.size.height-10-_startButton.bounds.size.height/2)
                        AnimationWthiCompleteBlock:^(POPAnimation *anim, BOOL finished){
                            [RunViewControllerAnimation scalAnimationWithView:_contiuneButton WithCompleteBlock:nil];
                        }];
                  
                  [RunViewControllerAnimation view:_completeButton
                             SlideInToCenterPoint: CGPointMake(self.view.bounds.size.width*3/4,self.view.bounds.size.height-10-_startButton.bounds.size.height/2)
                        AnimationWthiCompleteBlock:^(POPAnimation *anim, BOOL finished) {
                            [RunViewControllerAnimation scalAnimationWithView:_completeButton WithCompleteBlock:nil];
                        }];
                  
              }];
    }];
    
}

- (void)photoButtonTouch:(UIBarButtonItem *)sender {
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)menuButtonTouch:(UIButton *)sender {
    [self.sideMenuViewController presentLeftMenuViewController];
}

- (void)contiuneButtonTouch:(UIButton *)sender {
    
    [RunViewControllerAnimation scalAnimationWithView:sender WithCompleteBlock:^(POPAnimation *anim, BOOL finished) {
        
        [self p_audioPlay:@"continue"];
        [self p_continue];
        
        [RunViewControllerAnimation view:_contiuneButton
                   SlideOutToCenterPoint: CGPointMake(-_contiuneButton.bounds.size.width/2-10, self.view.bounds.size.height-10-_startButton.bounds.size.height/2)
              AnimationWthiCompleteBlock:^(POPAnimation *anim, BOOL finished) {
                  
                  [RunViewControllerAnimation view:_pauseButton
                              SlideInToCenterPoint: CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height-_pauseButton.bounds.size.height/2-10)
                        AnimationWthiCompleteBlock:^(POPAnimation *anim, BOOL finished) {
                            [RunViewControllerAnimation scalAnimationWithView:_pauseButton WithCompleteBlock:nil];
                        }];
              }];
        
        [RunViewControllerAnimation view:_completeButton
                   SlideOutToCenterPoint:CGPointMake(self.view.bounds.size.width+_completeButton.bounds.size.width/2+10, self.view.bounds.size.height-10-_startButton.bounds.size.height/2)
              AnimationWthiCompleteBlock:nil];
        
        [UIView animateWithDuration:0.3 animations:^{
            _pauseView.frame = CGRectMake(0, -PauseViewHeight, self.view.bounds.size.width, PauseViewHeight);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3 animations:^{
                _runcardView.frame = CGRectMake(0, 64, self.view.bounds.size.width, RuncardViewHieght);
            }];
        }];
        
    }];
    
    
    
}

- (void)completeButtonTouch:(UIButton *)sender {
    
    RunningRecord *record = [[RunningRecord alloc] init];
    record.path = [self p_convertPointsToJsonString];
    record.time = @(_runcardView.time);
    record.kcar = @(_runcardView.kcal);
    record.distance = @(_runcardView.distance);
//    @property (nonatomic, strong) NSString  *weather;
//    @property (nonatomic, strong) NSNumber  *pm25;
    record.averagespeed = @(_runcardView.speed);
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    record.finishtime = [dateFormatter stringFromDate:[NSDate date]];
//    @property (nonatomic, strong) AVFile  *mapshot;
    
    RunCompleteCardsVC *vc = [[RunCompleteCardsVC alloc] initWithParameters:record WithPoints:_points WithImages:_imageArray];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)startButtonTouch:(UIButton *)sender {
    
    //动画
    
    [RunViewControllerAnimation scalAnimationWithView:sender WithCompleteBlock:^(POPAnimation *anim, BOOL finished) {
        
        //逻辑
        [self p_audioPlay:@"start"];
        _runState = RunViewControllerRunStateRunning;
        [_runTimer setFireDate:[NSDate distantPast]];
        [_mapViewDelegate addImage:[UIImage imageNamed:@"setting.png"] AtLocation:_points.firstObject];

        
        [UIView animateWithDuration:0.3 animations:^{
            _runcardView.frame = CGRectMake(0, 64, self.view.bounds.size.width, RuncardViewHieght);
        }];
        
        [RunViewControllerAnimation view:_startButton
                   SlideOutToCenterPoint:CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height+10+_startButton.bounds.size.height/2)
              AnimationWthiCompleteBlock:^(POPAnimation *anim, BOOL finished){
                  
                  //暂停按钮滑入
                  [RunViewControllerAnimation view:_pauseButton
                              SlideInToCenterPoint: CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height-10-_startButton.bounds.size.height/2)
                        AnimationWthiCompleteBlock:^(POPAnimation *anim, BOOL finished){
                            [RunViewControllerAnimation scalAnimationWithView:_pauseButton WithCompleteBlock:nil];
                        }];
                  
              }];

    }];
    
}

#pragma mark - Function


- (void)p_addShowdowWithView:(UIView *)view {
    
    view.layer.masksToBounds = NO;
    view.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    view.layer.shadowOpacity = 0.8;
    view.layer.shadowRadius = 4;
    view.layer.shadowOffset = CGSizeMake(1, 1.0);
    
}

#pragma mark Private Function

- (void)p_audioPlay:(NSString *)name {
    
    NSURL *startUrl = [[NSBundle mainBundle] URLForResource:name withExtension:@"m4a"];
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:startUrl error:nil];
    [_audioPlayer prepareToPlay];
    [_audioPlayer play];
    
}

- (NSString *)p_convertPointsToJsonString {
    
    NSMutableArray *pointDicArray = [[NSMutableArray alloc] init];
    for (CLLocation *location in self.points) {
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
        
        //键:值
        NSDictionary *pointDic = @{@"latitude":[NSNumber numberWithDouble:location.coordinate.latitude],
                                   @"longitude":[NSNumber numberWithDouble:location.coordinate.longitude],
                                   @"altitude":[NSNumber numberWithDouble:location.altitude],
                                   @"hAccuracy":[NSNumber numberWithDouble:location.horizontalAccuracy],
                                   @"vAccuracy":[NSNumber numberWithDouble:location.verticalAccuracy],
                                   @"course":[NSNumber numberWithDouble:location.course],
                                   @"speed":[NSNumber numberWithDouble:location.speed],
                                   @"timestamp":[dateFormatter stringFromDate:location.timestamp]
                                   };
        [pointDicArray addObject:pointDic];
        
    }
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:pointDicArray options:NSJSONWritingPrettyPrinted error:&error];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

- (void)p_continue {
    
    _runState = RunViewControllerRunStateRunning;
    [_runTimer setFireDate:[NSDate distantPast]];
    
}

- (void)p_pause {
    
    _runState = RunViewControllerRunStatePause;
    [_runTimer setFireDate:[NSDate distantFuture]];
    
    _pauseView.time = _runcardView.time;
    _pauseView.distance = _runcardView.distance;
    _pauseView.speed = _runcardView.speed;
    _pauseView.kcal = _runcardView.kcal;
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
        _runcardView.gps = newLocation.horizontalAccuracy;
        
        _runSimpleCardView.distance = _runcardView.distance;
        _runSimpleCardView.speed = _runcardView.speed;
        
        //距离上一次提醒已经超过1公里了-----进行公里提醒和地图上显示图标
        if (_runcardView.distance - _runCardLastKmDistance >= 1000) {
            _runCardLastKmDistance = _runcardView.distance;
            
            NSInteger km = _runcardView.distance/1000;
            NSString *audioName = [NSString stringWithFormat:@"%ldkilo",(long)km];
            [self p_audioPlay:audioName];
            
            [_mapViewDelegate addImage:[UIImage imageNamed:@"setting.png"] AtLocation:newLocation];
            
        }
    }
    
    self.currentLocation = newLocation;
    
    if (self.runState == RunViewControllerRunStateStop) {
        self.points = [[NSMutableArray alloc] initWithArray:@[newLocation,newLocation]];
        
    } else {
        [self.points addObject:newLocation];
    }
    
    [_mapViewDelegate drawGradientPolyLineWithPoints:self.points];
    
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(newLocation.coordinate.latitude+0.000215, newLocation.coordinate.longitude);
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(center, 250, 250);
    [self.mapView setRegion:region animated:YES];
    
}

#pragma mark - UIImagePickerController Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    if (info) {
        UIImage *image = info[@"UIImagePickerControllerOriginalImage"];
        [_mapViewDelegate addimage:image AnontationWithLocation:_currentLocation];
        
        RunningImage *imgM = [[RunningImage alloc] init];
        NSData *imgData = UIImageJPEGRepresentation(image, 0.5);
        imgM.image = [AVFile fileWithData:imgData];
        imgM.longitude = [NSString stringWithFormat:@"%lf",_currentLocation.coordinate.longitude];
        imgM.latitude = [NSString stringWithFormat:@"%lf",_currentLocation.coordinate.latitude];
        
        [_imageArray addObject:imgM];
        
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
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
