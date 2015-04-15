//
//  EditSignViewController.m
//  AirRun
//
//  Created by ChenHao on 4/6/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import "EditSignViewController.h"
#import "UConstants.h"

@interface EditSignViewController ()<UITextViewDelegate>

@property (nonatomic, copy) editComplete editCompleteBlock;

@property (nonatomic, strong) UITextView *signTextView;

@end

@implementation EditSignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self.navigationController navigationBar] setBarTintColor:[UIColor redColor]];
    [self setTitle:@"修改签名"];
    [self.view setBackgroundColor:RGBCOLOR(238, 238, 238)];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(completeEdit:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancelEdit:)];
    self.navigationItem.leftBarButtonItem = leftItem;
}


- (instancetype)initWithBlock:(editComplete)block sign:(NSString *)sign
{
    self = [super init];
    if (self) {
        _editCompleteBlock = block;
        [self commonInit:sign];
    }
    return self;
}


- (void)commonInit:(NSString *)sign
{
    _signTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 140)];
    [_signTextView setBackgroundColor:[UIColor whiteColor]];
    [_signTextView setFont:[UIFont systemFontOfSize:12]];
    [_signTextView setContentOffset:CGPointZero];
    //[_signTextView setContentInset:UIEdgeInsetsMake(-70, 0, 0, 0)];
    [_signTextView setText:sign];
    [self.view addSubview:_signTextView];
    [_signTextView becomeFirstResponder];
}


- (void)completeEdit:(id)sender
{
    _editCompleteBlock(_signTextView.text);
    [_signTextView resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)cancelEdit:(id)sender
{
    [_signTextView resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}


@end
