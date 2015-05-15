//
//  RunCompleteCardsVC.m
//  AirRun
//
//  Created by ChenHao on 4/1/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import "RunCompleteCardsVC.h"
#import <objc/runtime.h>
#import "CompleteInputCard.h"
#import "CompleteDisplayCard.h"
#import "UConstants.h"
#import "PopInputView.h"
#import "QBImagePickerController.h"
#import "ImageHeler.h"
#import "MapViewDelegate.h"
#import "RunningImageEntity.h"
#import "CustomAnnotation.h"
#import "EditImageView.h"
#import "DocumentHelper.h"
#import "ImageHeler.h"
#import "TimelineController.h"
#import "RESideMenu.h"
#import "ShareView.h"
#import <AVOSCloudSNS.h>
#import "WXApi.h"
#import "HUDHelper.h"

static const char *INDEX = "index";

@interface RunCompleteCardsVC ()<UIScrollViewDelegate, CompleteInputCardDelegate,CompleteDisplayCardDelegate,QBImagePickerControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ShareViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollview;
@property (nonatomic, strong) CompleteInputCard *inputcard;
@property (nonatomic, strong) CompleteDisplayCard *display;
@property (nonatomic, strong) MapViewDelegate *mapDelegate;

@property (nonatomic, strong) PopInputView *popview;//弹出层
@property (nonatomic, getter=isUp) BOOL up;//记录当前状态
@property (nonatomic, strong) RunningRecordEntity *parameters;
@property (nonatomic, strong) NSArray *path;
@property (nonatomic, strong) NSMutableArray *imgMs;//跑步中的图片(entity)
@property (nonatomic, strong) NSMutableArray *images;//跑步中的图片(image)
@property (nonatomic, strong) NSMutableArray *ImageArray;//心得添加的图片

@end

@implementation RunCompleteCardsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self ininVar];
    _up = YES;
    
    _scrollview = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _scrollview.delegate = self;
    [_scrollview setBackgroundColor:[UIColor clearColor]];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"sharebg"]]];
    
    _inputcard = [[CompleteInputCard alloc] initWithFrame:CGRectMake(10, 10, Main_Screen_Width-20, 180)];
    _inputcard.delegate = self;
    [_scrollview addSubview:_inputcard];
    
    _display = [[CompleteDisplayCard alloc] initWithFrame:CGRectMake(10, MaxY(_inputcard)+10, Main_Screen_Width-20, 800) withEntity:_parameters];
    _display.delegate = self;
    _mapDelegate = [[MapViewDelegate alloc] initWithMapView:_display.mapView];
    _display.mapView.delegate = _mapDelegate;
    [_mapDelegate addMaksGrayWorldOverlay];
    [self p_loadMapViewAnnotation];
    [_mapDelegate drawPath:_path IsStart:YES IsTerminate:YES];
    __weak RunCompleteCardsVC *this = self;
    _mapDelegate.imgAnnotationBlock = ^(CustomAnnotation *annotation){
        
        UIImage *img = annotation.image;
        NSInteger index = [objc_getAssociatedObject(img, INDEX) integerValue];
        EditImageView *editImageView = [[EditImageView alloc] initWithImages:this.images InView:this.view Editeable:YES];
        editImageView.currentIndex = index;
        editImageView.deleteBlock = ^(UIImage *image,NSInteger idx){
            RunningImageEntity *imgEntity = this.imgMs[idx];
            [imgEntity deleteEntityFromContext];
            [this.imgMs removeObject:imgEntity];
            NSString *fileName = [imgEntity.localpath lastPathComponent];
            [DocumentHelper removeFile:fileName InFoler:kPathImageFolder];
        };
        editImageView.closeBlock = ^(EditImageView *editImageView) {
            [this p_loadMapViewAnnotation];
        };
        
    };
    
    [_scrollview addSubview:_display];
    
    [_scrollview setContentSize:CGSizeMake(Main_Screen_Width,Main_Screen_Height+1 )];

    [self.view addSubview:_scrollview];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [AVAnalytics  beginLogPageView:@"完成页面"];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [AVAnalytics endLogPageView:@"完成页面"];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (instancetype)initWithParameters:(RunningRecordEntity *)parameters WithPoints:(NSArray *)pints WithImages:(NSArray *)images
{
    self = [super init];
    if (self) {
        _path = pints;
        _parameters = parameters;
        _imgMs = [images mutableCopy];
    }
    return self;
}

- (void)ininVar
{
    _ImageArray = [[NSMutableArray alloc] init];
}

- (void)p_loadMapViewAnnotation {
    _images = [[NSMutableArray alloc] init];
    [_mapDelegate deletePhotoAnnotation];
    
    for (RunningImageEntity *imgM in _imgMs) {
        CLLocation *location = [[CLLocation alloc] initWithLatitude:[imgM.latitude doubleValue] longitude:[imgM.longitude doubleValue]];
        UIImage *img = [UIImage imageWithContentsOfFile:[DocumentHelper documentsFile:imgM.localpath.lastPathComponent AtFolder:kPathImageFolder]];
        
        [_images addObject:img];
        NSInteger index =[_imgMs indexOfObject:imgM];
        objc_setAssociatedObject(img, INDEX, @(index), OBJC_ASSOCIATION_ASSIGN);//将下标关联
        
        [_mapDelegate addimage:img AnontationWithLocation:location];
    }
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    if (scrollView.contentOffset.y < - 50) {
        //向下拉到50松手后，
        DLog(@"下拉");
        [self changeToInput];
    }
    else if((scrollView.contentOffset.y>50)&& self.isUp)
    {
        DLog(@"上拉");
        [self changeToDisplay ];
    }
    
}


/**
 *  切换到数据卡片
 */
- (void)changeToDisplay
{
    
    [UIView animateWithDuration:0.3 animations:^{
        //[_scrollview setContentOffset:CGPointMake(0, 180) animated:YES];
        [_display setFrame:CGRectMake(10,10, Main_Screen_Width-20, 800)];
        [_display adjust:_inputcard.textview.text];
        [_inputcard setAlpha:0];
        [_scrollview setContentSize:CGSizeMake(Main_Screen_Width,Main_Screen_Height+1 )];
    } completion:^(BOOL finished) {
        _up = NO;
         [_scrollview setContentSize:CGSizeMake(Main_Screen_Width,HEIGHT(_display)+21 )];
    }];
}

/**
 *  切换到输入卡片
 */
- (void)changeToInput
{
    [UIView animateWithDuration:0.3 animations:^{
        [_scrollview setContentOffset:CGPointMake(0, 180) animated:YES];
        [_inputcard setFrame:CGRectMake(10,10, Main_Screen_Width-20, 180)];
        
        [_inputcard setAlpha:1.0];
        [_display setAlpha:1.0];
        [_display setFrame:CGRectMake(10, MaxY(_inputcard)+10, Main_Screen_Width-20, 800)];
        [_scrollview setContentSize:CGSizeMake(Main_Screen_Width,Main_Screen_Height+1 )];

    } completion:^(BOOL finished) {
        _up = YES;
        
    }];
}

#pragma mark Delegate
/**
 *  点击想下按钮
 */
- (void)didClickDownButton
{
    [self changeToDisplay];
}

/**
 *  点击新的出现输入框
 */
- (void)didTouchLabel
{
    if (_popview ==nil) {
        _popview = [[PopInputView alloc] initWithSuperView:self.view];
    }
    
    [_popview showWithCompleteBlock:^(NSString *string) {
        NSLog(@"输入的内容为:%@",string);
        if (![string isEqualToString:@""]) {
            _inputcard.textview.text = string;
        }
    } Text:_inputcard.textview.text photoBlock:^() {
        QBImagePickerController *imagePickerController = [[QBImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsMultipleSelection = YES;
        imagePickerController.maximumNumberOfSelection = 5;
        imagePickerController.filterType = QBImagePickerControllerFilterTypePhotos;
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
        [self presentViewController:navigationController animated:YES completion:^{
            
        }];
    }];
}


//隐藏状态栏
- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)dismissImagePickerController
{
    if (self.presentedViewController) {
        [self dismissViewControllerAnimated:YES completion:NULL];
    } else {
        [self.navigationController popToViewController:self animated:YES];
    }
}

- (void)completeDisplayCard:(CompleteDisplayCard *)card didSelectButton:(CompleteDisplayCardButtonType)type
{
    
    [_mapDelegate zoomToFitMapPoints:_path];
//    UIImage *mapShot = [ImageHeler compressImage:[_display.mapDelegate captureMapView] LessThanKB:200];
    UIImage *mapShot = [_mapDelegate captureMapView];
    NSString *mapImageName = [NSString stringWithFormat:@"%@.jpg",_parameters.identifer];
    self.parameters.mapshot = [kMapImageFolder stringByAppendingPathComponent:mapImageName];
    [DocumentHelper saveImage:mapShot ToFolderName:kMapImageFolder WithImageName:mapImageName];
    
    _parameters.heart = _inputcard.textview.text;
    _parameters.finishtime = [[NSDate alloc] init];
    _parameters.dirty = @1;
    _parameters.feel = @(_inputcard.currentFaceIndex);

    if (_ImageArray !=nil ||[_ImageArray count]!=0) {
        
        NSInteger index = 0;
        NSInteger timestamp = (long)[[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSince1970];
        for (UIImage *heartImage in _ImageArray) {
            
            RunningImageEntity *image = [[RunningImageEntity alloc] init];
            UIImage *save = [ImageHeler compressImage:heartImage LessThanKB:200];
            image.type = @"heart";
            image.dirty = @1;
            image.recordid = _parameters.identifer;
            image.localpath = [kHeartImage stringByAppendingPathComponent:[NSString stringWithFormat:@"%ld_1_%ld.png",(long)timestamp,index]];
            [DocumentHelper saveImage:save ToFolderName:kHeartImage WithImageName:[NSString stringWithFormat:@"%ld_1_%ld.png",(long)timestamp,index]];
            index++;
        }
    }
    
    [_parameters savewithCompleteBlock:^{
        NSLog(@"数据本地持久化成功");
    } withErrorBlock:^{
        
    }];
    
    if (type == CompleteDisplayCardButtonTypeShare) {
        ShareView *share = [[ShareView alloc] init];
        share.delegate = self;
        [share showInView:self.view];
    
        
    }
    else if(type == CompleteDisplayCardButtonTypeComplete)
    {
        [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[[TimelineController alloc] initWithStyle:UITableViewStylePlain]
]                                                     animated:NO];
        [self.sideMenuViewController setPanGestureEnabled:YES];
        [self.sideMenuViewController hideMenuViewController];
    }
}

- (void)completeDisplayCard:(CompleteDisplayCard *)card FoucsButtouTouch:(UIButton *)button {
    [_mapDelegate zoomToFitMapPoints:_path];
}

- (void)completeDisplayCardaddImageAnnotation:(CompleteDisplayCard *)card {
    [self p_loadMapViewAnnotation];
}

- (void)completeDisplayCard:(CompleteDisplayCard *)card imageButtouTouch:(UIButton *)button {
    
    if (button.tag == 10001) {
        [_mapDelegate deletePhotoAnnotation];
        button.tag = 10002;
    } else {
        [self p_loadMapViewAnnotation];
        button.tag = 10001;
    }
    
}


#pragma mark - QBImagePickerControllerDelegate

- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didSelectAsset:(ALAsset *)asset
{
    NSLog(@"*** qb_imagePickerController:didSelectAsset:");
    NSLog(@"%@", asset);
    
    [self dismissImagePickerController];
}

- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didSelectAssets:(NSArray *)assets
{
    NSLog(@"*** qb_imagePickerController:didSelectAssets:");
    NSLog(@"%@", assets);
    
    for (ALAsset *aset in assets) {
        [_ImageArray addObject:[ImageHeler fullResolutionImageFromALAsset:aset]];
    }
    NSLog(@"%@",_ImageArray);
    [_popview addSmallPictures:_ImageArray];
    [self dismissImagePickerController];
}

- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController
{
    NSLog(@"*** qb_imagePickerControllerDidCancel:");
    
    [self dismissImagePickerController];
}

- (void)qb_imagePickerControllerDidClickCarmera
{
    NSLog(@"open camera");
    [self dismissImagePickerController];
    UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        pickerImage.sourceType = UIImagePickerControllerSourceTypeCamera;
        pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
    }
    pickerImage.delegate = self;
    pickerImage.allowsEditing = NO;
    [self presentViewController:pickerImage animated:YES completion:^{
        
    }];
}


#pragma mark UIPicker

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        UIImage* image = [info objectForKey:UIImagePickerControllerOriginalImage];

        [picker dismissViewControllerAnimated:YES completion:nil];
        ;
        [_ImageArray addObject:[ImageHeler compressImage:image LessThanKB:200]];
        [_popview addSmallPictures:_ImageArray];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark sharview;

- (void)shareview:(ShareView *)shareview didSelectButton:(ShareViewButtonType)buttonType
{
    
    [_display changeToshareModel];
    UIImage *shareimage = [ImageHeler convertViewToImage:_display ];
    [_display changeToNormalModel];
    
    if (buttonType == ShareViewButtonTypeWeiBo) {
        [AVOSCloudSNS setupPlatform:AVOSCloudSNSSinaWeibo withAppKey:@"151240750" andAppSecret:@"0488e8710bf0bcd29244f968cdcf2812" andRedirectURI:@"http://open.weibo.com/apps/151240750/privilege/oauth"];
        
        
        MBProgressHUD *hud = [[MBProgressHUD alloc] init];
        [AVOSCloudSNS shareText:@"我在轻跑" andLink:nil andImage:shareimage toPlatform:AVOSCloudSNSSinaWeibo withCallback:^(id object, NSError *error) {
            
            if (error) {
                [HUDHelper showError:@"分享失败" addView:self.view addHUD:hud delay:1];
            }
            else if(object)
            {
                [HUDHelper showComplete:@"分享成功" addView:self.view addHUD:hud delay:1];
            }
            
            NSLog(@"%@",error);
        } andProgress:^(float percent) {
            [HUDHelper showHUD:@"分享中" andView:self.view andHUD:hud];
        }];
    }
    
    if(buttonType == ShareViewButtonTypeWeChat)
    {
        SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
        req.scene = WXSceneTimeline;
        req.text = @"这里写你要分享的内容。";
        req.bText = NO;
        req.message = WXMediaMessage.message;
        WXImageObject *imageObject = [[WXImageObject alloc] init];
        imageObject.imageData = UIImagePNGRepresentation(shareimage);
        req.message.mediaObject = imageObject;
        [WXApi sendReq:req];
    }
    if (buttonType == ShareViewButtonTypeFriends) {
    
        SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
        req.scene = WXSceneSession;
        req.text = @"这里写你要分享的内容。";
        req.bText = NO;
        req.message = WXMediaMessage.message;
        WXImageObject *imageObject = [[WXImageObject alloc] init];
        imageObject.imageData = UIImagePNGRepresentation(shareimage);
        req.message.mediaObject = imageObject;
        [WXApi sendReq:req];
       
    }
    
    
}

#pragma private






@end
