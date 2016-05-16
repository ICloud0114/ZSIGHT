//
//  JsonUtil.h
//  FengWoo
//  json解析的工具类
//  Created by LiFei on 12-4-24.
//  Copyright (c) 2012年 leadwit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONKit.h"

@interface JsonUtil : NSObject
+ (NSArray *) jsonToArray:(NSString *)json;
+ (NSDictionary *) jsonToDic:(NSString *)json;
@end
