//
//  TEDataBaseManager.m
//  TEDatabase
//
//  Created by offcn on 16/1/28.
//  Copyright © 2016年 Terry. All rights reserved.
//

#import "TEDataBaseManager.h"

@interface TEDataBaseManager()


@end

@implementation TEDataBaseManager

+ (instancetype)shareDataManager
{
    static TEDataBaseManager *dataManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dataManager = [[TEDataBaseManager alloc]init];
    });
    return dataManager;
}

- (void)createDatabase
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSString *existPath=[NSString stringWithFormat:@"%@/Documents/Downloads",NSHomeDirectory()];
    NSLog(@"%@",existPath);
    if (![fileManager fileExistsAtPath:existPath]) {
        [fileManager createDirectoryAtPath:existPath withIntermediateDirectories:YES attributes:nil error:&error];
    }
    NSString *path=[NSString stringWithFormat:@"%@/Documents/Downloads/DownloadInfo.sqlite",NSHomeDirectory()];
    _database = [FMDatabase databaseWithPath:path];
    if ([_database open]) {
        NSLog(@"create database success");
    }else{
        NSLog(@"create database failed");
    }
}

-(void)createTableName:(NSString *)tableName fieldNameArray:(NSArray *)fieldArr
{
     NSString *createTable = [NSString stringWithFormat:@"create table if not exists '%@'(",tableName];
    for (int i = 0; i < fieldArr.count; i ++) {
        if (i < fieldArr.count - 1) {
            createTable = [NSString stringWithFormat:@"%@%@ text not null,",createTable,fieldArr[i]];
        } else {
            createTable = [NSString stringWithFormat:@"%@%@ text not null)",createTable,fieldArr[i]];
        }
        
    }
    BOOL isSucceed = [_database executeUpdate:createTable];
    if (isSucceed) {
        NSLog(@"create table success");
    }else{
        NSLog(@"create table success");
    }

    
}

-(void)insertArray:(NSArray *)arr fieldArr:(NSArray *)fieldArr tableName:(NSString *)tableName
{
    NSString *insertSql = [NSString stringWithFormat:@"insert into %@(",tableName];
    for (int i = 0; i < fieldArr.count; i ++) {
        if (i < fieldArr.count - 1) {
            insertSql = [NSString stringWithFormat:@"%@%@,",insertSql,fieldArr[i]];
        } else {
            insertSql = [NSString stringWithFormat:@"%@%@)values(",insertSql,fieldArr[i]];
        }
    }
    
    for (int i = 0; i < fieldArr.count; i ++) {
        if (i < fieldArr.count - 1) {
            insertSql = [NSString stringWithFormat:@"%@'%@',",insertSql,arr[i]];
        } else {
            insertSql = [NSString stringWithFormat:@"%@'%@')",insertSql,arr[i]];
        }
    }
    
    if ([_database executeUpdate:insertSql]) {
        NSLog(@"插入成功");
    }else{
        NSLog(@"插入失败");
    }

}

-(NSMutableArray *)selectFromTableName:(NSString*)tableName fieldArray:(NSArray *)fieldArray{
    NSString *selectSql = [NSString stringWithFormat:@"select *from %@",tableName];
    FMResultSet *set = [_database executeQuery:selectSql];
    NSMutableArray  *dataArr = [NSMutableArray  array];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    while ([set next]) {
        NSString *tempStr = nil;
        for (int i = 0; i < fieldArray.count; i ++) {
           tempStr  = [set stringForColumn:fieldArray[i]];
            dic[fieldArray[i]] = tempStr;
        }
        [dataArr addObject:dic];
    }
    return dataArr;
}

- (void)deletefieldName:(NSString *)fieldName fieldValue:(NSString *)fieldValue fromTableName:(NSString *)tableName {
    
    NSString *deleteSql = [NSString stringWithFormat:@"delete from %@ where %@=%@",tableName,fieldName,fieldValue];
    if ([_database executeUpdate:deleteSql]) {
        NSLog(@"删除成功");
    }else{
        NSLog(@"删除失败");
    }
}

-(void)updateDataFieldName:(NSString *)fieldName nowFieldValue:(NSString *)nowFieldValue updateValue:(NSString *)updateValue fromTableName:(NSString *)tableName
{
    NSString *moidify = [NSString stringWithFormat:@"update %@ set %@=%@ where %@='%@'",tableName,fieldName,updateValue,fieldName,nowFieldValue];
    if ([_database executeUpdate:moidify]) {
        NSLog(@"更新成功");
    }else{

        NSLog(@"更新失败");
    }
}

- (BOOL)eraseTable:(NSString *)tableName
{
    NSString *sqlstr = [NSString stringWithFormat:@"delete from %@",tableName];
    if (![_database executeUpdate:sqlstr])
    {
        return NO;
    }
    return YES;
}

@end
