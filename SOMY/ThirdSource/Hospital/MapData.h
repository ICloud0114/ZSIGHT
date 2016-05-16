//
//  MapData.h
//  xinlijiaoyu
//
//  Created by easaa on 6/4/13.
//  Copyright (c) 2013 easaa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MapData : NSObject
@property(nonatomic,assign)double lat;
@property(nonatomic,assign)double lng;
@property(nonatomic,retain)NSString *nameStr;
@property(nonatomic,retain)NSString *addressStr;
@property(nonatomic,retain)NSString *telephoneStr;
+(MapData*)data;
@end
