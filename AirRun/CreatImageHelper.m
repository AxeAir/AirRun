//
//  CreatImageHelper.m
//  AirRun
//
//  Created by JasonWu on 4/17/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import "CreatImageHelper.h"

@implementation CreatImageHelper

+ (UIImage *)generateDistanceNodeImage:(NSString *)number {
    
    UIView *nodeView = [CreatImageHelper generateDistanceNodeViewWithNumber:number];
    
    UIGraphicsBeginImageContextWithOptions(nodeView.frame.size, NO, [UIScreen mainScreen].scale);
    [nodeView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
    
}

+ (UIView *)generateDistanceNodeViewWithNumber:(NSString *)number {
    
    UIView *nodeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 23, 23)];
    nodeView.backgroundColor = [UIColor blackColor];
    nodeView.layer.cornerRadius = nodeView.frame.size.width/2;
    nodeView.layer.borderWidth = 3;
    nodeView.clipsToBounds = YES;
    nodeView.layer.borderColor = [UIColor whiteColor].CGColor;
   
    UILabel *numberLable = [[UILabel alloc] init];
    numberLable.text = number;
    numberLable.textColor = [UIColor whiteColor];
    [numberLable sizeToFit];
    numberLable.center = CGPointMake(nodeView.frame.size.width/2, nodeView.frame.size.height/2);
    
    [nodeView addSubview:numberLable];
    
    return nodeView;
}

@end
