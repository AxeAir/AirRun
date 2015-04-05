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
#import "RunningRecordModel.h"
#import "RunCompleteCardsVC.h"
#import <AVFoundation/AVFoundation.h>
#import "CountView.h"

typedef enum : NSUInteger {
    RunViewControllerRunStateStop,
    RunViewControllerRunStateRunning,
    RunViewControllerRunStatePause,
} RunViewControllerRunState;

@interface RunViewController () <CLLocationManagerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) AVAudioPlayer *audioPlayer;
@property (strong, nonatomic) CountView *countView;

@property (strong, nonatomic) MKMapView *mapView;
@property (strong, nonatomic) MapViewDelegate *mapViewDelegate;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSMutableArray *points;
@property (strong, nonatomic) NSMutableArray *imageArray;
@property (strong, nonatomic) CLLocation *currentLocation;

@property (assign, nonatomic) RunViewControllerRunState runState;

@property (strong, nonatomic) UIButton *startButton;
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
    
    _pauseView = [[RunPauseView alloc] initWithFrame:CGRectMake(0, 64-50, self.view.bounds.size.width, 50)];
    [self.view addSubview:_pauseView];
    
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
    
    _runcardView = [[RunCardView alloc] initWithFrame:CGRectMake(0, 0, 30, 10)];
    _runcardView.layer.cornerRadius = 5;
    _runcardView.clipsToBounds = YES;
    _runcardView.center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height- 100 -10);
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(runcardViewPan:)];
    [_runcardView addGestureRecognizer:panGesture];
    __weak RunViewController *this = self;
    _runcardView.retractTouchBlock = ^(UIButton * button) {
        
        [RunViewControllerAnimation view:this.runcardView
                   SlideOutToCenterPoint:CGPointMake(this.view.bounds.size.width/2, this.view.bounds.size.height+this.runcardView.bounds.size.height/2) AnimationWthiCompleteBlock:^(POPAnimation *anim, BOOL finished) {
                       
                       [RunViewControllerAnimation view:this.runSimpleCardView
                                   SlideInToCenterPoint:CGPointMake(this.view.bounds.size.width/2, this.view.bounds.size.height-this.runSimpleCardView.bounds.size.height/2-10)
                             AnimationWthiCompleteBlock:nil];
                       
                   }];
        
    };
    _runcardView.photoTouchBlock = ^(UIButton *button){
        
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePickerController.delegate = this;
        imagePickerController.editing = YES;
        [this presentViewController:imagePickerController animated:YES completion:nil];
        
    };
    
    _runSimpleCardView = [[RunSimpleCardView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width-30, 60)];
    _runSimpleCardView.layer.cornerRadius = 5;
    _runSimpleCardView.clipsToBounds = YES;
//    _runSimpleCardView.center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height-_runSimpleCardView.bounds.size.height/2-10);
    _runSimpleCardView.center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height+_runSimpleCardView.bounds.size.height/2);
    _runSimpleCardView.retractButtonBlock = ^(UIButton *button){
        
        [RunViewControllerAnimation view:this.runSimpleCardView
                   SlideOutToCenterPoint:CGPointMake(this.view.bounds.size.width/2, this.view.bounds.size.height+this.runSimpleCardView.bounds.size.height/2)
              AnimationWthiCompleteBlock:^(POPAnimation *anim, BOOL finished) {
                  
                  [RunViewControllerAnimation view:this.runcardView
                              SlideInToCenterPoint:CGPointMake(this.view.bounds.size.width/2, this.view.bounds.size.height- 100 -10)
                        AnimationWthiCompleteBlock:nil];
                  
              }];
        
    };
    [self.view addSubview:_runSimpleCardView];
    
}
#pragma mark - Event
#pragma mark Gesture Event

- (void)runcardViewPan:(UIPanGestureRecognizer *)panGesture {
    
    UIView *view = panGesture.view;
    CGPoint point = [panGesture locationInView:self.view];
    
    if (panGesture.state == UIGestureRecognizerStateBegan) {
        _runCardViewLastPoint = point;
    } else if (panGesture.state == UIGestureRecognizerStateChanged) {
        
        CGFloat deltaY = point.y - _runCardViewLastPoint.y;
        CGRect frame = view.frame;
        frame.origin.y += deltaY;
        
        if (frame.origin.y < self.view.bounds.size.height-10-view.bounds.size.height) {
            return;
        }
        
        _runcardView.frame = frame;
        _runCardViewLastPoint = point;
    } else if (panGesture.state == UIGestureRecognizerStateEnded) {
        
        if (view.frame.origin.y > self.view.bounds.size.height - 10 -view.bounds.size.height/2) {
            //运动卡片下移动出界面
            [RunViewControllerAnimation view:view
                       SlideOutToCenterPoint:CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height+view.bounds.size.height/2)
                  AnimationWthiCompleteBlock:^(POPAnimation *anim, BOOL finished) {
                      
                      //继续按钮弹入
                      [RunViewControllerAnimation view:_contiuneButton
                                  SlideInToCenterPoint:CGPointMake(self.view.bounds.size.width/4, _startButton.center.y)
                            AnimationWthiCompleteBlock:^(POPAnimation *anim, BOOL finished){
                                [RunViewControllerAnimation scalAnimationWithView:_contiuneButton WithCompleteBlock:nil];
                            }];
                      
                      //完成按钮弹入
                      [RunViewControllerAnimation view:_completeButton
                                  SlideInToCenterPoint:CGPointMake(self.view.bounds.size.width*3/4, _startButton.center.y)
                            AnimationWthiCompleteBlock:^(POPAnimation *anim, BOOL finished){
                                [RunViewControllerAnimation scalAnimationWithView:_completeButton WithCompleteBlock:nil];
                            }];
                      
                      [UIView animateWithDuration:0.5 animations:^{
                          _pauseView.transform = CGAffineTransformMakeTranslation(0, _pauseView.bounds.size.height);
                      }];
                      
                      [self p_audioPlay:@"pause"];
                      [self p_pause];
                      
                  }];
            
        } else {
            
            //运动卡片回到原来的位置
            [RunViewControllerAnimation view:view
                        SlideInToCenterPoint:CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height- 100 -10)
                  AnimationWthiCompleteBlock:nil];
            
        }
        
    }
    
}

#pragma mark Timer Event

- (void)runTimerEvent:(NSTimer *)timer {
    _runcardView.time += 1;
    _runSimpleCardView.time = _runcardView.time;
}

#pragma mark Button Event

- (void)menuButtonTouch:(UIButton *)sender {
    [self.sideMenuViewController presentLeftMenuViewController];
}

- (void)contiuneButtonTouch:(UIButton *)sender {
    
    [RunViewControllerAnimation scalAnimationWithView:_contiuneButton
                                    WithCompleteBlock:^(POPAnimation *anim, BOOL finished) {
                                        
                                        [UIView animateWithDuration:0.5 animations:^{
                                            _pauseView.transform = CGAffineTransformIdentity;
                                        }];
                                        
                                        [RunViewControllerAnimation view:_contiuneButton
                                                   SlideOutToCenterPoint:CGPointMake(-_contiuneButton.bounds.size.width/2-10, _startButton.center.y)
                                              AnimationWthiCompleteBlock:nil];
                                        
                                        [RunViewControllerAnimation view:_completeButton
                                                   SlideOutToCenterPoint:CGPointMake(self.view.bounds.size.width+_completeButton.bounds.size.width/2+10, _startButton.center.y)
                                              AnimationWthiCompleteBlock:nil];
                                        
                                        [RunViewControllerAnimation view:_runcardView
                                                   SlideOutToCenterPoint:CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height- 100 -10)
                                              AnimationWthiCompleteBlock:nil];
                                        
                                    }];
    [self p_audioPlay:@"continue"];
    [self p_continue];
    
}

- (void)completeButtonTouch:(UIButton *)sender {
    
    RunningRecordModel *model = [[RunningRecordModel alloc] init];
    model.path = [self p_convertPointsToJsonString];
    model.time = _runcardView.time;
    model.kcar = _runcardView.kcal;
    model.distance = _runcardView.distance;
//    @property(nonatomic, strong) NSString  *weather;
//    @property(nonatomic, assign) float     pm25;
    model.averagespeed = _runcardView.speed;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    model.finishtime = [dateFormatter stringFromDate:[NSDate date]];
    [model save4database];
    
    RunCompleteCardsVC *vc = [[RunCompleteCardsVC alloc] initWithParameters:model addPhotos:nil WithPoints:_points];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)startButtonTouch:(UIButton *)sender {
    
    //动画
    [RunViewControllerAnimation scalAnimationWithView:sender WithCompleteBlock:^(POPAnimation *anim, BOOL finished) {
        
        _countView = [[CountView alloc] initWithCount:5];
        _countView.frame = self.view.bounds;
        _countView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        [self.view addSubview:_countView];
        [_countView startCountWithCompleteBlock:^(CountView *countView) {
            
            [self p_audioPlay:@"start"];
            
            [countView removeFromSuperview];
            [RunViewControllerAnimation smallView:sender
                                          ToFrame:CGRectMake(sender.center.x, sender.center.y, 0, 0)
                                WithCompleteBlock:^(POPAnimation *anim, BOOL finished) {
                                    [sender removeFromSuperview];
                                    [self.view addSubview:_runcardView];
                                    [RunViewControllerAnimation largeView:_runcardView
                                                                  ToFrame:CGRectMake(15, self.view.bounds.size.height-200-10, self.view.bounds.size.width-30, 200)
                                                        WithCompleteBlock:nil];
                                    
                                }];
            
            
            //逻辑
            _runState = RunViewControllerRunStateRunning;
            [_runTimer setFireDate:[NSDate distantPast]];
            [_mapViewDelegate addImage:[UIImage imageNamed:@"setting.png"] AtLocation:_points.firstObject];
            
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

- (void)p_complete {
    
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
    
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(newLocation.coordinate.latitude-0.001215, newLocation.coordinate.longitude);
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(center, 250, 250);
    [self.mapView setRegion:region animated:YES];
    
}

#pragma mark - UIImagePickerController Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    if (info) {
        UIImage *image = info[@"UIImagePickerControllerOriginalImage"];
        [_mapViewDelegate addimage:image AnontationWithLocation:_currentLocation];
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
