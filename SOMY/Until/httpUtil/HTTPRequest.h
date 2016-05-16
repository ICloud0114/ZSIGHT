//
//  HTTPRequest.h
//  AShop
//  同步链接方式
//  Created by hong liu on 12-7-20.
//  Copyright (c) 2012年 easee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FBEncryptorDES.h"
#import "JsonFactory.h"
#import "JsonUtil.h"
#import "NSString+URLEncoding.h"
@interface HTTPRequest : NSObject
+(NSString*)requestForGetWithPramas:(NSDictionary*)requestParams method:(NSString*)methodStr;//通过参数列表请求接口
+(NSString*)requestForGetWithPramaStr:(NSString*)requestParamStr method:(NSString*)methodStr;//通过参数json请求接口
+(NSString*)requestForPost:(NSString *)urlStr :(NSString*)postStr;//post提交
+(NSString*)requestForGet:(NSString *)urlStr;//get提交
+(NSString*)requestForPostWithPramas:(NSDictionary*)requestParams method:(NSString*)methodStr img:(NSString*)img;
+(NSString*)requestForPostWithPramas:(NSDictionary*)requestParams method:(NSString*)methodStr img:(NSString*)img imageName:(NSString *)imageName;
+(NSString*)requestForGetWithPramas:(NSDictionary*)requestParams method:(NSString*)methodStr withURLtpye:(int)i;
+(NSString*)requestForHtmlPost:(NSString *)urlStr :(NSData*)postStr;
@end
