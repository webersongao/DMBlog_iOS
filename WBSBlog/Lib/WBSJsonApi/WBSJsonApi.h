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


/// 版本 info
-(void)GetUserJsonApiVersionInfoWithSiteURLStr:(NSString *)siteURLStr success:(void (^)(id versioInfo))successBlock failure:(void (^)(NSError *error))failureBlock;

/// 框架 info
-(void)Get_constructInfo_WithSiteURLStr:(NSString *)siteURLStr success:(void (^)(id versioInfo))successBlock failure:(void (^)(NSError *error))failureBlock;



/**
 *  1、User  需要 Json Api User 插件支持  https://wordpress.org/plugins/json-api-user/ 并在 Json Api 设置中开启 User 模块
 */
#pragma mark  1️⃣   About User

/// 用户登陆 Login  generate_auth_cookie
+ (void)userLoginWithSiteUrlStr:(NSString *)siteUrlString queryString:(NSString *)QueryString inSSLSecure:(BOOL)inSSLSecure success:(void (^)(NSDictionary *resultDict))success failure:(void (^)(NSError *error))failure;


/// register
- (void)register_WithSiteUrlStr:(NSString *)siteUrlString queryString:(NSString *)queryString success:(void (^)(NSArray *postsArray, NSInteger postsCount))successBlock failure:(void (^)(NSError *error))failureBlock;

/// get_avatar
- (void)get_avatar_WithSiteUrlStr:(NSString *)siteUrlString queryString:(NSString *)queryString success:(void (^)(NSArray *postsArray, NSInteger postsCount))successBlock failure:(void (^)(NSError *error))failureBlock;

/// retrieve_password
- (void)retrieve_password_WithSiteUrlStr:(NSString *)siteUrlString queryString:(NSString *)queryString success:(void (^)(NSArray *postsArray, NSInteger postsCount))successBlock failure:(void (^)(NSError *error))failureBlock;

/// validate_auth_cookie
- (void)validate_auth_cookie_WithSiteUrlStr:(NSString *)siteUrlString queryString:(NSString *)queryString success:(void (^)(NSArray *postsArray, NSInteger postsCount))successBlock failure:(void (^)(NSError *error))failureBlock;

/// get_currentuserinfo
- (void)get_currentuserinfo_WithSiteUrlStr:(NSString *)siteUrlString queryString:(NSString *)queryString success:(void (^)(NSArray *postsArray, NSInteger postsCount))successBlock failure:(void (^)(NSError *error))failureBlock;

/// get_user_meta
- (void)get_user_meta_WithSiteUrlStr:(NSString *)siteUrlString queryString:(NSString *)queryString success:(void (^)(NSArray *postsArray, NSInteger postsCount))successBlock failure:(void (^)(NSError *error))failureBlock;

/// update_user_meta
- (void)update_user_meta_WithSiteUrlStr:(NSString *)siteUrlString queryString:(NSString *)queryString success:(void (^)(NSArray *postsArray, NSInteger postsCount))successBlock failure:(void (^)(NSError *error))failureBlock;

/// delete_user_meta
- (void)delete_user_meta_WithSiteUrlStr:(NSString *)siteUrlString queryString:(NSString *)queryString success:(void (^)(NSArray *postsArray, NSInteger postsCount))successBlock failure:(void (^)(NSError *error))failureBlock;

/// update_user_meta_vars
- (void)update_user_meta_vars_WithSiteUrlStr:(NSString *)siteUrlString queryString:(NSString *)queryString success:(void (^)(NSArray *postsArray, NSInteger postsCount))successBlock failure:(void (^)(NSError *error))failureBlock;

/// xprofile
- (void)get_xprofile_WithSiteUrlStr:(NSString *)siteUrlString queryString:(NSString *)queryString success:(void (^)(NSArray *postsArray, NSInteger postsCount))successBlock failure:(void (^)(NSError *error))failureBlock;

/// xprofile_update
- (void)update_xprofile_WithSiteUrlStr:(NSString *)siteUrlString queryString:(NSString *)queryString success:(void (^)(NSArray *postsArray, NSInteger postsCount))successBlock failure:(void (^)(NSError *error))failureBlock;

/// fb_connect
- (void)fb_connect_WithSiteUrlStr:(NSString *)siteUrlString queryString:(NSString *)queryString success:(void (^)(NSArray *postsArray, NSInteger postsCount))successBlock failure:(void (^)(NSError *error))failureBlock;

/// post_comment
- (void)post_comment_WithSiteUrlStr:(NSString *)siteUrlString queryString:(NSString *)queryString success:(void (^)(NSArray *postsArray, NSInteger postsCount))successBlock failure:(void (^)(NSError *error))failureBlock;





@end




