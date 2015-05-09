//
//  ImageOverLay.h
//  AirRun
//
//  Created by jasonWu on 4/2/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface ImageOverLay : NSObject <MKOverlay>

@property (nonatomic, readonly) MKMapRect boundingMapRect;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (strong, nonatomic) UIImage *image;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate WithImage:(UIImage *)image;

@end
