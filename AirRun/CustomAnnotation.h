//
//  CustomAnnotation.h
//  MkAnnotationTest
//
//  Created by jasonWu on 12/28/14.
//  Copyright (c) 2014 jasonWu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@class CustomAnnotation;
@protocol CustomeAnnotationDelegate <NSObject>

- (void)tapCustomeAnnotation:(CustomAnnotation *)annotation;

@end

@interface CustomAnnotation : NSObject <MKAnnotation>

@property (readwrite, nonatomic) CLLocationCoordinate2D coordinate;
//@property (strong, nonatomic) NSArray *imageArray;
@property (strong, nonatomic) UIImage *image;
@property (weak, nonatomic) id<CustomeAnnotationDelegate> delegate;

+ (MKAnnotationView *)creatAnnotationForMapView:(MKMapView *)map Annotation:(id<MKAnnotation>)annotation;

@end
