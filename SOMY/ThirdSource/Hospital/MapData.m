//
//  MapData.m
//  xinlijiaoyu
//
//  Created by easaa on 6/4/13.
//  Copyright (c) 2013 easaa. All rights reserved.
//

#import "MapData.h"

@implementation MapData
@synthesize lat,lng,nameStr,addressStr,telephoneStr;
- (void)dealloc
{

//    [addressStr release];
//    [telephoneStr release];
//    [nameStr release];
//    [super dealloc];
}
+(MapData *)data
{
    MapData *data=[[MapData alloc]init];
//    return [data autorelease];
    return data;
}
@end
