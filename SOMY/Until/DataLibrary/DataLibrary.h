//
//  DataLibrary.h
//  SOMY
//
//  Created by smile on 14-10-17.
//  Copyright (c) 2014年 easaa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"


@interface DataLibrary : NSObject

+(DataLibrary*)shareDataLibrary;

- (NSMutableArray *)getAllTableFromLibrary;

- (NSMutableArray *)getAllDataByToday;

- (NSMutableArray *)getallDataByDate:(NSString *)tableName;

- (NSString *)getMaxTemperatureFromTable:(NSString *)tableName;

- (BOOL)insertData:(NSDictionary*)data;

- (BOOL)cleanTable:(NSString *)name;

- (BOOL)deleteTable:(NSString *)name;

//- (BOOL)deleteData:(NSDictionary*)data withTime:(NSString*)time;
//
//- (BOOL)deleteData:(NSDictionary*)data withDate:(NSString*)date;

//- (BOOL)updateData:(NSDictionary*)data andKey:(NSInteger)index;



@end
