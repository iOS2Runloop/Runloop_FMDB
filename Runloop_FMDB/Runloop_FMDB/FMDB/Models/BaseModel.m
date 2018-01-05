//
//  BaseModel.m
//  Runloop_FMDB
//
//  Created by  ZhuHong on 2018/1/4.
//  Copyright © 2018年 CoderHG. All rights reserved.
//

#import "BaseModel.h"
#import <objc/runtime.h>

@interface BaseModel ()

@property (nonatomic, strong) NSMutableDictionary* dictMForProperty;

@end

@implementation BaseModel

/** 返回一个对应的表名 */
- (NSString*)tableName {
    NSAssert(nil, @"请在子类中重写这个方法!");
    return nil;
}

/**
 对象转字典
 */
- (NSDictionary*)dataForProperty {
    if (!_dictMForProperty) {
        _dictMForProperty = [NSMutableDictionary dictionary];
    }
    [_dictMForProperty removeAllObjects];
    
    // 一般开发中不会这么简单的, 往往都是model套model
    {
        // 获取所有的属性, 然后判断其类型
        unsigned int count = 0;
        Ivar* ivars = class_copyIvarList(object_getClass(self), &count);
        
        for (int i=0; i<count; i++) {
            Ivar ivar = ivars[i];
            // const char * type = ivar_getTypeEncoding(ivar);
            const char * name = ivar_getName(ivar);
            
            NSString* nameStr = [NSString stringWithUTF8String:name];
            
            // 去掉第一个_
            nameStr = [nameStr stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@""];
            if (![nameStr isEqualToString:@"dictMForProperty"] && ![nameStr isEqualToString:@"dataForProperty"]) {
                // 尽量不要使用setObject: forKey: 可能[self valueForKey:nameStr] 为nil
                [_dictMForProperty setValue:[self valueForKey:nameStr] forKey:nameStr];
            }
        }
        
        free(ivars);
    }
    
    return _dictMForProperty;
};

@end
