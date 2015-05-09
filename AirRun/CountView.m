//
//  CountView.m
//  AirRun
//
//  Created by jasonWu on 4/5/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import "CountView.h"



@interface CountView ()

@property (copy, nonatomic) completeBlock completeBlock;
@property (assign, nonatomic) NSInteger count;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) NSMutableArray *labelArray;

@property (strong, nonatomic) NSTimer *countTimer;

@end

@implementation CountView

- (instancetype)initWithCount:(NSInteger)count {
    self = [super init];
    if (self) {
        _count = count;
        
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.pagingEnabled = YES;
        _scrollView.scrollEnabled = NO;
        [self addSubview:_scrollView];
    }
    _scrollView.frame = CGRectMake(0, 0, self.frame.size.width/2, self.frame.size.height/2);
    _scrollView.center = CGPointMake(self.frame.size.width/2, (self.frame.size.height-64)/2 + 64);
    _scrollView.contentSize = CGSizeMake(0, _scrollView.frame.size.height*_count);
    
    if (!_labelArray) {
        _labelArray = [[NSMutableArray alloc] init];
        for (int i=1; i<_count+1; i++) {
            UILabel *label = [[UILabel alloc] init];
            label.text = [NSString stringWithFormat:@"%d",i];
            label.textColor = [UIColor whiteColor];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:120];
            [_scrollView addSubview:label];
            [_labelArray addObject:label];
        }
    }
    [_labelArray enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger idx, BOOL *stop) {
        label.frame = CGRectMake(0, _scrollView.contentSize.height-(idx+1)*_scrollView.frame.size.height, _scrollView.frame.size.width, _scrollView.frame.size.height);
    }];
    
}

- (void)startCountWithCompleteBlock:(completeBlock)block {
    
    _countTimer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(count:) userInfo:[[NSMutableDictionary alloc] initWithDictionary:@{@"count":@(_count)}] repeats:YES];
    
    if (block) {
        _completeBlock = block;
    }
    
}

- (void)count:(NSTimer *)timer {
    
    NSMutableDictionary *userInfo = timer.userInfo;
    NSInteger count = [userInfo[@"count"] integerValue];
    count--;
    
    [_scrollView setContentOffset:CGPointMake(0, (_count - count)*_scrollView.frame.size.height) animated:YES];
    
    if (count == 0) {
        [timer invalidate];
        _countTimer = nil;
        _completeBlock(self);
    }
    
    userInfo[@"count"] = @(count);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
