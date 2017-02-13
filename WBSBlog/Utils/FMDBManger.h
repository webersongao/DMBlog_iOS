//
//  FMDBManger.h
//  WBSBlog
//
//  Created by Weberson on 15/12/8.
//  Copyright (c) 2015年 Weberson. All rights reserved.
//

/**
 *
 */
#import <Foundation/Foundation.h>
#import "FMDB.h"
#import "WBSUserModel.h"

@interface FMDBManger : NSObject

@property (nonatomic,strong) FMDatabase *DB;//数据库
@property (nonatomic, copy) NSString *dbPath;//数据库的路径

+ (FMDBManger *)sharedFMDBManger;

#pragma mark - 用户表操作
//向用户的表中插入数据
- (void)insertUserToUserInformationTableWith:(WBSUserModel *)user;

// 根据uid 获取用户
- (WBSUserModel *)getUserModelInfoWithUid:(NSString *)uid;


#pragma mark - 搜索历史表操作
//创建搜索历史表
- (void)creatSearchHistoryTable;

//向表中插入数据
- (void)insertDataToSearchHistoryTableWith:(NSString *)title;

//从表中获取数据
- (NSMutableArray *)getDataForSearchHistory;

//删除表中的数据
- (void)deleteSearchHistory:(NSString *)string;
@end
