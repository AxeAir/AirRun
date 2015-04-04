//
//  MapViewDelegate.h
//  AirRun
//
//  Created by jasonWu on 4/1/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MapViewDelegate : NSObject <MKMapViewDelegate>

- (instancetype)initWithMapView:(MKMapView *)mapView;

- (void)drawLineWithPoints:(NSArray *)points;
- (void)drawGradientPolyLineWithPoints:(NSArray *)pointArray;
- (void)addImage:(UIImage *)image AtLocation:(CLLocation *)location;
- (void)drawPath:(NSArray *)path;

@end
