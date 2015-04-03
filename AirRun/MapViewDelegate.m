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

@interface MapViewDelegate ()

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

- (void)addImage:(UIImage *)image AtLocation:(CLLocation *)location {
    
    _imageOverlay = [[ImageOverLay alloc] initWithCoordinate:location.coordinate WithImage:image];
//    [self.mapView addOverlay:imageOverlay];
    [self.mapView insertOverlay:_imageOverlay aboveOverlay:self.gradientLineOverlay];
    
}

-(void)drawGradientPolyLineWithPoints:(NSArray *)pointArray{
    
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
    [self drawLineWithPoints:pointArray];
    
    
    
    free(velocity);
    
}

- (void)drawLineWithPoints:(NSArray *)points{
    
    MKMapPoint northEastPoint = MKMapPointMake(0.0f, 0.0f);
    MKMapPoint southWestPoint = MKMapPointMake(0.0f, 0.0f);
    MKMapPoint *mapPoints = malloc(sizeof(CLLocationCoordinate2D)*points.count);
    
    for (NSUInteger idx = 0; idx < points.count; idx++) {
        //        NSLog(@"%lu",idx);
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

#pragma mark - MapDelegate

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    
    if ([overlay isKindOfClass:[MKPolyline class]])
    {
        MKPolylineRenderer *renderer = nil;
        renderer = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
        renderer.strokeColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        renderer.lineWidth = 9;
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
    return nil;
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    if ([annotation isKindOfClass:[MKPointAnnotation class]]) {
        
        MKPinAnnotationView *pinAnnotation = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"pinAnnotation"];
        if (!pinAnnotation) {
            pinAnnotation = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"pinAnnotation"];
            pinAnnotation.animatesDrop = YES;
        }
        return pinAnnotation;
        
    }
    return nil;
}


@end
