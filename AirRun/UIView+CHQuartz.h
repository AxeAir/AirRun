//
//  UIView+CHQuartz.h
//  quartz
//
//  Created by 陈 浩 on 14-11-17.
//  Copyright (c) 2012年 陈 浩. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (CHQuartz)



//矩形
-(void)drawRectangle:(CGRect)rect;
//圆角矩形
-(void)drawRectangle:(CGRect)rect withRadius:(float)radius;
//画多边形
//pointArray = @[[NSValue valueWithCGPoint:CGPointMake(200, 400)]];
-(void)drawPolygon:(NSArray *)pointArray;
//圆形 默认为黑色
-(void)drawCircleWithCenter:(CGPoint)center
                     radius:(float)radius;
//带颜色的实心圆形
-(void)drawCircleWithCenter:(CGPoint)center
                     radius:(float)radius
                        red:(NSInteger)red
                      green:(NSInteger)green
                       blue:(NSInteger)blue;

//空心圆 默认为黑色
-(void)drawCircleWithNoCenter:(CGPoint)center
                       radius:(float)radius;

//空心圆 带颜色
-(void)drawCircleWithNoCenter:(CGPoint)center
                       radius:(float)radius
                          red:(NSInteger)red
                        green:(NSInteger)green
                         blue:(NSInteger)blue;

//曲线
-(void)drawCurveFrom:(CGPoint)startPoint
                  to:(CGPoint)endPoint
       controlPoint1:(CGPoint)controlPoint1
       controlPoint2:(CGPoint)controlPoint2;

//弧线
-(void)drawArcFromCenter:(CGPoint)center
                  radius:(float)radius
              startAngle:(float)startAngle
                endAngle:(float)endAngle
               clockwise:(BOOL)clockwise;
//扇形
-(void)drawSectorFromCenter:(CGPoint)center
                     radius:(float)radius
                 startAngle:(float)startAngle
                   endAngle:(float)endAngle
                  clockwise:(BOOL)clockwise;

//直线
-(void)drawLineFrom:(CGPoint)startPoint
                 to:(CGPoint)endPoint;

//直线 带颜色
-(void)drawLineFrom:(CGPoint)startPoint
                 to:(CGPoint)endPoint
              color:(UIColor*)color
              width:(CGFloat)width;


/*
 折线，连续直线
 pointArray = @[[NSValue valueWithCGPoint:CGPointMake(200, 400)]];
 */
-(void)drawLines:(NSArray *)pointArray;


-(void)drawText:(CGRect)rect text:(NSString*)text;
-(void)drawText:(CGRect)rect text:(NSString*)text fontSize:(NSInteger)size;

-(CGMutablePathRef)pathwithFrame:(CGRect)frame withRadius:(float)radius;


@end
