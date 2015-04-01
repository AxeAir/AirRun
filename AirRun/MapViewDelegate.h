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

- (instancetype)initWithMapView:(MKMapView *)mapView DelegateIsGradient:(BOOL)gardient;

- (void)drawLineWithPoints:(NSArray *)points;


@end
