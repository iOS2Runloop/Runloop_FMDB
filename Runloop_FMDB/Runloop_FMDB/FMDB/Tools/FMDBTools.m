//
//  FMDBTools.m
//  Runloop_FMDB
//
//  Created by  ZhuHong on 2018/1/3.
//  Copyright © 2018年 CoderHG. All rights reserved.
//

#import "FMDBTools.h"
#import "FMDB.h"
#import "BaseModel.h"

@interface FMDBTools ()

/** 数据库 */
@property (nonatomic, strong) FMDatabaseQueue *dbQueue;
/** 数据库文件名 */
@property (nonatomic, copy) NSString* fileName;

@end


@implementation FMDBTools

/**
 打开数据库
 
 @param fileName 数据库的名字
 @return 返回打开回馈 YES: 成功   NO: 失败
 */
+ (BOOL)openDBWithFileName:(NSString *)fileName {
    
    if (!fileName || ![fileName isKindOfClass:[NSString class]] || (fileName.length == 0) || ![fileName hasSuffix:@".db"]) {
        return NO;
    }
    
    // 单例对象
    FMDBTools* fmdbTools = [self sharedInstance];
    if ([fmdbTools.fileName isEqualToString:fileName] && fmdbTools.dbQueue) {
        // 已经打开
        NSLog(@"已经打开");
        return YES;
    }
    
    // 赋值
    fmdbTools.fileName = fileName.copy;
    
    // 关闭数据库
    if (fmdbTools.dbQueue) {
        [fmdbTools close];
    }
    
    NSString* dbPath = [self dbPathWithFileName:fileName];
    NSLog(@"%@", dbPath);
    
    fmdbTools.dbQueue = [[FMDatabaseQueue alloc] initWithPath:dbPath];
    
    return (fmdbTools.dbQueue != nil);
}

/**
 创建表
 */
+ (BOOL)createWithModel:(BaseModel*)model {
    NSString* sqlSTR = HGCreateTable([model tableName], model.description);
    return [self createTableWithSql:sqlSTR];
}

/**
 直接插入一条消息
 
 @param model 插入的对象
 @return 插入结果
 */
+ (BOOL)insertDataModel:(BaseModel*)model {
    
    NSDictionary* keyValues = [model dataForProperty];
    __block BOOL res = YES;
    // 单例对象
    FMDBTools* fmdbTools = [self sharedInstance];
    if (fmdbTools.dbQueue == nil) {
        res = NO;
    }
    [fmdbTools.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSMutableArray *columns = [NSMutableArray array];
        NSMutableArray *values = [NSMutableArray array];
        NSMutableArray *placeholder = [NSMutableArray array];
        
        [keyValues enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            if (obj && ![obj isEqual:[NSNull null]]) {
                [columns addObject:key];
                [values addObject:obj];
                [placeholder addObject:@"?"];
            }
        }];
        
        NSString *sql = [[NSString alloc] initWithFormat:@"INSERT OR REPLACE INTO %@(%@) VALUES (%@);", [model tableName], [columns componentsJoinedByString:@","], [placeholder componentsJoinedByString:@","]];
        BOOL flag = [db executeUpdate:sql withArgumentsInArray:values];
        NSLog(@"%@--%@",[model tableName],flag?@"插入成功":@"插入失败");
        if (!flag) {
            res = NO;
            *rollback = YES;
            return ;
        }
    }];
    return res;
}

/**
 查询表中的数据
 
 @param model 数据模型
 @param sqlSTR 查询条件
 @return 返回结果
 */
+ (NSMutableArray*)queryTableWithModel:(BaseModel*)model SQL:(NSString*)sqlSTR {
    sqlSTR = [NSString stringWithFormat:@"SELECT * FROM %@",model.tableName];
    return [self queryTableWithSQL:sqlSTR];
}

/** 关闭数据库 */ 
+ (void)close
{
    // 单例对象
    FMDBTools* fmdbTools = [self sharedInstance];
    [fmdbTools close];
}


#pragma mark - 私有方法
// 创建表
+ (BOOL)createTableWithSql:(NSString *)sqlSTR
{
    __block BOOL res = YES;
    // 单例对象
    FMDBTools* fmdbTools = [self sharedInstance];
    if (fmdbTools.dbQueue == nil) {
        res = NO;
    }
    
    [fmdbTools.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        if (![db executeUpdate:sqlSTR])
        {
            res = NO;
            *rollback = YES;
            return;
        };
    }];
    return res;
}

/** 查询表中的数据 */
+ (NSMutableArray*)queryTableWithSQL:(NSString*)sqlSTR
{
    // 用于存数据的数组
    NSMutableArray *results = [NSMutableArray array];
    // 单例对象
    FMDBTools* fmdbTools = [self sharedInstance];
    [fmdbTools.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        FMResultSet *resultSet = [db executeQuery:sqlSTR];
        while ([resultSet next]) {
            [results addObject:[resultSet resultDictionary]];
        }
    }];
    // 返回
    return results;
}

// 关闭数据库
- (void)close
{
    if (!self.dbQueue) {
        return;
    }
    [self.dbQueue close];
    self.dbQueue = nil;
}

+ (NSString*)dbPathWithFileName:(NSString*)fileName {
    NSString *documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    
    return [documents stringByAppendingFormat:@"/%@", fileName];
}

@end
