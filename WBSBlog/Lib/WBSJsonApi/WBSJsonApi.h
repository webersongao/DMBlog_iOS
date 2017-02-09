//
//  WBSJsonApi.h
//  WBSJsonApi
//
//  Created by Weberson on 2017/1/26.
//  该API 需要WordPress 的 Json Api-User 插件支持
//  Copyright © 2017年 Weberson. All rights reserved.
//
// 该文件主要包含 【博客用户】 的 注册 删除 修改 搜索 等操作，【博客文章】的 增 删 改 查 参看 WBSBaseCoreApi 类

#import "WBSBaseCoreApi.h"


@interface WBSJsonApi : WBSBaseCoreApi


/**
 *  1、User  需要 Json Api User 插件支持  https://wordpress.org/plugins/json-api-user/
 */
#pragma mark  1️⃣   About User

/// 用户登陆 Login
+ (void)userLoginWithURL:(NSString *)siteUrl username:(NSString *)userName password:(NSString *)password inSSLSecure:(BOOL)inSSLsecure success:(void (^)(NSDictionary *resultDict))success failure:(void (^)(NSError *error))failure;















@end




