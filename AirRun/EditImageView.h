//
//  EditImageView.h
//  AirRun
//
//  Created by JasonWu on 4/6/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EditImageView;
typedef void(^closeBlock)(EditImageView *editImageView);
typedef void(^deleteBlock)(UIImage *image,NSInteger idx);

@interface EditImageView : UIView
@property (copy, nonatomic) closeBlock closeBlock;
@property (copy, nonatomic) deleteBlock deleteBlock;
@property (assign, nonatomic) NSInteger currentIndex;

- (instancetype)initWithImages:(NSArray *)imgs InView:(UIView *)view;

@end
