//
//  FMDB_Tool.h
//  DDB_project
//
//  Created by 马红杰 on 2017/1/22.
//  Copyright © 2017年 GOLDDRAGON. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PassWordInfo;

@interface FMDB_Tool : NSObject

///插入单条数据
+ (BOOL)insertSingleDataToDataBaseWithInfo:(PassWordInfo *)info;

///查询单类型所有数据
+ (NSArray <PassWordInfo *> *)querySingleTypeAllDataFromDataBaseWithType:(NSString *)typeId;

///查询所有类型数据
+ (NSArray <PassWordInfo *> *)queryAllDataFromDataBase;

///删除掉某条数据
+ (BOOL)deleteSingleDataWithPassWordInfo:(PassWordInfo *)info;

///更新某条数据
+ (BOOL)updateSingleDataWithPassWordInfo:(PassWordInfo *)info;

///查询单类型总数量
+ (NSInteger)querySingleTypeNumFromDataBaseWithType:(NSString *)typeId;

@end
