//
//  WBSUserModel.h
//  WBSJsonApi
//
//  Created by WebersonGao on 15/12/3.
//  Copyright (c) 2015年 WebersonGao. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  当前登录的用户
 
 [0]	(null)	@"id" : (long)1
 [1]	(null)	@"displayname" : @"卫博生"
 [2]	(null)	@"description" : @"个人说明卫博生-惜丝丝缘分，爱点滴生活！"
 [3]	(null)	@"nicename" : @"520weberson"
 [4]	(null)	@"lastname" : @"姓氏gao"
 [5]	(null)	@"registered" : @"2011-05-13 04:16:08"
 [6]	(null)	@"url" : @"http://"
 [7]	(null)	@"firstname" : @"名字卫博生"
 [8]	(字典)	@"capabilities" : 1 key/value pair
 [9]	(null)	@"avatar" : (no summary)
 [10](null)	@"username" : @"520?3$%2weberson"
 [11](null)	@"nickname" : @"昵称卫博生"
 [12](null)	@"email" : @"weberson@163.com"
 */

@interface WBSUserModel : NSObject

@property (nonatomic, strong)   NSNumber *uid;  //!< id
@property (nonatomic, copy)     NSString *avatar;//!< 头像地址
@property (nonatomic, copy)     NSString *username;//!< 登录账号
@property (nonatomic, copy)     NSString *displayname;//!< 可显示的昵称
@property (nonatomic, copy)     NSString *nickname;//!< 昵称
@property (nonatomic, copy)     NSString *firstname;//!< 名称
@property (nonatomic, copy)     NSString *lastname;//!< 姓氏
@property (nonatomic, copy)     NSString *registered;//!< 注册时间  // 2016-03-13 04:16:08
@property (nonatomic, copy)     NSString *email;//!< 邮箱
@property (nonatomic, copy)     NSString *nicename;//!< 没有特殊符号的账号
@property (nonatomic, copy)     NSString *url;//!< 链接地址，不知道啥东西
@property (nonatomic, copy)     NSString *descriptions;//!< 个性签名
@property (nonatomic, assign)     NSInteger isAdmin;//!< 是否是管理员



+ (WBSUserModel *)WBSUserModelWithDic:(NSDictionary*)dict;

@end
