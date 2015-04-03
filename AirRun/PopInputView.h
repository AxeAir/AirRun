//
//  PopInputView.h
//  AirRun
//
//  Created by ChenHao on 4/2/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^completeEdit)(NSString *string);
typedef void (^importPhoto)();

@interface PopInputView : UIView

- (instancetype)initWithSuperView:(UIView *)superview;

- (void)show;

- (void)showWithCompleteBlock:(completeEdit)block;

- (void)showWithCompleteBlock:(completeEdit)block Text:(NSString *)text photoBlock:(importPhoto)improtblock;

- (void)disimiss;


/**
 *  添加图片缩略图
 *
 *  @param imageArray 图片数组
 */
- (void)addSmallPictures:(NSArray *)imageArray;
@end
