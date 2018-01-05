//
//  HGModel.h
//  Runloop_FMDB
//
//  Created by  ZhuHong on 2018/1/4.
//  Copyright © 2018年 CoderHG. All rights reserved.
//

#import "BaseModel.h"

@interface HGModel : BaseModel

/** 姓名 */
@property (nonatomic, copy) NSString* name;
/** 住址 */
@property (nonatomic, copy) NSString* address;

@end
