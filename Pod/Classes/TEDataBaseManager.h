//
//  TEDataBaseManager.h
//  TEDatabase
//
//  Created by offcn on 16/1/28.
//  Copyright © 2016年 Terry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

@interface TEDataBaseManager : NSObject

@property (nonatomic, strong) FMDatabase *database;

+(instancetype)shareDataManager;

/**创建数据库*/
-(void)createDatabase ;

/**创建表格 第一个参数是你要创建的表名，第二个参数存放着你想要创建的表的字段名*/
-(void)createTableName:(NSString *)tableName fieldNameArray:(NSArray *)fieldArr;

/**插入内容 此处参数选择数组，而不是字符串，这种避免多个参数的情况下，造成方法过长，混乱不清*/
-(void)insertArray:(NSArray *)arr fieldArr:(NSArray *)fieldArr tableName:(NSString *)tableName;

/*从表中查询获得的内容,参数名为该表的名字**/
-(NSMutableArray *)selectFromTableName:(NSString*)tableName fieldArray:(NSArray *)fieldArray;

/**根据字段值，删除表中的一条数据 第一个参数为数据库中字段的名字，第二个参数为你要删除的与该字段对应的值*/
- (void)deletefieldName:(NSString *)fieldName fieldValue:(NSString *)fieldValue fromTableName:(NSString *)tableName;

/**更新某个字段的值 第一个参数表示表中的字段的名字 第二个参数表示现在这个字段的值，第三个参数表示，将要更新的字段的新值*/
-(void)updateDataFieldName:(NSString *)fieldName nowFieldValue:(NSString *)nowFieldValue updateValue:(NSString *)updateValue fromTableName:(NSString *)tableName;

/**清除表中的所有内容*/
- (BOOL)eraseTable:(NSString *)tableName;

@end


