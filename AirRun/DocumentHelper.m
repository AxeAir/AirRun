//
//  DocumentHelper.m
//  SportManV2
//
//  Created by jasonWu on 3/9/15.
//  Copyright (c) 2015 JasonWu. All rights reserved.
//

#import "DocumentHelper.h"


@implementation DocumentHelper

+ (NSString *)documentsPath {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
    
}

+ (NSString *)saveImage:(UIImage *)image ToSandBoxWithFileName:(NSString *)name {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:name];   // 保存文件的名称
    [UIImagePNGRepresentation(image)writeToFile:filePath atomically:YES];
    
    return filePath;
}

+ (NSString *)saveImage:(UIImage *)image ToFolderName:(NSString *)folderName WithImageName:(NSString *)imgName {
    
    NSString *path = [NSString stringWithFormat:@"%@/%@",[self DocumentPath:folderName],imgName];
    [UIImagePNGRepresentation(image)writeToFile:path atomically:YES];
    return [NSString stringWithFormat:@"%@/%@",folderName,imgName];
    
}

+ (NSString *)DocumentPath:(NSString *)filename {
    
    NSString *documentsPath = [self documentsPath];
    return [documentsPath stringByAppendingPathComponent:filename];
    
}

+ (BOOL)checkFileExist:(NSString *)fileName {
    
    NSString *filePath = [self DocumentPath:fileName];
    return [[NSFileManager defaultManager] fileExistsAtPath:filePath];
}

+ (BOOL)checkFile:(NSString *)fileName AtFolder:(NSString *)folderName {
    
    return [[NSFileManager defaultManager] fileExistsAtPath:[self documentsFile:fileName AtFolder:folderName]];
}

+ (BOOL)checkPathExist:(NSString *)filePath
{
    return [[NSFileManager defaultManager] fileExistsAtPath:filePath];
}

+ (BOOL)image:(UIImage *)image_1 isEqualImage:(UIImage *)image_2 {
    
    NSData *imageData1 = UIImagePNGRepresentation(image_1);
    NSData *imageData2 = UIImagePNGRepresentation(image_2);
    
    if ([imageData1 isEqualToData:imageData2]) {
        return YES;
    } else {
        return NO;
    }
    
}

+ (void)creatFolderAtDocument:(NSString *)folerName {
    
    NSLog(@"%@",[self documentsPath]);
    NSString *path = [[self documentsPath] stringByAppendingPathComponent:folerName];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
}

+ (NSString *)documentsFile:(NSString *)file AtFolder:(NSString *)folder {
    
    NSString *folderPath = [self DocumentPath:folder];
    return [folderPath stringByAppendingPathComponent:file];
}

@end
