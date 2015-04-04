//
//  ValidateHelper.h
//  SportManV2
//
//  Created by JasonWu on 2/27/15.
//  Copyright (c) 2015 JasonWu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ValidateHelper : NSObject

+ (BOOL)isValidateEmail:(NSString *)email;

+ (BOOL)isValidatePhoneNumber:(NSString *)number;

+ (BOOL)isValidateIsEmptyWithTextField:(NSString *)str;

@end
