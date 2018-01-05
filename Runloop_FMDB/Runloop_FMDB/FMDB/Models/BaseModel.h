//
//  BaseModel.h
//  Runloop_FMDB
//
//  Created by  ZhuHong on 2018/1/4.
//  Copyright © 2018年 CoderHG. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 创建字符串的宏定义 */
#define HGStr(...) [NSString stringWithFormat:__VA_ARGS__]

/** 创建表 */ 
#define HGCreateTable(TableName, TableColumn) HGStr(@"CREATE TABLE IF NOT EXISTS %@ (%@)",TableName,TableColumn)

@interface BaseModel : NSObject

/** 返回一个对应的表名 */
- (NSString*)tableName;


/**
 对象转字典
 */
- (NSMutableDictionary*)dataForProperty;

@end
