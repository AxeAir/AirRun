//
//  CustomAnnotation.m
//  MkAnnotationTest
//
//  Created by jasonWu on 12/28/14.
//  Copyright (c) 2014 jasonWu. All rights reserved.
//

#import "CustomAnnotation.h"
#import "CustomAnnotationView.h"

@interface CustomAnnotation ()

@end

@implementation CustomAnnotation

+ (MKAnnotationView *)creatAnnotationForMapView:(MKMapView *)map Annotation:(id<MKAnnotation>)annotation {
    MKAnnotationView *returnedAnnotationView = nil;
    returnedAnnotationView = [[CustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CustomeAnnotationView"];
    
    return returnedAnnotationView;
}

@end
