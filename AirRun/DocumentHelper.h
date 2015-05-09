//
//  DocumentHelper.h
//  SportManV2
//
//  Created by jasonWu on 3/9/15.
//  Copyright (c) 2015 JasonWu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

static NSString *const kMapImageFolder = @"MapImage";
static NSString *const kPathImageFolder = @"PathImage";
static NSString *const kHeartImage = @"HeartImage";

@interface DocumentHelper : NSObject
/**
 *  得到沙盒下document的路径
 *
 *  @return document的路径
 */
+ (NSString *)documentsPath;
/**
 *  得到沙盒document下某个文件的路径
 *
 *  @param filename 文件名称
 *
 *  @return 得到的路径
 */
+ (NSString *)DocumentPath:(NSString *)filename;

/**
 *  保存文件到document
 *
 *  @param image 图片
 *  @param name  图片名
 *
 *  @return 图片路径
 */
+ (NSString *)saveImage:(UIImage *)image ToSandBoxWithFileName:(NSString *)name;
+ (NSString *)documentsFile:(NSString *)file AtFolder:(NSString *)folder;
/**
 *  保存图片到doucument下某文件夹下
 *
 *  @param image      图片
 *  @param folderName 文件夹名
 *  @param imgName    图片名
 *
 *  @return 图片路径
 */
+ (NSString *)saveImage:(UIImage *)image ToFolderName:(NSString *)folderName WithImageName:(NSString *)imgName;

/**
 *  检测document下是否有该文件
 *
 *  @param fileName 文件名
 *
 *  @return yes 存在 no 不存在
 */
+ (BOOL)checkFileExist:(NSString *)fileName;
+ (BOOL)checkFile:(NSString *)fileName AtFolder:(NSString *)folderName;
+ (BOOL)checkPathExist:(NSString *)filepPath;

/**
 *  判断两张图片是否同一样
 *
 *  @param image_1 图片
 *  @param image_2 图片
 *
 *  @return yes 是相同 no不同
 */
+ (BOOL)image:(UIImage *)image_1 isEqualImage:(UIImage *)image_2;

/**
 *  在document下创建文件夹
 *
 *  @param folerName 文件夹名
 */
+ (void)creatFolderAtDocument:(NSString *)folerName;

+ (void)removeFile:(NSString *)fileName;
+ (void)removeFile:(NSString *)fileName InFoler:(NSString *)floderName;

@end
