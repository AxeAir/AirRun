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

@interface MapViewDelegate ()

@property (weak, nonatomic) MKMapView *mapView;

@property (strong, nonatomic) MKPolyline *routeLine;
@property (strong, nonatomic) MKPolylineRenderer *lineRenderer;

@property (strong, nonatomic) GradientPolylineOverlay *gradientLineOverlay;
@property (strong, nonatomic) GradientPolylineRenderer *gradientRenderer;

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
    [self.mapView addOverlay:self.gradientLineOverlay];
    
//    CLLocation *location = self.points[0];
//    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
//    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(center, 250, 250);
//    [self.mapView setRegion:region animated:YES];
    
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
        [self.mapView addOverlay:self.routeLine];
    }
    
    free(mapPoints);
    
}

- (void)addImageToMapView:(UIImage *)image {
    
    MKAnnotationView *annotationView = [[MKAnnotationView alloc] init];
    annotationView.image = image;
    //annotationView.annotation = annotation;
    
    annotationView.canShowCallout = NO;
    //[_mapView addAnnotation:annotationView];
    
}


#pragma mark - MapDelegate

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    
    if ([overlay isKindOfClass:[MKPolyline class]])
    {
        MKPolylineRenderer *renderer = nil;
        renderer = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
        renderer.strokeColor = [[UIColor orangeColor] colorWithAlphaComponent:1];
        renderer.lineWidth = 5;
        return renderer;
    }
    
    if ([overlay isKindOfClass:[GradientPolylineOverlay class]]) {
        GradientPolylineRenderer *polylineRenderer = [[GradientPolylineRenderer alloc] initWithOverlay:overlay];
        polylineRenderer.lineWidth = 8.0f;
        return polylineRenderer;
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
