//
//  HeaderView.m
//  AirRun
//
//  Created by ChenHao on 4/1/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import "HeaderView.h"
#import "UConstants.h"
#import <AVOSCloud.h>
#import "ImageHeler.h"

@interface HeaderView()

@property (nonatomic, strong) UIImageView *AvatarView;
@property (nonatomic, strong) UILabel *UsernameLabel;

@property (nonatomic, copy) SelectAvatar selectBlock;

@end

@implementation HeaderView

- (void)configUserwithBloak:(SelectAvatar)block
{
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(updateAvatar) name:@"updateAratar" object:nil];
    
    _selectBlock = block;
    AVUser *currentuser = [AVUser currentUser];

    _AvatarView  = [[UIImageView alloc] init];
    [_AvatarView setFrame:CGRectMake(30, 36, 60, 60)];
    [[_AvatarView layer] setCornerRadius:30];
    [[_AvatarView layer] setMasksToBounds:YES];
    [_AvatarView setUserInteractionEnabled:YES];
    
    [ImageHeler configAvatar:_AvatarView];
    
    [self addSubview:_AvatarView];
    
    _UsernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(_AvatarView)+10, 50, 200, 30)];
    
    [_UsernameLabel setFont:[UIFont boldSystemFontOfSize:20]];
    [_UsernameLabel setTextColor:[UIColor whiteColor]];
    [self addSubview:_UsernameLabel];
    
    if (currentuser) {
        _UsernameLabel.text =[currentuser objectForKey:@"nickName"] ;
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectavatar)];
    [_AvatarView addGestureRecognizer:tap];
    
}

- (void)selectavatar
{
//    NSLog(@"点击头像事件触发");
    _selectBlock();
}


- (void)updateAvatar
{
    AVUser *currentuser = [AVUser currentUser];
    [ImageHeler configAvatar:_AvatarView];
    _UsernameLabel.text =[currentuser objectForKey:@"nickName"] ;
}





@end
