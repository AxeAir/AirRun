//
//  RunViewControllerAnimation.m
//  AirRun
//
//  Created by jasonWu on 4/2/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import "RunViewControllerAnimation.h"

@implementation RunViewControllerAnimation

+ (void)view:(UIView *)view SlideOutToCenterPoint:(CGPoint)point AnimationWthiCompleteBlock:(void(^)(POPAnimation *anim, BOOL finished))completeBlock {
    
    POPSpringAnimation *slideOutAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
    slideOutAnimation.toValue = [NSValue valueWithCGPoint:point];
    slideOutAnimation.springBounciness = 0.0f;
    slideOutAnimation.springSpeed = 3;
    if (completeBlock) {
        slideOutAnimation.completionBlock = completeBlock;
    }
    [view pop_addAnimation:slideOutAnimation forKey:@"slideOutAnimation"];
}

+ (void)view:(UIView *)view SlideInToCenterPoint:(CGPoint)point AnimationWthiCompleteBlock:(void (^)(POPAnimation *, BOOL))completeBlock {
    POPSpringAnimation *slideInAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
    slideInAnimation.toValue = [NSValue valueWithCGPoint:point];
    slideInAnimation.springBounciness = 10;
    slideInAnimation.springSpeed = 3;
    if (completeBlock) {
        slideInAnimation.completionBlock = completeBlock;
    }
    
    [view pop_addAnimation:slideInAnimation forKey:@"slideInAnimation"];
}

+ (void)scalAnimationWithView:(UIView *)view WithCompleteBlock:(void(^)(POPAnimation *anim, BOOL finished))completeBlock{
    
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.velocity = [NSValue valueWithCGSize:CGSizeMake(3.f, 3.f)];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.f, 1.f)];
    scaleAnimation.springBounciness = 20.0f;
    if (completeBlock) {
        scaleAnimation.completionBlock = completeBlock;
    }
    [view.layer pop_addAnimation:scaleAnimation forKey:@"layerScaleSpringAnimation"];
    
}

+ (void)smallView:(UIView *)view ToFrame:(CGRect)frame WithCompleteBlock:(void(^)(POPAnimation *anim, BOOL finished))completeBlock {
    
    POPSpringAnimation *smallAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
    smallAnimation.toValue = [NSValue valueWithCGRect:frame];
    smallAnimation.springBounciness = 0.f;
    smallAnimation.springSpeed = 3;
    if (completeBlock) {
        smallAnimation.completionBlock = completeBlock;
    }
    [view pop_addAnimation:smallAnimation forKey:@"smallAnimation"];
}

+ (void)largeView:(UIView *)view ToFrame:(CGRect)frame WithCompleteBlock:(void(^)(POPAnimation *anim, BOOL finished))completeBlock {
    
    POPSpringAnimation *largeAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
    largeAnimation.toValue = [NSValue valueWithCGRect:frame];
    largeAnimation.springSpeed = 3;
    largeAnimation.springBounciness = 20;
    if (completeBlock) {
        largeAnimation.completionBlock = completeBlock;
    }
    
    [view pop_addAnimation:largeAnimation forKey:@"slideInAnimation"];
    
}

@end
