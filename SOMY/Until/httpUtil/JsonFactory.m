//
//  JsonFactory.m
//  AShop
//
//  Created by hong liu on 12-7-23.
//  Copyright (c) 2012年 easee. All rights reserved.
//

#import "JsonFactory.h"
#import "JSONKit.h"

@implementation JsonFactory
+(NSString*)dictoryToJsonStr:(NSDictionary*)jsonDic
{
    return [jsonDic JSONString];
}
@end
