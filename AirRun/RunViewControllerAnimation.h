//
//  RunViewControllerAnimation.h
//  AirRun
//
//  Created by jasonWu on 4/2/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <POP.h>

@interface RunViewControllerAnimation : NSObject

+ (void)view:(UIView *)view SlideOutToCenterPoint:(CGPoint)point AnimationWthiCompleteBlock:(void(^)(POPAnimation *anim, BOOL finished))completeBlock;

+ (void)view:(UIView *)view SlideInToCenterPoint:(CGPoint)point AnimationWthiCompleteBlock:(void(^)(POPAnimation *anim, BOOL finished))completeBlock;

+ (void)scalAnimationWithView:(UIView *)view WithCompleteBlock:(void(^)(POPAnimation *anim, BOOL finished))completeBlock;

+ (void)smallView:(UIView *)view ToFrame:(CGRect)frame WithCompleteBlock:(void(^)(POPAnimation *anim, BOOL finished))completeBlock;

+ (void)largeView:(UIView *)view ToFrame:(CGRect)frame WithCompleteBlock:(void(^)(POPAnimation *anim, BOOL finished))completeBlock;

@end
