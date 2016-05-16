//
//  HTTPRequest.m
//  AShop
//
//  Created by hong liu on 12-7-20.
//  Copyright (c) 2012年 easee. All rights reserved.
//

#import "HTTPRequest.h"

@implementation HTTPRequest
//网络请求方法
+(NSString*)requestForGet:(NSString *)urlStr
{
    // 初始化請求 
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];  
    // 設置URL  
    [request setURL:[NSURL URLWithString:urlStr]];
    // 設置HTTP方法          
    [request setHTTPMethod:@"GET"];  
    // 發送同步請求, 這裡得returnData就是返回得數據楽
    NSError *error = nil;
    NSHTTPURLResponse *response = nil;
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];

    // 釋放對象
    [request release];
    NSString *retunStr = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    return [retunStr autorelease];
}


//网络请求并对返回值进行DES解密
+(NSString*)requestForGetWithPramas:(NSDictionary*)requestParams method:(NSString*)methodStr
{
    NSString *paramsJson = [JsonFactory dictoryToJsonStr:requestParams];
    return [HTTPRequest requestForGetWithPramaStr:paramsJson method:methodStr ];
}

+(NSString*)requestForGetWithPramas:(NSDictionary*)requestParams method:(NSString*)methodStr withURLtpye:(int)i
{
    NSString *paramsJson = [JsonFactory dictoryToJsonStr:requestParams];
    return [HTTPRequest requestForGetWithPramaStr:paramsJson method:methodStr withURLtpye:i ];
}
+(NSString*)requestForGetWithPramaStr:(NSString*)requestParamStr method:(NSString*)methodStr withURLtpye:(int)i
{
    NSString *paramsJson = requestParamStr;
    //    NSLog(@"requestParamstr %@",paramsJson);
    //加密
	paramsJson = [[FBEncryptorDES encrypt:paramsJson
                                keyString:@"SDFL#)@F"] uppercaseString];
    NSString *signs= [NSString stringWithFormat:@"SDFL#)@FMethod%@Params%@SDFL#)@F",methodStr,paramsJson];
    signs = [[FBEncryptorDES md5:signs] uppercaseString];
    //    http://113.105.159.107:84
    //    icbcapp.intsun.com
    
        NSString *requestStr=nil;
    if (i==0) {
        requestStr = [NSString stringWithFormat:@"http://suomai.es-cloud.net/api/GetSomyInfo.ashx?Method=%@&Params=%@&Sign=%@",methodStr,paramsJson,signs];
    }else if(i==1){
   requestStr = [NSString stringWithFormat:SOMYAPI,methodStr,paramsJson,signs];
    }
   
    NSLog(@"request %@",requestStr);
    NSString *json = [HTTPRequest requestForGet:requestStr];
    //    NSLog(@"jsondes is %@",json);
    //解密
    json = [FBEncryptorDES decrypt:json keyString:@"SDFL#)@F"];
    json = [json URLDecodedString];
    //    NSLog(@"json is %@",json);
    return json;
    
}

+(NSString*)requestForPostWithPramas:(NSDictionary*)requestParams method:(NSString*)methodStr img:(NSString*)img
{
     NSString *paramsJson = [JsonFactory dictoryToJsonStr:requestParams];
    //加密
	paramsJson = [[FBEncryptorDES encrypt:paramsJson
                                keyString:@"SDFL#)@F"] uppercaseString];
    NSString *signs= [NSString stringWithFormat:@"SDFL#)@FMethod%@Params%@SDFL#)@F",methodStr,paramsJson];
    signs = [[FBEncryptorDES md5:signs] uppercaseString];
    //
    NSString *postUrl = [NSString stringWithFormat:SOMYAPI,methodStr,paramsJson,signs];
    NSString *postStr = [NSString stringWithFormat:@"new_img=%@",img];
    return [HTTPRequest requestForPost:postUrl
                               :postStr];

}

+(NSString*)requestForPostWithPramas:(NSDictionary*)requestParams method:(NSString*)methodStr img:(NSString*)img imageName:(NSString *)imageName
{
    NSString *paramsJson = [JsonFactory dictoryToJsonStr:requestParams];
    //加密
	paramsJson = [[FBEncryptorDES encrypt:paramsJson
                                keyString:@"SDFL#)@F"] uppercaseString];
    NSString *signs= [NSString stringWithFormat:@"SDFL#)@FMethod%@Params%@SDFL#)@F",methodStr,paramsJson];
    signs = [[FBEncryptorDES md5:signs] uppercaseString];
    //
    NSString *postUrl = [NSString stringWithFormat:SOMYAPI,methodStr,paramsJson,signs];
    NSString *postStr = [NSString stringWithFormat:@"%@=%@",imageName ,img];
    return [HTTPRequest requestForPost:postUrl
                               :postStr];
    
}

+(NSString*)requestForGetWithPramaStr:(NSString*)requestParamStr method:(NSString*)methodStr
{
    NSString *paramsJson = requestParamStr;
//    NSLog(@"requestParamstr %@",paramsJson);
    //加密
	paramsJson = [[FBEncryptorDES encrypt:paramsJson
                                keyString:@"SDFL#)@F"] uppercaseString];
    NSString *signs= [NSString stringWithFormat:@"SDFL#)@FMethod%@Params%@SDFL#)@F",methodStr,paramsJson];
    signs = [[FBEncryptorDES md5:signs] uppercaseString];
//    http://113.105.159.107:84
//    icbcapp.intsun.com
    NSString *requestStr = [NSString stringWithFormat:SOMYAPI,methodStr,paramsJson,signs];
    NSLog(@"request %@",requestStr);
    NSString *json = [HTTPRequest requestForGet:requestStr];
//    NSLog(@"jsondes is %@",json);
    //解密
    json = [FBEncryptorDES decrypt:json keyString:@"SDFL#)@F"];
    json = [json URLDecodedString];
//    NSLog(@"json is %@",json);
    return json;

}

+(NSString*)requestForPost:(NSString *)urlStr :(NSString*)postStr
{
    NSData *postData = [postStr dataUsingEncoding:NSUTF8StringEncoding];
    const char *str = [urlStr UTF8String];
    urlStr = [NSString stringWithUTF8String:str];
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    NSURL *baseUrl = [NSURL URLWithString: urlStr];
    NSMutableURLRequest *urlRequest = [[[NSMutableURLRequest alloc] initWithURL:baseUrl
                                                                    cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                                timeoutInterval:300.0f] autorelease];
    [urlRequest setHTTPMethod: @"POST"];
    [urlRequest setValue: @"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
//    NSString *postLength = [NSString stringWithFormat:@"%d",[postData length]];
//    [urlRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];

    [urlRequest setHTTPBody: postData];
    NSError *error = nil;
    NSHTTPURLResponse *response = nil;
    NSData *urlData = [NSURLConnection
                       sendSynchronousRequest:urlRequest
                       returningResponse: &response
                       error: &error];
    NSLog(@"%@",urlRequest);
    NSString *json = [[[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding] autorelease];
    NSLog(@"json %@",json);
    json = [FBEncryptorDES decrypt:json keyString:@"SDFL#)@F"];
    json = [json URLDecodedString];
//    NSURLErrorDomain
    return json;
    
}
+(NSString*)requestForHtmlPost:(NSString *)urlStr :(NSData*)postStr
{
    NSData *postData = postStr;
    const char *str = [urlStr UTF8String];
    urlStr = [NSString stringWithUTF8String:str];
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    NSURL *baseUrl = [NSURL URLWithString: urlStr];
    NSMutableURLRequest *urlRequest = [[[NSMutableURLRequest alloc] initWithURL:baseUrl
                                                                    cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                                timeoutInterval:300.0f] autorelease];
    [urlRequest setHTTPMethod: @"POST"];
    NSString *myBoundary=@"0xKhTmLbOuNdArY";//这个很重要，用于区别输入的域
    NSString *myContent=[NSString stringWithFormat:@"multipart/form-data;charset=utf-8;boundary=%@",myBoundary];//意思是要提交的是表单数据
//    NSString *myContent=[NSString stringWithFormat:@"application/x-www-form-urlencoded;charset=utf-8;boundary=%@",myBoundary];//意思是要提交的是表单数据
    [urlRequest setValue:myContent forHTTPHeaderField:@"Content-type"];//定义内容类型
        NSString *postLength = [NSString stringWithFormat:@"%d",[postData length]];
        [urlRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    [urlRequest setHTTPBody: postData];
    NSError *error = nil;
    NSHTTPURLResponse *response = nil;
    NSData *urlData = [NSURLConnection
                       sendSynchronousRequest:urlRequest
                       returningResponse: &response
                       error: &error];
    NSLog(@"%@",urlRequest);
    NSString *json = [[[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding] autorelease];
    NSLog(@"json %@",json);
    json = [FBEncryptorDES decrypt:json keyString:@"SDFL#)@F"];
    json = [json URLDecodedString];
    //    NSURLErrorDomain
    return json;
    
}

@end
