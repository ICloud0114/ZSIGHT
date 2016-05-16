//
//  DataLibrary.h
//  SOMY
//
//  Created by smile on 14-10-17.
//  Copyright (c) 2014年 easaa. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "ModelOne.h"
#import "FMDatabase.h"


@interface DataLibrary : NSObject

+(DataLibrary*)shareDataLibrary;

- (NSDictionary*)getDataFrameLibrary:(NSString*)time;

- (NSMutableArray*)getAllDataFromLibrary;

- (BOOL)insertData:(NSDictionary*)data;

- (BOOL)deleteData:(NSDictionary*)data withTime:(NSString*)time;

- (BOOL)deleteData:(NSDictionary*)data withDate:(NSString*)date;

//- (BOOL)updateData:(NSDictionary*)data andKey:(NSInteger)index;


- (BOOL)cleanTable:(NSString *)name;

- (BOOL)deleteTable:(NSString *)name;
@end
