//
//  FMDBManger.m
//  WBSBlog
//
//  Created by Weberson on 15/12/8.
//  Copyright (c) 2015年 Weberson. All rights reserved.
//

#import "FMDBManger.h"
#import "UserModel.h"

//存储用户信息
#define kUserInformationTable   @"userInfor"
//搜索历史
#define kSeachHistoryTableName  @"seachHistoryTabe"

@interface FMDBManger ()

@end

@implementation FMDBManger
+ (FMDBManger *)sharedFMDBManger{
    static FMDBManger *single = nil;
    static dispatch_once_t onceToken;//锁
    dispatch_once(&onceToken, ^{//只执行一次
        single = [[self alloc] init];
    });
    return single;
}

- (instancetype)init{
    self = [super init];
    if (self) {
    }
    return self;
}

#pragma mark - 创建数据库
- (void)initDataBase{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    self.dbPath = [documentDirectory stringByAppendingPathComponent:@"DATABase.sqlite"];
    self.DB = [FMDatabase databaseWithPath:self.dbPath];
}









//向表中插入数据
//如果已经存在的话执行 修改数据
//如果没有的话执行 插入操作
- (void)insertUserToUserInformationTableWith:(UserModel *)user{
    if (!self.DB) {
        [self initDataBase];
    }
    if (![self.DB open]) {
        return;
    }
    [self.DB setShouldCacheStatements:YES];
    
    if (![self.DB tableExists:kUserInformationTable]) {
        [self creatUserInforTable];
    }
    
    if ([self userIsExistenceWith:user]) {
        //执行修改操作
        FMDatabaseQueue *queue=[FMDatabaseQueue databaseQueueWithPath:self.dbPath];
        [queue inDatabase:^(FMDatabase *db) {
            NSString *string = [NSString stringWithFormat:@"UPDATE %@ SET nickname=?, headIconVersion=?,headIcon=?, signature=? WHERE uid=?",kUserInformationTable];
            BOOL isSucess = [self.DB executeUpdate:string,user.nickname,[user.headIconVersion stringValue], user.headIcon,user.signature,[user.uid stringValue]];
            if (isSucess) {
                KLog(@"更新成功");
            }else{
                KLog(@"更新失败");
            }
        }];
        
    }else{
        //执行插入操作
        FMDatabaseQueue *queue=[FMDatabaseQueue databaseQueueWithPath:self.dbPath];
        [queue inDatabase:^(FMDatabase *db) {

            //执行插入操作
            NSString *string = [NSString stringWithFormat:@"insert into %@(uid,nickname,headIconVersion,headIcon,signature) values (?,?,?,?,?)",kUserInformationTable];
            BOOL insert=[self.DB executeUpdate:string, [user.uid stringValue],user.nickname,[user.headIconVersion stringValue],user.headIcon,user.signature];
            if (insert) {
                KLog(@"插入成功....");
            }else{
                KLog(@"插入失败.....");
            }
        }];
        [queue close];
    }
}


#pragma mark - 用户信息表的操作
//创建用户表
- (void)creatUserInforTable{
    if (!self.DB) {
        [self initDataBase];
    }
    if (![self.DB open]) {
        return;
    }
    [_DB setShouldCacheStatements:YES];
    if (![_DB tableExists:kUserInformationTable]) {
        NSString *string = [NSString stringWithFormat:@"create table %@(uid TEXT, nickname TEXT ,headIconVersion TEXT ,headIcon TEXT ,signature TEXT)",kUserInformationTable];
        [_DB executeUpdate:string];
    }
}

//判断用户是否存在
- (BOOL)userIsExistenceWith:(UserModel *)user{
    if (!self.DB) {
        [self creatUserInforTable];
        return NO;
    }
    if (![self.DB open]) {
        return NO;
    }
    if (![self.DB tableExists:kUserInformationTable]) {
        return NO;
    }
    NSString *string = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE uid= ?",kUserInformationTable];
    FMResultSet *result=[self.DB executeQuery:string ,[user.uid stringValue]];
    if ([result next]) {
        return YES;
    }else{
        return NO;
    }
}

//根据uid获取用户
- (NSDictionary *)getUserInforWith:(NSString *)uid{
    if (!self.DB) {
        [self initDataBase];
    }
    if (![self.DB open]) {
        return nil;
    }
    if (![self.DB tableExists:kUserInformationTable]) {
        return nil;
    }
    NSString *string = [NSString stringWithFormat:@"select * from %@  where uid=?",kUserInformationTable];
    //定义一个结果集,存放查询的数据
    FMResultSet *result=[_DB executeQuery:string,uid];
    while ([result next]) {
        NSString *uid = [result stringForColumn:@"uid"];
        NSString *nickname = [result stringForColumn:@"nickname"];
        NSString *headIconVersion = [result stringForColumn:@"headIconVersion"];
        NSString *headIcon = [result stringForColumn:@"headIcon"];
        NSString *signature = [result stringForColumn:@"signature"];
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInteger:[uid integerValue]],@"uid", nickname, @"nickname", [NSNumber numberWithInteger:[headIconVersion integerValue]],@"headIconVersion", headIcon,@"headIcon",signature ,@"signature", nil];
        return dic;
    }
    return nil;
}






#pragma mark - 搜索历史的表操作
//创建搜索历史表
- (void)creatSearchHistoryTable{
    if (!self.DB) {
        [self initDataBase];
    }
    if (![self.DB open]) {
        return;
    }
    //为数据库设置缓存,提高查询效率
    [_DB setShouldCacheStatements:YES];
    
    //判断数据库中是否已经存在history表,如果不存在,则创建该表
    if (![_DB tableExists:kSeachHistoryTableName]) {
        NSString *string = [NSString stringWithFormat:@"create table %@(title TEXT)",kSeachHistoryTableName];
        [_DB executeUpdate:string];
    }
}

//向搜索历史表中插入数据
- (void)insertDataToSearchHistoryTableWith:(NSString *)title{
    if (!self.DB) {
        [self initDataBase];
    }
    if (![self.DB open]) {
        return;
    }
    //为数据库设置缓存,提高查询效率
    [self.DB setShouldCacheStatements:YES];
    
    if (![self.DB tableExists:kSeachHistoryTableName]) {
        [self creatSearchHistoryTable];
    }
    
    //插入之前先把原有的给我删除了
    NSString *string = [NSString stringWithFormat:@"DELETE FROM %@ WHERE title = ?",kSeachHistoryTableName];
    [self.DB executeUpdate:string,title];
    
    //多线程的
    FMDatabaseQueue *queue=[FMDatabaseQueue databaseQueueWithPath:self.dbPath];
    [queue inDatabase:^(FMDatabase *db) {
        //执行插入操作
        NSString *string = [NSString stringWithFormat:@"insert into %@ (title) values (?)",kSeachHistoryTableName];
        BOOL insert=[self.DB executeUpdate:string,title];
        if (insert) {
            KLog(@"插入成功");
        }else{
            KLog(@"插入失败");
        }
    }];
    [queue close];
}

//从搜索历史表中获取数据
- (NSMutableArray *)getDataForSearchHistory{
    if (!self.DB) {
        [self initDataBase];
    }
    if (![self.DB open]) {
        return nil;
    }
    if (![self.DB tableExists:kSeachHistoryTableName]) {
        return nil;
    }
    
    NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:5];
    //定义一个结果集,存放查询的数据
    NSString *string = [NSString stringWithFormat:@"select * from %@",kSeachHistoryTableName];
    FMResultSet *result=[_DB executeQuery:string];
    //判断结果集中是否有数据,如果有则取出数据
    while ([result next]) {
        NSString *str = [result stringForColumn:@"title"];
        //将查询到的数据放入数组中
        [arr addObject:str];
    }
    return arr;
}

//删除搜索历史表中某一条数据
- (void)deleteSearchHistory:(NSString *)sting{
    if (!self.DB) {
        [self initDataBase];
    }
    if (![self.DB open]) {
        return;
    }
    if (![self.DB tableExists:kSeachHistoryTableName]) {
        return;
    }
    //删除的核心语句2:多线程中删除操作
    FMDatabaseQueue *queue=[FMDatabaseQueue databaseQueueWithPath:self.dbPath];
    [queue inDatabase:^(FMDatabase *db) {
        //删除数据
        NSString *string = [NSString stringWithFormat:@"delete from %@ where title = ?",kSeachHistoryTableName];
        BOOL delete = [self.DB executeUpdate:string, sting];
        if (delete) {
            KLog(@"删除成功");
        }else{
            KLog(@"删除失败");
        }
    }];
    [queue close];
    [self.DB close];
}

@end
