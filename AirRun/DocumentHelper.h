//
//  DocumentHelper.h
//  SportManV2
//
//  Created by jasonWu on 3/9/15.
//  Copyright (c) 2015 JasonWu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

static NSString *const kImageFolder = @"Image";

@interface DocumentHelper : NSObject

+ (NSString *)documentsPath;

+ (NSString *)DocumentPath:(NSString *)filename;

+ (NSString *)saveImage:(UIImage *)image ToSandBoxWithFileName:(NSString *)name;

+ (BOOL)checkFileExist:(NSString *)fileName;

+ (BOOL)checkFile:(NSString *)fileName AtFolder:(NSString *)folderName;

+ (BOOL)image:(UIImage *)image_1 isEqualImage:(UIImage *)image_2;

+ (void)creatFolderAtDocument:(NSString *)folerName;

+ (NSString *)documentsFile:(NSString *)file AtFolder:(NSString *)folder;

@end
