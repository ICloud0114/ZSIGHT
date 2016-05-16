//
//  NSString+StringUtil.m
//  AShop
//
//  Created by FlipFlopStudio on 12-7-28.
//  Copyright (c) 2012年 easee. All rights reserved.
//

#import "NSString+StringUtil.h"

@implementation NSString (StringUtil)
- (BOOL) isEmailAddress { 
    
    NSString *emailRegex = @"^\\w+((\\-\\w+)|(\\.\\w+))*@[A-Za-z0-9]+((\\.|\\-)[A-Za-z0-9]+)*.[A-Za-z0-9]+$"; 
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex]; 
    
    return [emailTest evaluateWithObject:self]; 
} 
@end
