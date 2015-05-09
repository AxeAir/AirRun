//
//  MapViewDelegate.m
//  AirRun
//
//  Created by jasonWu on 4/1/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import "MapViewDelegate.h"
#import "GradientPolylineOverlay.h"
#import "GradientPolylineRenderer.h"
#import "ImageOverLay.h"
#import "ImageOverLayRenderer.h"
#import "CustomAnnotation.h"
#import "CustomAnnotationView.h"
#import <objc/runtime.h>
#import "CreatImageHelper.h"

static const char*POINTANNOTATIONIMAGE = "pointAnnotationImage";

@interface MapViewDelegate () <CustomeAnnotationDelegate>

@property (weak, nonatomic) MKMapView *mapView;

@property (strong, nonatomic) MKPolyline *routeLine;
@property (strong, nonatomic) MKPolylineRenderer *lineRenderer;

@property (strong, nonatomic) GradientPolylineOverlay *gradientLineOverlay;
@property (strong, nonatomic) GradientPolylineRenderer *gradientRenderer;

@property (strong, nonatomic) ImageOverLay *imageOverlay;

@end

@implementation MapViewDelegate

- (instancetype)initWithMapView:(MKMapView *)mapView{
    
    self = [super init];
    if (self) {
        _mapView = mapView;
    }
    return self;
}

#pragma mark - Map Action

- (void)clearAnnotation {
    [_mapView removeAnnotations:_mapView.annotations];
}

- (void)addMaksGrayWorldOverlay {
    CLLocationCoordinate2D worldCoords[6] = {{90, 0}, {90, 180}, {-90,180}, {-90,0}, {-90,-180}, {90,-180}};
    MKPolygon *polygonOverlay = [MKPolygon polygonWithCoordinates:worldCoords count:6];
    [_mapView addOverlay:polygonOverlay];
    
}

- (void)drawPath:(NSArray *)path IsStart:(BOOL)start IsTerminate:(BOOL)terminate {
    
    //画路线
    [self drawGradientPolyLineWithPoints:path WithGrayLine:YES];
    
    //地图适应
    [self zoomToFitMapPoints:path];
    
    //画起点和终点
    CLLocation *startPoint = path.firstObject;
    CLLocation *endPoint = path.lastObject;
    if (start) {
        [self addPointAnnotationImage:[UIImage imageNamed:@"start"] AtLocation:startPoint];
    }
    if (terminate) {
        [self addPointAnnotationImage:[UIImage imageNamed:@"terminalFlag"] AtLocation:endPoint];
    }
    
    //画公里节点
    NSInteger kmIndex = 0;
    CLLocation *lastKMLocation = path.firstObject;
    for (CLLocation *location in path) {
        if ([location distanceFromLocation:lastKMLocation] >= 1000) {
            kmIndex++;
            lastKMLocation = location;
            UIImage *image = [CreatImageHelper generateDistanceNodeImage:[NSString stringWithFormat:@"%ld",(long)kmIndex]];
            [self addPointAnnotationImage:image AtLocation:location];
        }
    }
    
}

- (void)addImage:(UIImage *)image AtLocation:(CLLocation *)location {
    
    _imageOverlay = [[ImageOverLay alloc] initWithCoordinate:location.coordinate WithImage:image];
    [self.mapView insertOverlay:_imageOverlay aboveOverlay:self.gradientLineOverlay];
    
}

-(void)drawGradientPolyLineWithPoints:(NSArray *)pointArray WithGrayLine:(BOOL)grayLine{
    
    CLLocationCoordinate2D *points;
    float *velocity;
    points = malloc(sizeof(CLLocationCoordinate2D)*pointArray.count);
    velocity = malloc(sizeof(float)*pointArray.count);
    
    for (int i = 0; i < pointArray.count; i++) {
        CLLocation *location = pointArray[i];
        points[i] = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
        velocity[i] = location.speed;
    }
    
    if (self.gradientLineOverlay) {
        [self.mapView removeOverlay:self.gradientLineOverlay];
    }
    
    self.gradientLineOverlay = [[GradientPolylineOverlay alloc] initWithPoints:points velocity:velocity count:pointArray.count];
    [self.mapView insertOverlay:self.gradientLineOverlay belowOverlay:_imageOverlay];
    
    if (grayLine) {
        [self drawLineWithPoints:pointArray];
    }
    
    
    
    free(points);
    free(velocity);
    
}

- (void)drawLineWithPoints:(NSArray *)points{
    
    MKMapPoint northEastPoint = MKMapPointMake(0.0f, 0.0f);
    MKMapPoint southWestPoint = MKMapPointMake(0.0f, 0.0f);
    MKMapPoint *mapPoints = malloc(sizeof(CLLocationCoordinate2D)*points.count);
    
    for (NSUInteger idx = 0; idx < points.count; idx++) {

        CLLocation *location = points[idx];
        CLLocationDegrees latitude = location.coordinate.latitude;
        CLLocationDegrees longitude = location.coordinate.longitude;
        MKMapPoint point = MKMapPointForCoordinate(CLLocationCoordinate2DMake(latitude, longitude));
        if (idx == 0) {
            northEastPoint = point;
            southWestPoint = point;
        } else {
            
            if (point.x > northEastPoint.x)
                northEastPoint.x = point.x;
            if (point.y > northEastPoint.y)
                northEastPoint.y = point.y;
            if (point.x < southWestPoint.x)
                southWestPoint.x = point.x;
            if (point.y < southWestPoint.y)
                southWestPoint.y = point.y;
            
        }
        
        mapPoints[idx] = point;
    }
    
    if (self.routeLine) {
        [self.mapView removeOverlay:self.routeLine];
    }
    
    self.routeLine = [MKPolyline polylineWithPoints:mapPoints count:points.count];
    if (nil != self.routeLine) {
//        [self.mapView addOverlay:self.routeLine];
        [self.mapView insertOverlay:_routeLine belowOverlay:_gradientLineOverlay];
    }
    
    free(mapPoints);
    
}

- (void)addimage:(UIImage *)image AnontationWithLocation:(CLLocation *)location {
    
    CustomAnnotation *customAnnotation = [[CustomAnnotation alloc] init];
//    customAnnotation.imageArray = @[image];
    customAnnotation.image = image;
    customAnnotation.coordinate = location.coordinate;
    customAnnotation.delegate = self;
    [self.mapView addAnnotation:customAnnotation];
    
}

- (void)addPointAnnotationImage:(UIImage *)image AtLocation:(CLLocation *)location {
    
    MKPointAnnotation *pointAnnotation = [[MKPointAnnotation alloc] init];
    pointAnnotation.coordinate = location.coordinate;
    objc_setAssociatedObject(pointAnnotation, POINTANNOTATIONIMAGE, image, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [_mapView addAnnotation:pointAnnotation];
}

-(void)zoomToFitMapPoints:(NSArray *)path {
    if(path.count == 0)
        return;
    
    CLLocationCoordinate2D topLeftCoord;
    topLeftCoord.latitude = -90;
    topLeftCoord.longitude = 180;
    
    CLLocationCoordinate2D bottomRightCoord;
    bottomRightCoord.latitude = 90;
    bottomRightCoord.longitude = -180;
    
    for(CLLocation *location in path)
    {
        topLeftCoord.longitude = fmin(topLeftCoord.longitude, location.coordinate.longitude);
        topLeftCoord.latitude = fmax(topLeftCoord.latitude, location.coordinate.latitude);
        
        bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, location.coordinate.longitude);
        bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, location.coordinate.latitude);
    }
    
    MKCoordinateRegion region;
    region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5;
    region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;
    region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.1; // Add a little extra space on the sides
    region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.1; // Add a little extra space on the sides
    
    region = [_mapView regionThatFits:region];
    [_mapView setRegion:region animated:YES];
}

- (UIImage *)captureMapView {
    
    CGRect rect =_mapView.bounds;
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [_mapView.layer renderInContext:context];
    UIImage *mapImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return mapImage;
}

- (void)deletePhotoAnnotation {
    for (id annotation in _mapView.annotations) {
        if ([annotation isKindOfClass:[CustomAnnotation class]]) {
            [_mapView removeAnnotation:annotation];
        }
    }
    
}

#pragma mark - MapDelegate

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    
    if ([overlay isKindOfClass:[MKPolyline class]])
    {
        MKPolylineRenderer *renderer = nil;
        renderer = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
        renderer.strokeColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        renderer.lineWidth = 8;
        return renderer;
    }
    
    if ([overlay isKindOfClass:[GradientPolylineOverlay class]]) {
        GradientPolylineRenderer *polylineRenderer = [[GradientPolylineRenderer alloc] initWithOverlay:overlay];
        polylineRenderer.lineWidth = 8.0f;
        return polylineRenderer;
    }
    
    if ([overlay isKindOfClass:[ImageOverLay class]]) {
        ImageOverLayRenderer *imageRenderer = [[ImageOverLayRenderer alloc] initWithOverlay:overlay];
        return imageRenderer;
    }
    
    if ([overlay isKindOfClass:[MKPolygon class]]) {
        MKPolygonRenderer *polygonRenderer = [[MKPolygonRenderer alloc] initWithPolygon:overlay];
        polygonRenderer.fillColor = [UIColor colorWithWhite:0 alpha:0.5];;
        return polygonRenderer;
    }
    return nil;
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    if ([annotation isKindOfClass:[MKPointAnnotation class]]) {
        
        MKAnnotationView *annotationView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"pinAnnotation"];
        if (!annotationView) {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"pinAnnotation"];
        }
        UIImage *image = objc_getAssociatedObject(annotation, POINTANNOTATIONIMAGE);
        annotationView.image = image;
        return annotationView;
        
    }
    
    if ([annotation isKindOfClass:[CustomAnnotation class]]) {
        MKAnnotationView *customAnnotationView = [CustomAnnotation creatAnnotationForMapView:_mapView Annotation:annotation];
        return customAnnotationView;
    }
    return nil;
}

#pragma mark - CustomAnnotationDelegate

- (void)tapCustomeAnnotation:(CustomAnnotation *)annotation {
    
    if (_imgAnnotationBlock) {
        _imgAnnotationBlock(annotation);
    }
    
}


@end
