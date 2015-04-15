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
#import "RunningRecordEntity.h"
#import "RunningImageEntity.h"
#import "RunCompleteCardsVC.h"
#import <AVFoundation/AVFoundation.h>
#import "CountView.h"
#import "DocumentHelper.h"
#import <objc/runtime.h>
#import "ReadyView.h"
#import "RunGuideViewController.h"
#import "DocumentHelper.h"
#import "ImageHeler.h"
#import "DateHelper.h"
#import "WeatherManager.h"
#import "RunManager.h"
#import "SpeakHelper.h"

const static NSInteger RuncardViewHieght = 150;
const static NSInteger RunSimpleCardViewHeight = 90;
const static NSInteger PauseViewHeight = 60;

const char *INPOSITION = "InPosition";
const char *OUTPOSITION = "OutPosition";

@interface RunViewController () <CLLocationManagerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) AVAudioPlayer *audioPlayer;
@property (strong, nonatomic) CountView *countView;

@property (strong, nonatomic) UIBarButtonItem *photoButton;
@property (strong, nonatomic) UIBarButtonItem *gpsButton;
@property (strong, nonatomic) ReadyView *readyView;

@property (strong, nonatomic) MKMapView *mapView;
@property (strong, nonatomic) UIView *mapMaskView;
@property (strong, nonatomic) MapViewDelegate *mapViewDelegate;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *currentLocation;

@property (strong, nonatomic) UIButton *startButton;
@property (strong, nonatomic) UIButton *pauseButton;
@property (strong, nonatomic) UIButton *contiuneButton;
@property (strong, nonatomic) UIButton *completeButton;

@property (strong, nonatomic) RunPauseView *pauseView;
@property (strong, nonatomic) RunCardView *runcardView;
@property (strong, nonatomic) RunSimpleCardView *runSimpleCardView;
@property (assign, nonatomic) CGFloat runCardLastKmDistance;

@property (strong, nonatomic) NSTimer *runTimer;
@property (strong, nonatomic) RunManager *runManager;
@property (strong, nonatomic) UIAlertView *recoverAlert;
@property (strong, nonatomic) UIAlertView *runConfirmAlert;

@end

@implementation RunViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _runManager = [RunManager shareInstance];
    
    NSError *sessionError = nil;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:&sessionError];
    [[AVAudioSession sharedInstance] setActive:YES error:&sessionError];
    
    
    [self p_setNavgation];
    [self p_setMapView];
    [self p_setLocationManager];
    [self p_setLayout];
    [self p_setStartRunLayout];
    
    if ([_runManager checkUserDefaultIsAvailable]) {
        
        _recoverAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"轻跑检测到您有未完成的跑步是否继续" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"继续", nil];
        [_recoverAlert show];
        
    }
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    _runTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(runTimerEvent:) userInfo:nil repeats:YES];
    if (_runManager.runState != RunStateRunning) {
        [_runTimer setFireDate:[NSDate distantFuture]];
    }
    
    [_runManager addObserver:self forKeyPath:@"distance" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    [_runManager addObserver:self forKeyPath:@"time" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    [_runManager addObserver:self forKeyPath:@"speed" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    [_runManager addObserver:self forKeyPath:@"kcal" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillEnterBackground:) name:
     UIApplicationWillEnterForegroundNotification object:nil];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [_runTimer invalidate];
    _runTimer = nil;
    
    [_runManager removeObserver:self forKeyPath:@"distance"];
    [_runManager removeObserver:self forKeyPath:@"time"];
    [_runManager removeObserver:self forKeyPath:@"speed"];
    [_runManager removeObserver:self forKeyPath:@"kcal"];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Layout

- (void)p_setNavgation {
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbg127"] forBarPosition:UIBarPositionTopAttached barMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navicon"] style:UIBarButtonItemStylePlain target:self action:@selector(menuButtonTouch:)];
    self.navigationItem.leftBarButtonItem = menuButton;
    
    _photoButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"camera.png"] style:UIBarButtonItemStylePlain target:self action:@selector(photoButtonTouch:)];
    
    _gpsButton = [[UIBarButtonItem alloc] initWithTitle:@"GPS" style:UIBarButtonItemStylePlain target:self action:nil];
    [_gpsButton setTintColor:[UIColor redColor]];
    
    UIBarButtonItem *guideButton = [[UIBarButtonItem alloc] initWithTitle:@"跑步指导" style:UIBarButtonItemStylePlain target:self action:@selector(guideButtonTouch:)];
    self.navigationItem.rightBarButtonItem = guideButton;

    [self p_setTitle];
    
}

- (void)p_setTitle {
    UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    titleLable.text = [NSString stringWithFormat:@"%@\nPM %@",_runManager.temperature,_runManager.pm];
    titleLable.textColor = [UIColor whiteColor];
    titleLable.font = [UIFont systemFontOfSize:12];
    titleLable.numberOfLines = 2;
    self.navigationItem.titleView = titleLable;
}
- (void)p_setMapView {
    
    self.mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    _mapViewDelegate = [[MapViewDelegate alloc] initWithMapView:_mapView];
    
    self.mapView.delegate = _mapViewDelegate;
    self.mapView.mapType = MKMapTypeStandard;
    self.mapView.showsUserLocation = YES;
    [self.view addSubview:_mapView];
    
    _mapMaskView = [[UIView alloc] initWithFrame:_mapView.frame];
    _mapMaskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mapMaskTapGesture:)];
    [_mapMaskView addGestureRecognizer:tapGesture];
    [self.view addSubview:_mapMaskView];
    
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
    
    _readyView = [[ReadyView alloc] initWithText:@"适合户外跑步"];
    _readyView.frame = CGRectMake(0, 63, self.view.bounds.size.width, 45);
    [self.view addSubview:_readyView];
    
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
//    _runcardView.clipsToBounds = YES;
    __weak RunViewController *this = self;
    _runcardView.retractTouchBlock = ^(UIButton * button) {
        
        [RunViewControllerAnimation view:this.pauseButton
                   SlideOutToCenterPoint: CGPointMake(this.view.bounds.size.width/2, this.view.bounds.size.height+this.pauseButton.bounds.size.height/2+10)
              AnimationWthiCompleteBlock:nil];
        
        [this.navigationController setNavigationBarHidden:YES animated:YES];
        [UIView animateWithDuration:UINavigationControllerHideShowBarDuration animations:^{
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
            [UIView animateWithDuration:UINavigationControllerHideShowBarDuration animations:^{
//                this.navigationController.navigationBar.frame = CGRectMake(0, 0, this.view.bounds.size.width, 64);
                this.runcardView.frame = CGRectMake(0, 63, this.view.bounds.size.width, RuncardViewHieght);
            }];
        }];

    };
    _runSimpleCardView.photoButtonBlock = ^(UIButton *button){
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
//        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.delegate = this;
        [this presentViewController:imagePicker animated:YES completion:nil];
    };
    [self.view addSubview:_runSimpleCardView];
    
    
}
#pragma mark - Event
#pragma mark Notification Event

- (void)appWillEnterBackground:(NSNotificationCenter *)notification {
    _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
}

#pragma mark Gesture Event

- (void)mapMaskTapGesture:(UITapGestureRecognizer *)tapGesture {
    UIView *view = tapGesture.view;
    [view removeFromSuperview];
}

#pragma mark Timer Event

- (void)runTimerEvent:(NSTimer *)timer {
    _runManager.time += 1;
}

#pragma mark Button Event

- (void)guideButtonTouch:(UIBarButtonItem *)sender {
    //加入view 甚至是navigationbar
    UIWindow* currentWindow = [UIApplication sharedApplication].keyWindow;
    [currentWindow addSubview:_countView];
    
    RunGuideViewController *vc = [[RunGuideViewController alloc] init];
    vc.view.alpha = 0;
    [currentWindow addSubview:vc.view];
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         vc.view.alpha = 1;
                     }];
    
}

- (void)pauseButtonTouch:(UIButton *)sender {
    
    [RunViewControllerAnimation scalAnimationWithView:sender WithCompleteBlock:^(POPAnimation *anim, BOOL finished) {
        
        [self p_pause];
        [UIView animateWithDuration:0.3 animations:^{
            self.runcardView.frame = CGRectMake(0, -RuncardViewHieght, self.view.bounds.size.width, RuncardViewHieght);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3 animations:^{
                self.pauseView.frame = CGRectMake(0, 63, self.view.bounds.size.width, PauseViewHeight);
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
//    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
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
                _runcardView.frame = CGRectMake(0, 63, self.view.bounds.size.width, RuncardViewHieght);
            }];
        }];
        
    }];
    
    
    
}

- (void)completeButtonTouch:(UIButton *)sender {
    
    _runManager.runState = RunStateStop;
    
    if (_runManager.distance <= 25) {
        
        _runConfirmAlert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                      message:@"您跑步的距离过段是否重新开始"
                                                     delegate:self
                                            cancelButtonTitle:@"继续"
                                            otherButtonTitles:@"重新开始", nil];
        [_runConfirmAlert show];
        
    } else {
        RunCompleteCardsVC *vc = [[RunCompleteCardsVC alloc] initWithParameters:[_runManager generateRecordEntity] WithPoints:_runManager.points WithImages:_runManager.imageArray];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

- (void)startButtonTouch:(UIButton *)sender {
    
    //动画
    [RunViewControllerAnimation scalAnimationWithView:sender WithCompleteBlock:^(POPAnimation *anim, BOOL finished) {
        
        
        //倒计时页面
        _countView = [[CountView alloc] initWithCount:5];
        _countView.frame = self.view.bounds;
        _countView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        //加入view 甚至是navigationbar
        UIWindow* currentWindow = [UIApplication sharedApplication].keyWindow;
        [currentWindow addSubview:_countView];
        
        [_countView startCountWithCompleteBlock:^(CountView *countView) {
            [_countView removeFromSuperview];
            
            //逻辑
            self.navigationItem.rightBarButtonItem = _photoButton;
            self.navigationItem.leftBarButtonItem = _gpsButton;
            [_mapMaskView removeFromSuperview];
//            [self p_audioPlay:@"start"];
//            [[SpeakHelper shareInstance] speakString:@"跑步开始"];
            _runManager.runState = RunStateRunning;
            [_runTimer setFireDate:[NSDate distantPast]];
            [_mapViewDelegate addPointAnnotationImage:[UIImage imageNamed:@"start"] AtLocation:_runManager.points.firstObject];
            
            [UIView animateWithDuration:0.3 animations:^{
                _readyView.frame = CGRectMake(0, -25, self.view.bounds.size.width, 25);
            } completion:^(BOOL finished) {
                [_readyView removeFromSuperview];
                [UIView animateWithDuration:0.3 animations:^{
                    _runcardView.frame = CGRectMake(0, 63, self.view.bounds.size.width, RuncardViewHieght);
                }];
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
        
    }];
    
}

#pragma mark - Function
#pragma mark Private Function

- (void)p_addImageEntityToMap:(RunningImageEntity *)imgEntity {
    
    CLLocation *loc = [[CLLocation alloc] initWithLatitude:[imgEntity.latitude doubleValue] longitude:[imgEntity.longitude doubleValue]];
    NSString *imageName = [imgEntity.localpath lastPathComponent];
    UIImage *image = [UIImage imageWithContentsOfFile:[DocumentHelper documentsFile:imageName AtFolder:kPathImageFolder]];
    [_mapViewDelegate addimage:image AnontationWithLocation:loc];
    
}

- (void)p_addShowdowWithView:(UIView *)view {
    
    view.layer.masksToBounds = NO;
    view.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    view.layer.shadowOpacity = 0.8;
    view.layer.shadowRadius = 4;
    view.layer.shadowOffset = CGSizeMake(1, 1.0);
    
}



- (void)p_getLocationNameWithLocation:(CLLocation *)location {
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:_locationManager.location
                   completionHandler:^(NSArray *placemarks, NSError *error) {
                       NSLog(@"reverseGeocodeLocation:completionHandler: Completion Handler called!");
                       
                       if (error){
                           NSLog(@"Geocode failed with error: %@", error);
                           return;
                           
                       }
                       
                       NSLog(@"placemarks=%@",[placemarks objectAtIndex:0]);
                       CLPlacemark *placemark = [placemarks objectAtIndex:0];
                       
                       //                       NSLog(@"placemark.ISOcountryCode =%@",placemark.ISOcountryCode);
                       //                       NSLog(@"placemark.country =%@",placemark.country);
                       //                       NSLog(@"placemark.postalCode =%@",placemark.postalCode);
                                              NSLog(@"placemark.administrativeArea =%@",placemark.administrativeArea);
                                              NSLog(@"placemark.locality =%@",placemark.locality);
                                              NSLog(@"placemark.subLocality =%@",placemark.subLocality);
                                              NSLog(@"placemark.subThoroughfare =%@",placemark.subThoroughfare);
                       _runManager.currentLocationName = [NSString stringWithFormat:@"%@,%@",placemark.administrativeArea,placemark.subAdministrativeArea];
                       
                       NSString *cityName;
                       if ([placemark.subThoroughfare isEqualToString:@""] || !placemark.subThoroughfare) {//为直辖市
                           cityName = placemark.administrativeArea;
                       } else {
                           cityName = placemark.subLocality;
                       }
                       
                       WeatherManager *weatherManager = [[WeatherManager alloc] init];
                       [weatherManager getPM25WithCityName:cityName success:^(PM25Model *pm25) {
                           _runManager.pm = pm25.AQI[0];
                           [self p_setTitle];
                       } failure:^(NSError *error) {}];
                       
                       [weatherManager getWeatherWithLongitude:@(_currentLocation.coordinate.longitude) latitude:@(_currentLocation.coordinate.latitude) success:^(WeatherModel *responseObject) {
                           _runManager.temperature = responseObject.temperature;
                           [self p_setTitle];
                       } failure:^(NSError *error) {}];
                       
                   }];
    
}

- (void)p_setGPS:(CGFloat)gps {
    
    if (gps < 0)
    {
        //no single
        [_gpsButton setTintColor:[UIColor grayColor]];
    }
    else if (gps > 163)
    {
        //poor single
        [_gpsButton setTintColor:[UIColor redColor]];
    }
    else if (gps > 48)
    {
        //average single
        [_gpsButton setTintColor:[UIColor orangeColor]];
    }
    else
    {
        // Full Signal
        [_gpsButton setTintColor:[UIColor greenColor]];
    }
}

- (void)p_audioPlay:(NSString *)name {
    
    NSURL *startUrl = [[NSBundle mainBundle] URLForResource:name withExtension:@"m4a"];
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:startUrl error:nil];
    [_audioPlayer prepareToPlay];
    [_audioPlayer play];
    
}

- (void)p_continue {
    
    _runManager.runState = RunStateRunning;
    [_runTimer setFireDate:[NSDate distantPast]];
    
}

- (void)p_pause {
    
    _runManager.runState = RunStatePause;
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
    
    if ([_runManager.currentLocationName isEqualToString:@""] || !_runManager.currentLocationName) {
//        [self p_getLocationNameWithLocation:newLocation];
    }
    
    if (_runManager.runState == RunStateRunning) {//是在跑步过程中
        
        CLLocationDistance distance = [newLocation distanceFromLocation:_currentLocation];
        if (distance < 5.0) {
            return;
        }
        _runManager.currentSpeed = newLocation.speed;
        _runManager.distance += distance;
        _runManager.speed = _runcardView.distance/_runcardView.time;
        _runManager.kcal += [self p_getCalorie:2.0/3600.0 speed:_runManager.currentSpeed*3.6];
        
        [self p_setGPS:newLocation.horizontalAccuracy];
        
        //距离上一次提醒已经超过1公里了-----进行公里提醒和地图上显示图标
        if (_runcardView.distance - _runCardLastKmDistance >= 1000) {
            _runCardLastKmDistance = _runcardView.distance;
            
            NSInteger km = _runcardView.distance/1000;
            NSString *words = [NSString stringWithFormat:@"您已经跑了%ld千米",(long)km];
            [[SpeakHelper shareInstance] speakString:words];
            
            [_mapViewDelegate addPointAnnotationImage:[UIImage imageNamed:@"1km"] AtLocation:newLocation];
        }
    }
    
    self.currentLocation = newLocation;
    
    if (_runManager.runState == RunStateStop) {
        _runManager.points = [[NSMutableArray alloc] initWithArray:@[newLocation,newLocation]];
        
    } else {
        [_runManager.points addObject:newLocation];
    }
    
    [_mapViewDelegate drawGradientPolyLineWithPoints:_runManager.points];
    
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(newLocation.coordinate.latitude+0.000215, newLocation.coordinate.longitude);
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(center, 250, 250);
    [self.mapView setRegion:region animated:YES];
    
}

#pragma mark - UIImagePickerController Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    if (info) {
        UIImage *image = info[@"UIImagePickerControllerOriginalImage"];
        [_mapViewDelegate addimage:image AnontationWithLocation:_currentLocation];
        
        RunningImageEntity *imgM = [[RunningImageEntity alloc] init];
        NSString *imageName = [NSString stringWithFormat:@"%@.jpg",[DateHelper getFormatterDate:@"yyyyMMddHHmmss"]];
        imgM.localpath = [kPathImageFolder stringByAppendingPathComponent:imageName];
        UIImage *newImage = [ImageHeler compressImage:image LessThanKB:400];
        [DocumentHelper saveImage:newImage ToFolderName:kPathImageFolder WithImageName:imgM.localpath.lastPathComponent];
        imgM.longitude = @(_currentLocation.coordinate.longitude);
        imgM.latitude = @(_currentLocation.coordinate.latitude);
        imgM.type = @"路线图片";
        
        [_runManager.imageArray addObject:imgM];
        
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    id newValue = change[@"new"];
    
    if ([keyPath isEqualToString:@"distance"]) {
        _runcardView.distance = [newValue floatValue];
        _runSimpleCardView.distance = [newValue floatValue];
    }
    
    if ([keyPath isEqualToString:@"time"]) {
        _runcardView.time = [newValue integerValue];
        _runSimpleCardView.time = [newValue integerValue];
    }
    
    if ([keyPath isEqualToString:@"speed"]) {
        _runcardView.speed = [newValue floatValue];
        _runSimpleCardView.speed = [newValue floatValue];
    }
    
    if ([keyPath isEqualToString:@"kcal"]) {
        _runcardView.kcal = [newValue floatValue];
    }
}

#pragma mark - UIAlertViewDelegate 

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView == _recoverAlert) {
        
        
        
        if (buttonIndex == 1) {
            [self startButtonTouch:_startButton];
            
            [_runManager readFromUserDefault];
            _runManager.points = _runManager.pointsBackUp;
            _currentLocation = _runManager.points.lastObject;
            
            [_mapViewDelegate drawPath:_runManager.points IsStart:NO IsTerminate:NO];
            for (RunningImageEntity *imgEntity in _runManager.imageArray) {
                [self p_addImageEntityToMap:imgEntity];
            }
        } else if (buttonIndex == 0) {
            [_runManager removeUserDefault];
        }
        
    }
    
    if (alertView == _runConfirmAlert) {
        
        if (buttonIndex == 1) { //重新开始
            
            [_runManager reback];
            
            [self p_setNavgation];
            [self p_setMapView];
            [self p_setLocationManager];
            [self p_setLayout];
            [self p_setStartRunLayout];
            
        }
    }
    
    
    
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
