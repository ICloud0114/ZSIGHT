//
//  LeSimple.h
//  Camera
//
//  Created by 阮毅文 on 14-10-9.
//  Copyright (c) 2014年 阮毅文. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LeDiscovery.h"
#import "LePeripheralService.h"
@interface LeSimple : NSObject<LePeripheralDelegate>
@property (strong, nonatomic) LePeripheralService *service;
@property (strong, nonatomic) NSTimer *connectionTimer;
@property (strong, nonatomic) NSMutableArray *foundPeripherals;
+ (LeSimple *)shareLeSimple;
- (void)searchDevice;
- (void) writeValue:(NSData *)data;
-(void)stop;
//- (vos\id) connectionDevice;
@end
