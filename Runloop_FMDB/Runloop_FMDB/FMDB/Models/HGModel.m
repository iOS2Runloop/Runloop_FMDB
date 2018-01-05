//
//  HGModel.m
//  Runloop_FMDB
//
//  Created by  ZhuHong on 2018/1/4.
//  Copyright © 2018年 CoderHG. All rights reserved.
//

#import "HGModel.h"

/** 模型对应的表名 */
static NSString* const kHGTableName = @"HGTableName";

@interface HGModel ()

@end

@implementation HGModel

/** 返回一个对应的表名 */
- (NSString*)tableName {
    return kHGTableName;
}




// 一般不会这么搞的, 一般都是使用 runtime直接在基类实现 使用runtime的话, 可以很方便的判断出各自的数据类型
- (NSString *)description {
    return @"name TEXT, address TEXT";
}

@end
