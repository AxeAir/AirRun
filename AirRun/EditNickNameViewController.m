//
//  EditNickNameViewController.m
//  AirRun
//
//  Created by ChenHao on 4/5/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import "EditNickNameViewController.h"
#import "UConstants.h"

@interface EditNickNameViewController ()

@property (nonatomic, copy) editComplete editCompleteBlock;

@property (nonatomic, strong) UITextField *nameTextField;

@end

@implementation EditNickNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[self.navigationController navigationBar] setBarTintColor:[UIColor redColor]];
    [self setTitle:@"修改昵称"];
    [self.view setBackgroundColor:RGBCOLOR(238, 238, 238)];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(completeEdit:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancelEdit:)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
}


- (instancetype)initWithBlock:(editComplete)block name:(NSString *)name
{
    self = [super init];
    if (self) {
        _editCompleteBlock = block;
        [self commonInit:name];
    }
    return self;
}


- (void)commonInit:(NSString *)name
{
    
    
    _nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 50, Main_Screen_Width, 50)];
    
    
    CGRect frame = [_nameTextField frame];  //为你定义的UITextField
    frame.size.width = 15;
    UIView *leftview = [[UIView alloc] initWithFrame:frame];
    _nameTextField.leftViewMode = UITextFieldViewModeAlways;  //左边距为15pix
    _nameTextField.leftView = leftview;
    
    
    [_nameTextField setBackgroundColor:[UIColor whiteColor]];
    _nameTextField.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    [_nameTextField setText:name];
    [self.view addSubview:_nameTextField];
    //[_nameTextField becomeFirstResponder];
}


- (void)completeEdit:(id)sender
{
    _editCompleteBlock(_nameTextField.text);
    [_nameTextField resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)cancelEdit:(id)sender
{
    [_nameTextField resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}


@end
