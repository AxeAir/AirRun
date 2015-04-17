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
#import "CustomAnnotation.h"
#import "EditImageView.h"
#import <objc/runtime.h>
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "ShareView.h"
#import "ImageHeler.h"
#import <AVOSCloudSNS.h>
#import "HUDHelper.h"
#import "UConstants.h"

static const char *INDEX = "index";
@interface RecordDetailViewController ()<ShareViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *cardView;

@property (weak, nonatomic) IBOutlet UILabel *locationNameLabel;
@property (weak, nonatomic) IBOutlet UIView *topView;



@property (weak, nonatomic) IBOutlet UILabel *tempertureAndPMLable;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) MapViewDelegate *mapViewDelegate;
@property (weak, nonatomic) IBOutlet UILabel *monthDayLable;
@property (weak, nonatomic) IBOutlet UILabel *secondsLabel;

@property (weak, nonatomic) IBOutlet UILabel *avgSpeedLable;
@property (weak, nonatomic) IBOutlet UILabel *avgSpeedUnitLabel;

@property (weak, nonatomic) IBOutlet UILabel *durationLable;
@property (weak, nonatomic) IBOutlet UILabel *durationUnitLabel;


@property (weak, nonatomic) IBOutlet UILabel *distanceLable;
@property (weak, nonatomic) IBOutlet UILabel *distanceUnitLabel;


@property (weak, nonatomic) IBOutlet UILabel *kcalAppleLabel;

@property (weak, nonatomic) IBOutlet UIView *shareView;


@property (strong, nonatomic) NSMutableArray *path;
@property (strong, nonatomic) NSArray *imgEntities;
@property (strong, nonatomic) NSMutableArray *images;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;

@end

@implementation RecordDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self p_getData];
    [self p_layout];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [AVAnalytics beginLogPageView:@"详细记录页面"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [AVAnalytics endLogPageView:@"详细记录页面"];
}

- (void)viewDidAppear:(BOOL)animated {
    [self p_setViewTopCornor:_cardView];
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
    
    _imgEntities = [RunningImageEntity getPathArrayByIdentifer:_record.identifer];
    
}

- (void)p_layout {

    _cardView.layer.shadowOffset = CGSizeMake(0, 2);
    _cardView.layer.shadowRadius = 1;
    _cardView.layer.shadowColor = [UIColor colorWithRed:194/255.0 green:194/255.0 blue:194/255.0 alpha:1].CGColor;
    _cardView.layer.shadowOpacity = 1;
    
    _shareView.layer.cornerRadius = 5;
    _shareView.layer.shadowOffset = CGSizeMake(1, 1);
    _shareView.layer.shadowRadius = 5;
    _shareView.layer.shadowColor = [UIColor blackColor].CGColor;
    _shareView.layer.shadowOpacity = 1;
    
    _locationNameLabel.text = _record.city;
    
    _monthDayLable.text = [DateHelper getDateFormatter:@"MM-dd" FromDate:_record.finishtime];
    [_monthDayLable sizeToFit];
    _secondsLabel.text = [DateHelper getDateFormatter:@"mm:ss" FromDate:_record.finishtime];
    [_secondsLabel sizeToFit];
    _secondsLabel.alpha = 0.6;
    
    _tempertureAndPMLable.text = [NSString stringWithFormat:@"%@\nPM %ld",_record.weather,[_record.pm25 longValue]];
    
    _avgSpeedLable.text = [NSString stringWithFormat:@"%.1f",[_record.averagespeed floatValue]];
    _avgSpeedUnitLabel.alpha = 0.8;
    _durationLable.text = [DateHelper converSecondsToTimeString:[_record.time integerValue]];
    _durationUnitLabel.alpha = 0.8;
    _distanceLable.text = [NSString stringWithFormat:@"%.2f",[_record.distance floatValue]/1000];
    _distanceUnitLabel.alpha = 0.8;
    
    _kcalAppleLabel.text = _kaclText;
    [_kcalAppleLabel sizeToFit];
}

- (void)p_setMapView {
    _mapViewDelegate = [[MapViewDelegate alloc] initWithMapView:_mapView];
    _mapView.delegate = _mapViewDelegate;
    __weak RecordDetailViewController *this = self;
    _mapViewDelegate.imgAnnotationBlock = ^(CustomAnnotation *annotation){
        
        UIImage *img = annotation.image;
        NSInteger index = [objc_getAssociatedObject(img, INDEX) integerValue];
        
        UIWindow* currentWindow = [UIApplication sharedApplication].keyWindow;
        
         __block EditImageView *editImageView;
        
        [UIView transitionWithView:currentWindow
                          duration:0.5
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            editImageView = [[EditImageView alloc] initWithImages:this.images InView:currentWindow Editeable:NO];
                        } completion:^(BOOL finished) {
                            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:this action:@selector(edieImageViewTap:)];
                            [editImageView addGestureRecognizer:tapGesture];
                            
                            editImageView.currentIndex = index;
                        }];
        
        
        
    };
    [_mapViewDelegate addMaksGrayWorldOverlay];
    [_mapViewDelegate drawPath:_path IsStart:YES IsTerminate:YES];
    [self p_addPhotoAnnotation];
    
}

- (void)p_setViewTopCornor:(UIView *)view {
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, view.bounds.size.width, view.bounds.size.height+40)
                                     byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerTopRight)
                                           cornerRadii:CGSizeMake(5.0, 5.0)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
}

#pragma mark - Action

- (void)p_addPhotoAnnotation {
    _images = [[NSMutableArray alloc] init];
    for (RunningImageEntity *imgEntity in _imgEntities) {
        NSString *imgName = [imgEntity.localpath lastPathComponent];
        UIImage *img = [UIImage imageWithContentsOfFile:[DocumentHelper documentsFile:imgName AtFolder:kPathImageFolder]];
        
        if (!img) {
           
            AVFile *file = [AVFile fileWithURL:imgEntity.remotepath];
            [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                
                UIImage *image = [UIImage imageWithData:data];
                NSInteger idx = [_imgEntities indexOfObject:imgEntity];
                objc_setAssociatedObject(image, INDEX, @(idx), OBJC_ASSOCIATION_ASSIGN);
                CLLocation *loc = [[CLLocation alloc] initWithLatitude:[imgEntity.latitude doubleValue] longitude:[imgEntity.longitude doubleValue]];
                [_images insertObject:image atIndex:idx];
                [_mapViewDelegate addimage:image AnontationWithLocation:loc];
            }];
            
            [file getThumbnail:YES width:100 height:100 withBlock:^(UIImage *image, NSError *error) {
                
            }];
            continue;
            
        }
        
        NSInteger idx = [_imgEntities indexOfObject:imgEntity];
        objc_setAssociatedObject(img, INDEX, @(idx), OBJC_ASSOCIATION_ASSIGN);
        CLLocation *loc = [[CLLocation alloc] initWithLatitude:[imgEntity.latitude doubleValue] longitude:[imgEntity.longitude doubleValue]];
        [_images insertObject:img atIndex:idx];
        [_mapViewDelegate addimage:img AnontationWithLocation:loc];
    }
    
}

#pragma mark - Event
#pragma mark Gesture event

- (void)edieImageViewTap:(UITapGestureRecognizer *)gesture {
    UIView *view = gesture.view.superview;
    
    [UIView transitionWithView:view
                      duration:0.5
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        [gesture.view removeFromSuperview];
                    } completion:nil];
    
    
}
#pragma mark Button event

- (IBAction)shareButtonTouch:(id)sender {
    
    ShareView *share = [ShareView shareInstance];
    share.delegate  = self;
    [share showInView:self.view];
    
}
- (IBAction)closeButtonTouch:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)foucsButtonTouch:(id)sender {
    [_mapViewDelegate zoomToFitMapPoints:_path];
}
- (IBAction)mapPhotoButton:(id)sender {
    UIButton *button = (UIButton *)sender;
    if (button.tag == 10001) {
        [_mapViewDelegate deletePhotoAnnotation];
        button.tag = 10002;
    } else {
        [self p_addPhotoAnnotation];
        button.tag = 10001;
    }
    
}

#pragma mark Delegate 

- (void)shareview:(ShareView *)shareview didSelectButton:(ShareViewButtonType)buttonType
{
    if(buttonType == ShareViewButtonTypeWeiBo)
    {
        [AVOSCloudSNS setupPlatform:AVOSCloudSNSSinaWeibo withAppKey:@"151240750" andAppSecret:@"0488e8710bf0bcd29244f968cdcf2812" andRedirectURI:@"http://open.weibo.com/apps/151240750/privilege/oauth"];
        
        
        MBProgressHUD *hud = [[MBProgressHUD alloc] init];
        
        _closeButton.hidden = YES;
        _shareButton.hidden = YES;
        [AVOSCloudSNS shareText:@"我在轻跑" andLink:nil andImage:[ImageHeler convertViewToImage:_shareView]toPlatform:AVOSCloudSNSSinaWeibo withCallback:^(id object, NSError *error) {
            
            if (error) {
                NSLog(@"分享失败");
                [HUDHelper showError:@"分享失败" addView:self.view addHUD:hud delay:2];
            }
            else if(object){
                NSLog(@"分享成功");
                [HUDHelper showComplete:@"分享成功" addView:self.view addHUD:hud delay:2];
                [[ShareView shareInstance] dismiss];
            }
            NSLog(@"%@",error);
        } andProgress:^(float percent) {
            [HUDHelper showHUD:@"分享中" andView:self.view andHUD:hud];
        }];
        
        _closeButton.hidden = NO;
        _shareButton.hidden = NO;
        
    }
}
@end
