//
//  WBSJsonApi.h
//  WBSJsonApi
//
//  Created by Weberson on 2017/1/26.
//  该API 需要WordPress安装JsonApi 插件 涉及到”用户信息“以及“用户登陆” 还需要Json Api-User 插件支持
//  Copyright © 2017年 Weberson. All rights reserved.
//
// 该文件主要包含 【博客用户】 的 注册 删除 修改 搜索 等操作，【博客文章】的 增 删 改 查 参看 WBSPostJsonApi 类

#import "WBSPostJsonApi.h"

@interface WBSJsonApi : WBSPostJsonApi

//  1、User  需要 JsonApi User 插件支持  https://wordpress.org/plugins/json-api-user/
#pragma mark  About User

/// 用户登陆 Login
+ (void)userLoginWithURL:(NSString *)siteUrl username:(NSString *)userName password:(NSString *)password insecure:(BOOL)insecure success:(void (^)(NSDictionary *resultDict))success failure:(void (^)(NSError *error))failure;















//  2、Post / Setting  需要JsonApi 插件支持  https://wordpress.org/plugins/json-api/
// 具体代码实现 参看 WBSPostJsonApi.h 和 WBSPostJsonApi.m


@end




