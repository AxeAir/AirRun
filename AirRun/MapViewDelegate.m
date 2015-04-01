//
//  MapViewDelegate.m
//  AirRun
//
//  Created by jasonWu on 4/1/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import "MapViewDelegate.h"

@interface MapViewDelegate ()

@property (weak, nonatomic) MKMapView *mapView;

@property (strong, nonatomic) MKPolyline *routeLine;
@property (strong, nonatomic) MKPolylineRenderer *lineRenderer;

@property (assign, nonatomic) BOOL gradient;

@end

@implementation MapViewDelegate

- (instancetype)initWithMapView:(MKMapView *)mapView DelegateIsGradient:(BOOL)gardient {
    
    self = [super init];
    if (self) {
        _mapView = mapView;
        _gradient = gardient;
    }
    return self;
}

#pragma mark - Map Action

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


#pragma mark - MapDelegate

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    
    MKPolylineRenderer *renderer = nil;
    if ([overlay isKindOfClass:[MKPolyline class]])
    {
        renderer = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
        
        renderer.strokeColor = [[UIColor orangeColor] colorWithAlphaComponent:1];
        renderer.lineWidth = 5;
    }
    
    return renderer;
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
