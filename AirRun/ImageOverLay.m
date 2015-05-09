//
//  ImageOverLay.m
//  AirRun
//
//  Created by jasonWu on 4/2/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import "ImageOverLay.h"

@interface ImageOverLay ()

@property (nonatomic, readwrite) MKMapRect boundingMapRect;
@property (nonatomic, readwrite) CLLocationCoordinate2D coordinate;

@end

@implementation ImageOverLay

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate WithImage:(UIImage *)image {
    self = [super init];
    if (self != nil) {
        _coordinate = coordinate;
        MKMapPoint centerPoint = MKMapPointForCoordinate(self.coordinate);
        _image = image;
        _boundingMapRect = MKMapRectMake(centerPoint.x-image.size.width/2, centerPoint.y-image.size.height/2, image.size.width, image.size.height);
        
    }
    return self;
}


@end
