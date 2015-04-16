//
//  PhotoViewer.m
//  AirRun
//
//  Created by ChenHao on 4/17/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import "PhotoViewerController.h"
#import "UConstants.h"
#import <UIImageView+AFNetworking.h>
#import "RunningImageEntity.h"
@interface PhotoViewerController()<UIScrollViewDelegate>

@property (nonatomic, strong) UIView *backgroundMaksView;
@property (nonatomic, strong) UIScrollView *scrollview;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, assign) NSInteger currentIndex;


@property (nonatomic, assign) PhotoViewerDataScorceType dataSourceType;



@end


@implementation PhotoViewerController

- (instancetype)initWithURLArray:(NSArray *)paths AtIndex:(NSInteger)index
{
    self = [super init];
    if (self) {
        _dataSource = paths;
        _currentIndex = index;
        _dataSourceType = PhotoViewerDataScorceTypeURL;
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithImageArray:(NSArray *)paths AtIndex:(NSInteger)index
{
    self = [super init];
    if (self) {
        _dataSource = paths;
        _currentIndex = index;
        _dataSourceType = PhotoViewerDataScorceTypeImage;
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    [self.view setAlpha:1.0];
    [self.view setBackgroundColor:[UIColor clearColor]];
    [self showMask];
    
    _scrollview = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    int i=0;
    if (_dataSourceType == PhotoViewerDataScorceTypeImage) {
        for (UIImage *image in _dataSource) {
            UIImageView *v = [[UIImageView alloc] initWithFrame:CGRectMake(i*Main_Screen_Width, 0, Main_Screen_Width, Main_Screen_Height)];
            [v setImage:image];
            [v setContentMode:UIViewContentModeScaleAspectFit];
            [_scrollview addSubview:v];
            i++;
        }
    }
    else if(_dataSourceType == PhotoViewerDataScorceTypeURL)
    {
        for (RunningImageEntity *image in _dataSource) {
            UIImageView *v = [[UIImageView alloc] initWithFrame:CGRectMake(i*Main_Screen_Width, 0, Main_Screen_Width, Main_Screen_Height)];
            
            [v setImageWithURL:[NSURL URLWithString:image.remotepath] placeholderImage:nil];
            [v setContentMode:UIViewContentModeScaleAspectFit];
            [_scrollview addSubview:v];
            i++;
        }
    }
    
    
    _scrollview.delegate = self;
    [_scrollview setMinimumZoomScale:1.0];
    [_scrollview setMaximumZoomScale:5.0];
    [_scrollview setPagingEnabled:YES];
    [_scrollview setContentSize:CGSizeMake(Main_Screen_Width*[_dataSource count], Main_Screen_Height)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToDismiss:)];
    [_scrollview setContentOffset:CGPointMake(_currentIndex *Main_Screen_Width, 0)];
    [_scrollview addGestureRecognizer:tap];
    [self.view addSubview:_scrollview];
}

#pragma mark private
- (void)showMask
{
    if (_backgroundMaksView ==nil) {
        _backgroundMaksView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    }
    [_backgroundMaksView setBackgroundColor:[UIColor blackColor]];
    [_backgroundMaksView setAlpha:0.9];
    [self.view addSubview:_backgroundMaksView];
}

- (void)tapToDismiss:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}




@end
