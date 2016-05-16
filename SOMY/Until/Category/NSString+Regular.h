//
//  NSString+Regular.h
//  Alarm
//
//  Created by easaa on 14-3-17.
//  Copyright (c) 2014年 easaa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Regular)

/**
 *  打电话
 *
 *  @param number 电话号码
 *
 *  @return
 */
+ (void)makePhoneWithNumber:(NSString *)number;
/**
 *  利用正则表达式验证
 *
 *  @param email 邮箱
 *
 *  @return 是否是邮箱
 */
+ (BOOL)isValidateEmail:(NSString *)email;


/**
 *  将十六进制数转成十进制
 *
 *  @param hexString
 *
 *  @return
 */
+ (NSString *)hextToDecimal:(NSString *)hexString;

/**
 *  将十进制数转成十六进制
 *
 *  @param decimalString
 *
 *  @return
 */
+ (NSString *)decimalToHex:(NSString *)decimalString;

/**
 *  将16进制转化为二进制
 *
 *  @param hex
 *
 *  @return 
 */
+ (NSString *)getBinaryByhex:(NSString *)hex;


+ (NSString *)DPLocalizedString:(NSString *)translation_key;

+ (NSString *)currentLanguage;
@end
