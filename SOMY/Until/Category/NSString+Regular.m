//
//  NSString+Regular.m
//  Alarm
//
//  Created by easaa on 14-3-17.
//  Copyright (c) 2014年 easaa. All rights reserved.
//

#import "NSString+Regular.h"

@implementation NSString (Regular)

+ (void)makePhoneWithNumber:(NSString *)number
{
    NSString *phoneNumber = [@"telprompt://" stringByAppendingString:number];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
}

+ (BOOL)isValidateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

/**
 *  将十六进制数转成十进制
 *
 *  @param hexString
 *
 *  @return
 */
+ (NSString *)hextToDecimal:(NSString *)hexString
{
    NSString *num10Str = [NSString stringWithFormat:@"%lu", strtoul([hexString UTF8String], 0, 16)];
    return num10Str;
}

+ (NSString *)decimalToHex:(NSString *)decimalString
{
    NSString *num16Str = [NSString stringWithFormat:@"%x", [decimalString intValue]];
    return num16Str;
}

//将十进制转化为二进制,设置返回NSString 长度
+ (NSString *)decimalTOBinary:(uint16_t)tmpid backLength:(int)length
{
    NSString *a = @"";
    while (tmpid)
    {
        a = [[NSString stringWithFormat:@"%d",tmpid%2] stringByAppendingString:a];
        if (tmpid/2 < 1)
        {
            break;
        }
        tmpid = tmpid/2 ;
    }
    
    if (a.length <= length)
    {
        NSMutableString *b = [[NSMutableString alloc]init];;
        for (int i = 0; i < length - a.length; i++)
        {
            [b appendString:@"0"];
        }
        
        a = [b stringByAppendingString:a];
    }
    
    return a;
    
}




//将16进制转化为二进制
+ (NSString *)getBinaryByhex:(NSString *)hex
{
    NSMutableDictionary  *hexDic = [[NSMutableDictionary alloc] init];
    
    hexDic = [[NSMutableDictionary alloc] initWithCapacity:16];
    
    [hexDic setObject:@"0000" forKey:@"0"];
    
    [hexDic setObject:@"0001" forKey:@"1"];
    
    [hexDic setObject:@"0010" forKey:@"2"];
    
    [hexDic setObject:@"0011" forKey:@"3"];
    
    [hexDic setObject:@"0100" forKey:@"4"];
    
    [hexDic setObject:@"0101" forKey:@"5"];
    
    [hexDic setObject:@"0110" forKey:@"6"];
    
    [hexDic setObject:@"0111" forKey:@"7"];
    
    [hexDic setObject:@"1000" forKey:@"8"];
    
    [hexDic setObject:@"1001" forKey:@"9"];
    
    [hexDic setObject:@"1010" forKey:@"A"];
    
    [hexDic setObject:@"1011" forKey:@"B"];
    
    [hexDic setObject:@"1100" forKey:@"C"];
    
    [hexDic setObject:@"1101" forKey:@"D"];
    
    [hexDic setObject:@"1110" forKey:@"E"];
    
    [hexDic setObject:@"1111" forKey:@"F"];
    
    NSString *binaryString= @"";//[[NSMutableString alloc] init];
    
    for (int i=0; i<[hex length]; i++) {
        
        NSRange rage;
        
        rage.length = 1;
        
        rage.location = i;
        
        NSString *key = [hex substringWithRange:rage];
        
        //NSLog(@"%@",[NSString stringWithFormat:@"%@",[hexDic objectForKey:key]]);
        
        binaryString = [NSString stringWithFormat:@"%@%@",binaryString,[NSString stringWithFormat:@"%@",[hexDic objectForKey:key]]];
        
    }
    
    return binaryString;
    
}

+ (NSString *)DPLocalizedString:(NSString *)translation_key
{
    NSString *current = [[NSLocale preferredLanguages] objectAtIndex:0];
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"lan"]) {
        current = [[NSUserDefaults standardUserDefaults]objectForKey:@"lan"];
    }
    
    NSString *path = [[NSBundle mainBundle]pathForResource:current ofType:@"lproj"];
    NSBundle * languageBundle = [NSBundle bundleWithPath:path];
    NSString * s = [languageBundle localizedStringForKey:translation_key value:@"" table:nil];
    
    
    return s;
}

+ (NSString *)currentLanguage
{
    NSString *current = [[NSLocale preferredLanguages] objectAtIndex:0];
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"lan"]) {
        current = [[NSUserDefaults standardUserDefaults]objectForKey:@"lan"];
    }
    
    return current;
}
@end
