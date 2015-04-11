//
//  ShareView.h
//  AirRun
//
//  Created by ChenHao on 4/9/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ShareViewButtonType) {
    ShareViewButtonTypeWeiBo,
    ShareViewButtonTypeFriends,
    ShareViewButtonTypeWeChat
};

@class ShareView;
@protocol ShareViewDelegate <NSObject>

- (void)shareview:(ShareView *)shareview didSelectButton:(ShareViewButtonType)buttonType;

@end

@interface ShareView : UIView

@property (nonatomic, weak) id<ShareViewDelegate> delegate;

+ (instancetype)shareInstance;

- (void)showInView:(UIView *)superView;

- (void)dismiss;


@end
