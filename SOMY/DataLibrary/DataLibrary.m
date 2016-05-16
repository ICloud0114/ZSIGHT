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
        
//        [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]  stringByAppendingPathComponent:@"Recorders"]
        
        path = [path  stringByAppendingPathComponent:@"temperature.db"];
        dataBase = [FMDatabase databaseWithPath:path];

        if ([dataBase open])
        {
            isOpen = YES;
        }
        if ([self creatTable])
        {
            NSLog(@"建表成功");
        }
    }
    return self;
}
-(BOOL)creatTable
{
    NSString *sql = [NSString stringWithFormat:@"create table if not exists SomyData (id integer primary key autoincrement,temperature,time integer Unique,date)"];
    if ([dataBase executeUpdate:sql])
    {
        return YES;
    }
    return NO;
}
- (NSDictionary*)getDataFrameLibrary:(NSString *)time
{
    
//    [dataBase open];
    FMResultSet *rs = [dataBase executeQuery:@"select *from SomyData where time = ?",time];
    while ([rs next])
    {
        NSString *temperature = [rs stringForColumn:@"temperature"];
        NSString *time = [rs stringForColumn:@"time"];
        NSString *date = [rs stringForColumn:@"date"];
        NSDictionary *dic = [[NSDictionary alloc] init];
        [dic setValue:temperature forKey:@"TEMP"];
        [dic setValue:time forKey:@"TIME"];
        [dic setValue:date forKey:@"DATE"];
        return dic;
    }
//    [dataBase close];
    return nil;

}
- (NSMutableArray*)getAllDataFromLibrary
{
//    [dataBase open];
    
    FMResultSet *rs = [dataBase executeQuery:@"select *from SomyData order by id desc"];
    NSMutableArray *arr = [NSMutableArray array];
    while ([rs next])
    {
        NSString *temperature = [rs stringForColumn:@"temperature"];
        NSString *time = [rs stringForColumn:@"time"];
        NSString *date = [rs stringForColumn:@"date"];
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setValue:temperature forKey:@"TEMP"];
        [dic setValue:time forKey:@"TIME"];
        [dic setValue:date forKey:@"DATE"];
        [arr addObject:dic];
    }
//    [dataBase close];
    return arr;
}
- (BOOL)insertData:(NSDictionary *)data
{
    NSString *insertSql = [NSString stringWithFormat:@"replace into SomyData (temperature, time, date) values('%@','%@','%@')",data[@"TEMP"], data[@"TIME"],data[@"DATE"]];
    if ([dataBase executeUpdate:insertSql])
    {
        NSLog(@"插入/更新数据成功 ");
        return YES;
    }
    else
    {
        NSLog(@"插入数据错误 %@",[dataBase lastError]);
    }
    return NO;
    
//    return [dataBase executeUpdate:@"insert into SomyData( temperature, time, date) values (?,?,?)", data[@"TEMP"], data[@"TIME"],data[@"DATE"]];
}

- (BOOL)deleteData:(NSDictionary *)data withTime:(NSString *)time
{
    return [dataBase executeUpdate:@"delete from SomyData where time = ?",time] ;
}
- (BOOL)deleteData:(NSDictionary *)data withDate:(NSString *)date
{
    return [dataBase executeUpdate:@"delete from SomyData where date = ?",data] ;
}
- (BOOL)cleanTable:(NSString *)name
{
    return [dataBase executeUpdate:@"delete from SomyData"];
}

- (BOOL)deleteTable:(NSString *)name
{
    return [dataBase executeUpdate:@"drop table SomyData"];
}
@end
