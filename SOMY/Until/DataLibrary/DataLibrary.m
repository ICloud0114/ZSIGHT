//
//  DataLibrary.m
//  SOMY
//
//  Created by smile on 14-10-17.
//  Copyright (c) 2014年 easaa. All rights reserved.
//

#import "DataLibrary.h"

@implementation DataLibrary
{
    FMDatabase *dataBase;
    BOOL isOpen;
}

+(DataLibrary*)shareDataLibrary
{
    static DataLibrary *library ;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (library == nil)
        {
            library = [[DataLibrary alloc] init];
        }
    });
    return library;
}

-(id)init
{
    self = [super init];
    if (self)
    {
        isOpen = NO;
        NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        path = [path  stringByAppendingPathComponent:@"temperature.db"];
        dataBase = [FMDatabase databaseWithPath:path];

        if ([dataBase open])
        {
            isOpen = YES;
        }
        
    }
    return self;
}

-(BOOL)creatTable
{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyyMMdd";
    NSString *dateString = [formatter stringFromDate:[NSDate date]];
    
    NSString *sql = [NSString stringWithFormat:@"create table if not exists D%@ (id primary key,TEMP,TIME varchar Unique)",dateString];
    if ([dataBase executeUpdate:sql])
    {
        return YES;
    }
    return NO;
}

//查找数据库中所有表名
- (NSMutableArray *)getAllTableFromLibrary
{
    NSString *sql = [NSString stringWithFormat:@"select * from sqlite_master where type = 'table'"];
    FMResultSet *rs = [dataBase executeQuery:sql];
    NSMutableArray *arr = [NSMutableArray array];
    while ([rs next])
    {
        NSString *string = [rs stringForColumn:@"name"];
        [arr addObject:string];
    }
    return arr;
}

- (NSMutableArray*)getAllDataByToday
{
//    [dataBase open];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyyMMdd";
    NSString *dateString = [formatter stringFromDate:[NSDate date]];
    
    NSString *sql = [NSString stringWithFormat:@"select * from D%@ order by id",dateString];
    
    FMResultSet *rs = [dataBase executeQuery:sql];
    NSMutableArray *arr = [NSMutableArray array];
    while ([rs next])
    {
        NSString *temperature = [rs stringForColumn:@"TEMP"];
        NSString *time = [rs stringForColumn:@"TIME"];

        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:temperature forKey:@"TEMP"];
        [dic setValue:time forKey:@"TIME"];

        [arr addObject:dic];
    }
    //    [dataBase close];
    return arr;

}

- (NSMutableArray*)getallDataByDate:(NSString *)tableName
{
    //    [dataBase open];
    NSString *sql = [NSString stringWithFormat:@"select * from %@ order by id",tableName];

    FMResultSet *rs = [dataBase executeQuery:sql];
    NSMutableArray *arr = [NSMutableArray array];
    while ([rs next])
    {
        NSString *temperature = [rs stringForColumn:@"TEMP"];
        NSString *time = [rs stringForColumn:@"TIME"];
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:temperature forKey:@"TEMP"];
        [dic setValue:time forKey:@"TIME"];
        
        [arr addObject:dic];
    }
    //    [dataBase close];
    return arr;
    
}

- (NSString *)getMaxTemperatureFromTable:(NSString *)tableName
{
    
    NSString *sql = [NSString stringWithFormat:@"SELECT MAX(TEMP) FROM %@",tableName];
    
    FMResultSet *rs = [dataBase executeQuery:sql];

    while ([rs next])
    {
        NSString *string = [rs stringForColumnIndex:0];
        return string;
    }
    return 0;
}

- (BOOL)insertData:(NSDictionary *)data
{
    NSMutableArray *array = [NSMutableArray array];
    [array addObjectsFromArray:[self getAllTableFromLibrary]];
    if ([array count] == 30)
    {
        [self deleteTable:[array firstObject]];
    }
    if ([self creatTable])
    {
//        NSLog(@"建表成功");
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyyMMdd";
    NSString *dateString = [formatter stringFromDate:[NSDate date]];
    
    NSString *sql = [NSString stringWithFormat:@"replace into D%@ ( TEMP, TIME) values (%@,%@)",dateString, data[@"TEMP"], data[@"TIME"]];
    if ([dataBase executeUpdate:sql])
    {
        return YES;
    }
    else
    {
        NSLog(@"ERROR----> %@",[dataBase lastError]);
        return NO;
    }
}

- (BOOL)cleanTable:(NSString *)name
{
    return [dataBase executeUpdate:@"delete from temperature"];
}

- (BOOL)deleteTable:(NSString *)name
{
    NSString *sql = [NSString stringWithFormat:@"drop table %@",name];
    return [dataBase executeUpdate:sql];
}
@end
