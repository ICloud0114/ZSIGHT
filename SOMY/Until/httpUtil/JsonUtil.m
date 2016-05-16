//
//  JsonUtil.m
//  FengWoo
//
//  Created by LiFei on 12-4-24.
//  Copyright (c) 2012年 leadwit. All rights reserved.
//

#import "JsonUtil.h"
@implementation JsonUtil

+ (NSArray *) jsonToArray:(NSString *)json
{
    //    NSError * error = nil;
    //    SBJsonParser * parser = [[SBJsonParser alloc] init];
    //    NSArray *jsonDic = [parser objectWithString:json error:&error];
    //    [parser release];
    NSArray *array = [json objectFromJSONString];
    return array;
    
}
+ (NSDictionary *) jsonToDic:(NSString *)json
{
    NSDictionary *dictionary = [json objectFromJSONString];
    return dictionary;
}
@end
