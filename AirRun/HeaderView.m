//
//  HeaderView.m
//  AirRun
//
//  Created by ChenHao on 4/1/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import "HeaderView.h"
#import "UConstants.h"

@interface HeaderView()

@property (nonatomic, strong) UIImageView *AvatarView;
@property (nonatomic, strong) UILabel *UsernameLabel;
@property (nonatomic, strong) UILabel *UserIntroduce;

@end

static SelectAvatar Ablock;


@implementation HeaderView

- (void)configUserInfo:(UserModel *)user withBloak:(SelectAvatar)block
{
    Ablock = block;
    _AvatarView  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"header.jpg"]];
    [_AvatarView setFrame:CGRectMake(20, 20, 60, 60)];
    [[_AvatarView layer] setCornerRadius:30];
    [[_AvatarView layer] setMasksToBounds:YES];
    [_AvatarView setUserInteractionEnabled:YES];
    [self addSubview:_AvatarView];
    
    _UsernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(_AvatarView)+10, 25, 200, 30)];
    _UsernameLabel.text = @"Yeti";
    [_UsernameLabel setFont:[UIFont boldSystemFontOfSize:20]];
    [_UsernameLabel setTextColor:[UIColor whiteColor]];
    [self addSubview:_UsernameLabel];
    
    _UserIntroduce = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(_AvatarView)+10, MaxY(_UsernameLabel)+2, 200, 20)];
    _UserIntroduce.text = @"大家好  我是Yeti";
    [_UserIntroduce setFont:[UIFont systemFontOfSize:14]];
    [_UserIntroduce setTextColor:[UIColor whiteColor]];
    [self addSubview:_UserIntroduce];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectavatar)];
    [_AvatarView addGestureRecognizer:tap];
    
}

- (void)selectavatar
{
    NSLog(@"点击头像事件触发");
    Ablock();
}

@end
