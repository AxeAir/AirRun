//
//  UIButton+TapAnimation.m
//  AirRun
//
//  Created by JasonWu on 4/15/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import "UIButton+TapAnimation.h"
#import <objc/runtime.h>
#import "GuideView.h"

static char *const TAPLAYER = "TapView";

@implementation UIButton (TapAnimation)

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    if (!(self.tag > 20000 && self.tag < 20010)) {
        return;
    }
    
    CALayer *maskLayer = [CALayer layer];
    maskLayer.frame = self.bounds;
    maskLayer.cornerRadius = self.layer.cornerRadius;
    maskLayer.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3].CGColor;
    
    objc_setAssociatedObject(self, TAPLAYER, maskLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self.layer addSublayer:maskLayer];

    
    self.layer.shadowRadius = 2;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];

    if (!(self.tag > 20000 && self.tag < 20010)) {
        return;
    }
    
    self.layer.shadowRadius = 4;
    CALayer *maskLayer = objc_getAssociatedObject(self, TAPLAYER);
    
    [maskLayer removeFromSuperlayer];
    
}

@end
