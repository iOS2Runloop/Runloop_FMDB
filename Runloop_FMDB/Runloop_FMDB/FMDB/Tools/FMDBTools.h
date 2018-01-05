//
//  FMDBTools.h
//  Runloop_FMDB
//
//  Created by  ZhuHong on 2018/1/3.
//  Copyright © 2018年 CoderHG. All rights reserved.
//

#import "SingleObject.h"
@class BaseModel;

@interface FMDBTools : SingleObject


/**
 打开数据库

 @param fileName 数据库的名字
 @return 返回打开回馈 YES: 成功   NO: 失败
 */
+ (BOOL)openDBWithFileName:(NSString*)fileName;


/**
 创建表

 @param model 通过model中的数据创建表
 @return 返回创建结果 YES: 成功   NO: 失败
 */
+ (BOOL)createWithModel:(BaseModel*)model;

/**
 直接插入一条消息

 @param model 插入的对象
 @return 插入结果
 */
+ (BOOL)insertDataModel:(BaseModel*)model;

/**
 查询表中的数据

 @param model 数据模型
 @param sqlSTR 查询条件
 @return 返回结果
 */
+ (NSMutableArray*)queryTableWithModel:(BaseModel*)model SQL:(NSString*)sqlSTR;


/**
 查询表中的数据

 @param sqlSTR 查询条件
 @return 返回结果
 */
//+ (NSMutableArray*)queryTableWithSQL:(NSString*)sqlSTR;

/** 关闭数据库 */
+ (void)close;

@end
