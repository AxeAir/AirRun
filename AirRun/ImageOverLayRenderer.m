//
//  ImageOverLayRenderer.m
//  AirRun
//
//  Created by jasonWu on 4/2/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import "ImageOverLayRenderer.h"
#import "ImageOverLay.h"

@interface ImageOverLayRenderer ()

@end

@implementation ImageOverLayRenderer

- (void)drawMapRect:(MKMapRect)mapRect zoomScale:(MKZoomScale)zoomScale inContext:(CGContextRef)ctx {
    
    ImageOverLay *imageOverLayer = (ImageOverLay *)self.overlay;
    
    UIImage *image = imageOverLayer.image;
    CGImageRef imageReference = image.CGImage;
    
    MKMapRect theMapRect    = [self.overlay boundingMapRect];
    CGRect theRect           = [self rectForMapRect:theMapRect];
    CGRect clipRect     = [self rectForMapRect:mapRect];
    
    CGContextAddRect(ctx, clipRect);
    CGContextClip(ctx);
    
    CGContextDrawImage(ctx, theRect, imageReference);
    
}


@end
