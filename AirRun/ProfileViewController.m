//
//  ProfileViewController.m
//  AirRun
//
//  Created by ChenHao on 4/5/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import "ProfileViewController.h"
#import "UConstants.h"
#import <AVOSCloud.h>
#import "AirPickerView.h"
#import "EditNickNameViewController.h"
#import "EditSignViewController.h"
#import "RESideMenu.h"
#import "RegisterAndLoginViewController.h"
#import "NSDate+change.h"
@interface ProfileViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) UIPickerView *genderPickerView;
@property (nonatomic, strong) UIImagePickerController *imagePickerController;
@property (nonatomic, strong) UIImageView *avatarImageView;

@end

@implementation ProfileViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"个人设置";
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 8;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifer = @"profileCell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifer];
    }
    
    UILabel *title = [[UILabel alloc] init];
    [title setFrame:CGRectMake(18, 0, 100, HEIGHT(cell))];
    [title setFont:[UIFont systemFontOfSize:14]];
    [cell addSubview:title];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    [cell.detailTextLabel setFont:[UIFont systemFontOfSize:14]];
    cell.detailTextLabel.text =@"未填写";
    AVUser *user = [AVUser currentUser];

    switch (indexPath.row) {
        case 0:{
            [title setFrame:CGRectMake(18, 0, 100, 80)];
            [title setText:@"头像"];
            
            cell.detailTextLabel.text =@"";
            
            if ([user objectForKey:@"avatar"]) {
                
                AVFile *avatarData = [user objectForKey:@"avatar"];
                NSData *resumeData = [avatarData getData];
                
                if (_avatarImageView == nil) {
                    _avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(Main_Screen_Width-90, 10, 60, 60)];
                    [[_avatarImageView layer] setCornerRadius:30];
                    [[_avatarImageView layer] setMasksToBounds:YES];
                    _avatarImageView.image = [UIImage imageWithData:resumeData];
                    [cell addSubview:_avatarImageView];
                }
                else
                {
                    _avatarImageView.image = [UIImage imageWithData:resumeData];
                }
            
            }
        }
            break;
        case 1:{
            [title setText:@"昵称"];
            if ([user objectForKey:@"nickName"]) {
                cell.detailTextLabel.text =[user objectForKey:@"nickName"];
            }
        }
            break;
        case 2:{
            [title setText:@"性别"];
            if ([user objectForKey:@"gender"]) {
                cell.detailTextLabel.text =[user objectForKey:@"gender"];
            }
        }
            break;
        case 3:{
            [title setText:@"身高"];
            if ([user objectForKey:@"height"]) {
                cell.detailTextLabel.text =[NSString stringWithFormat:@"%@ cm",[user objectForKey:@"height"]];
            }
        }
            break;
        case 4:{
            [title setText:@"体重"];
            if ([user objectForKey:@"weight"]) {
                cell.detailTextLabel.text =[NSString stringWithFormat:@"%@ kg",[user objectForKey:@"weight"]];
            }
        }
            break;
        case 5:{
            [title setText:@"生日"];
            if ([user objectForKey:@"birthday"]) {
                cell.detailTextLabel.text =[user objectForKey:@"birthday"];
            }
        }
            break;
        case 6:{
            [title setText:@"签名"];
            if ([user objectForKey:@"introduction"]) {
                cell.detailTextLabel.text =[user objectForKey:@"introduction"];
            }
            
        }
            break;
        case 7:{
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            [title setText:@"邮箱"];
            if (user.email) {
                cell.detailTextLabel.text =user.email;
            }
        }
            break;
            
        default:
            break;
    }
    
    if(indexPath.row == 0)
    {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, 80-1, Main_Screen_Width-15, 0.5)];
        [line setBackgroundColor:RGBCOLOR(235, 235, 235)];
        [cell.contentView addSubview:line];
    }
    
    else if(indexPath.row !=7)
    {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, HEIGHT(cell)-1, Main_Screen_Width-15, 0.5)];
        [line setBackgroundColor:RGBCOLOR(235, 235, 235)];
        [cell.contentView addSubview:line];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    __block UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    switch (indexPath.row) {
        case 0:{
            [self clickAvatar];
        }
            break;
        case 1:{
            EditNickNameViewController *editVC = [[EditNickNameViewController alloc] initWithBlock:^(NSString *name) {
                cell.detailTextLabel.text = name;
                AVUser *user = [AVUser currentUser];
                [user setObject:name forKey:@"nickName"];
                [user save];
                
            } name:cell.detailTextLabel.text];
            [self.navigationController pushViewController:editVC animated:YES];
        }
            break;
        case 2:{
            NSArray *temp = @[@"男",@"女",@"保密"];
        
            AirPickerView *air = [[AirPickerView alloc] initWithFrame:CGRectMake(0, Main_Screen_Height-300, Main_Screen_Width, 300) dataSource:temp];
            [air showInView:self.view completeBlock:^(NSInteger index, NSString *string) {
                [cell.detailTextLabel setText:string];
                AVUser *user = [AVUser currentUser];
                [user setObject:string forKey:@"gender"];
                [user save];
            }];
            
        }
            break;
            
        case 3:{
            
            NSMutableArray *temp = [[NSMutableArray alloc] init];
            NSInteger i = 140;
            for (; i<=200; i++) {
                [temp addObject:[NSString stringWithFormat:@"%ld",i]];
            }
            AirPickerView *air = [[AirPickerView alloc] initWithFrame:CGRectMake(0, Main_Screen_Height-300, Main_Screen_Width, 300) dataSource:temp];
            [air showInView:self.view completeBlock:^(NSInteger index, NSString *string) {
                [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@ cm",string]];
                AVUser *user = [AVUser currentUser];
                [user setObject:string forKey:@"height"];
                [user save];
            }];
        }
            break;
        case 4:{
            
            NSMutableArray *temp = [[NSMutableArray alloc] init];
            NSInteger i = 30;
            for (; i<=100; i++) {
                [temp addObject:[NSString stringWithFormat:@"%ld",i]];
            }
            
            AirPickerView *air = [[AirPickerView alloc] initWithFrame:CGRectMake(0, Main_Screen_Height-300, Main_Screen_Width, 300) dataSource:temp];
            [air showInView:self.view completeBlock:^(NSInteger index, NSString *string) {
                [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@ kg",string]];
                AVUser *user = [AVUser currentUser];
                [user setObject:string forKey:@"weight"];
                [user save];
            }];
        }
            break;
            
        case 5:{
            
            AirPickerView *air = [[AirPickerView alloc] initWithDatePickerFrames:CGRectMake(0, Main_Screen_Height-300, Main_Screen_Width, 300) date:nil];
//            [air showInView:self.view completeBlock:^(NSInteger index, NSString *string) {
//                
//                
//                [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@ kg",string]];
//                AVUser *user = [AVUser currentUser];
//                [user setObject:string forKey:@"weight"];
//                //[user save];
//            }];
            
            [air showDateInView:self.view completeBlock:^(NSDate *date) {
                
                NSString *dateString = [NSDate BirthDateStringWithBirthDate:date];
                [cell.detailTextLabel setText:dateString];
                AVUser *user = [AVUser currentUser];
                [user setObject:dateString forKey:@"birthday"];
                [user save];
            }];
            
        }
            break;
            
        case 6:{
            
            EditSignViewController *sign = [[EditSignViewController alloc] initWithBlock:^(NSString *name) {
                
                cell.detailTextLabel.text = name;
                AVUser *user = [AVUser currentUser];
                [user setObject:name forKey:@"introduction"];
                [user save];
            } sign:cell.detailTextLabel.text];
            
            [self.navigationController pushViewController:sign animated:YES];
            
            
        }
            break;
            
            
        default:
            break;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 48)];
    UIButton *logout = [[UIButton alloc] initWithFrame:CGRectMake(0, 25, Main_Screen_Width, 48)];
    [footer addSubview:logout];
    [logout setBackgroundColor:RGBCOLOR(214, 36, 36)];
    [logout setTitle:@"退出登录" forState:UIControlStateNormal];
    [logout setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [logout addTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];
    return footer;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 80;
    }
    return 44;
}
#pragma mark UIACtionsheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag==900000) {
        if (buttonIndex==0) {
            _imagePickerController=[[UIImagePickerController alloc] init];
            _imagePickerController.sourceType=UIImagePickerControllerSourceTypeCamera;
            _imagePickerController.delegate=self;
            _imagePickerController.allowsEditing = YES;
            [self presentViewController:_imagePickerController animated:YES completion:nil];
            
        }
        else if (buttonIndex==1)
        {
            _imagePickerController=[[UIImagePickerController alloc] init];
            _imagePickerController.delegate=self;
            _imagePickerController.allowsEditing=YES;
            [self presentViewController:_imagePickerController animated:YES completion:nil];
        }
        
    }
    if (actionSheet.tag == 900001) {
        if (buttonIndex == 0) {
            [AVUser logOut];
            RegisterAndLoginViewController *RegisterAndLogin = [[RegisterAndLoginViewController alloc] init];
            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:RegisterAndLogin] animated:YES];
            [self.sideMenuViewController hideMenuViewController];
        }
        
        
        
    }
}


#pragma mark UIImagePick Delegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        UIImage* image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        NSData *data;
        data = UIImageJPEGRepresentation(image, 0.8);
        //图片保存的路径
        //这里将图片放在沙盒的documents文件夹中
        NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        //文件管理器
        NSFileManager *fileManager = [NSFileManager defaultManager];
        //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
        [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
        [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:@"/image.png"] contents:data attributes:nil];
        //得到选择后沙盒中图片的完整路径
        //NSString *imgPath = [[NSString alloc]initWithFormat:@"%@%@",DocumentsPath,  @"/image.png"];
        //关闭相册界面
        [picker dismissViewControllerAnimated:YES completion:nil];
        _avatarImageView.image = image;
        
        NSData *imageData = UIImagePNGRepresentation(image);
        AVFile *imageFile = [AVFile fileWithName:@"image.png" data:imageData];
        [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            NSLog(@"上传成功");
                AVUser *user = [AVUser currentUser];
                [user setObject:imageFile forKey:@"avatar"];
                [user save];
        } progressBlock:^(NSInteger percentDone) {
            NSLog(@"%ld",percentDone);
        }];
        

        
    }
    
}


#pragma mark Function 

- (void)clickAvatar
{

    UIActionSheet *actionsheet =[[UIActionSheet alloc] initWithTitle:@"选择头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
    [actionsheet setTag:900000];
    [actionsheet showInView:self.view];
    
}

- (void)logout:(id)sender
{
    UIActionSheet *actionsheet =[[UIActionSheet alloc] initWithTitle:@"退出登陆会清楚本地所有数据，是否继续" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"退出登陆" otherButtonTitles:nil, nil];
    [actionsheet setTag:900001];
    [actionsheet showInView:self.view];

}


@end
