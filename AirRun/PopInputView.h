//
//  PopInputView.h
//  AirRun
//
//  Created by ChenHao on 4/2/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^EditCompleteBlock)(NSString *string);
typedef void (^ImportPhotosBlock)();

@interface PopInputView : UIView


- (instancetype)initWithSuperView:(UIView *)superview;

- (void)show;

- (void)showWithCompleteBlock:(EditCompleteBlock)block;

- (void)showWithCompleteBlock:(EditCompleteBlock)block Text:(NSString *)text photoBlock:(ImportPhotosBlock)improtblock;


/**
 *  消失
 */
- (void)disimiss;

/**
 *  添加图片缩略图
 *
 *  @param imageArray 图片数组
 */
- (void)addSmallPictures:(NSArray *)imageArray;
@end
