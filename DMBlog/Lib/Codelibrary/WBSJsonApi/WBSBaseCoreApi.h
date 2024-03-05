//
//  WBSBaseCoreApi.h
//  DMBlog
//
//  Created by WebersonGao on 2017/2/9.
//  Copyright © 2017年 WebersonGao. All rights reserved.
//
// 该文件
// 该文件为 JSON Api 的 Core Widgets Widgets Widgets 四个Controllers的基本api 实现代码
// 关于 JsonApi 的 Controllers的说明参看 https://wordpress.org/plugins/json-api/other_notes/#1.2.-Controllers

#import <Foundation/Foundation.h>
#import "WBSNetworking.h"
#import "WBSJsonMacro.h"
#import "WBSErrorModel.h"



@interface WBSBaseCoreApi : NSObject

/********************* 公共方法 *************************/

/// get info  Returns information about JSON API.
// 版本信息 info -> Returns information about JSON API or detailed information about a specific controller
// controllerStr
+ (void)get_JsonApi_Info_WithSiteURLStr:(NSString *)siteURLStr controllerStr:(NSString *)controllerStr success:(void (^)(id versionInfoModel))successBlock failure:(void (^)(NSError *error))failureBlock;

/**
 *  1、Core  需要JsonApi 插件 https://wordpress.org/plugins/json-api/    并在 Json Api 设置中开启 Core 模块
 */
#pragma mark  1️⃣ Core

/// get_recent_posts    获取文章
/// get_recent_posts -> home page（eg:json=1） or any page by setting json=get_recent_posts
+ (void)get_recent_posts_WithSiteUrlStr:(NSString *)siteUrlString count:(NSInteger)count page:(NSInteger)page postType:(NSString *)postType success:(void (^)(NSArray *postsModelArray, NSInteger postsCount))successBlock failure:(void (^)(NSError *error))failureBlock;

/// get_posts   获取文章
+ (void)get_Posts_WithSiteUrlStr:(NSString *)siteUrlString count:(NSInteger)count page:(NSInteger)page postType:(NSString *)postType IgnoreStickyPosts:(BOOL)isIgnoreStickyPosts success:(void (^)(NSArray *postsModelArray, NSInteger postsCount ,BOOL isIgnoreStickyPosts))successBlock failure:(void (^)(NSError *error))failureBlock;

/// get_post    获取指定文章
+ (void)get_post_WithSiteUrlStr:(NSString *)siteUrlString postId:(NSInteger)postId postSlug:(NSString *)postSlug postType:(NSString *)postType success:(void (^)(NSArray *postsArray, NSInteger postsCount))successBlock failure:(void (^)(NSError *error))failureBlock;

/// get_page
+ (void)get_page_WithSiteUrlStr:(NSString *)siteUrlString queryString:(NSString *)queryString success:(void (^)(NSArray *postsArray, NSInteger postsCount))successBlock failure:(void (^)(NSError *error))failureBlock;

/// get_date_posts
+ (void)get_date_posts_WithSiteUrlStr:(NSString *)siteUrlString queryString:(NSString *)queryString success:(void (^)(NSArray *postsArray, NSInteger postsCount))successBlock failure:(void (^)(NSError *error))failureBlock;

/// get_category_posts
+ (void)get_category_posts_WithSiteUrlStr:(NSString *)siteUrlString queryString:(NSString *)queryString success:(void (^)(NSArray *postsArray, NSInteger postsCount))successBlock failure:(void (^)(NSError *error))failureBlock;

/// get_tag_posts
+ (void)get_tag_posts_WithSiteUrlStr:(NSString *)siteUrlString queryString:(NSString *)queryString success:(void (^)(NSArray *postsArray, NSInteger postsCount))successBlock failure:(void (^)(NSError *error))failureBlock;

/// get_author_posts
+ (void)get_author_posts_WithSiteUrlStr:(NSString *)siteUrlString queryString:(NSString *)queryString success:(void (^)(NSArray *postsArray, NSInteger postsCount))successBlock failure:(void (^)(NSError *error))failureBlock;

/// get_search_results
+ (void)get_search_results_WithSiteUrlStr:(NSString *)siteUrlString queryString:(NSString *)queryString success:(void (^)(NSArray *postsArray, NSInteger postsCount))successBlock failure:(void (^)(NSError *error))failureBlock;

/// get_date_index
+ (void)get_date_index_WithSiteUrlStr:(NSString *)siteUrlString queryString:(NSString *)queryString success:(void (^)(NSArray *postsArray, NSInteger postsCount))successBlock failure:(void (^)(NSError *error))failureBlock;

/// get_category_index
+ (void)get_category_index_WithSiteUrlStr:(NSString *)siteUrlString queryString:(NSString *)queryString success:(void (^)(NSArray *postsArray, NSInteger postsCount))successBlock failure:(void (^)(NSError *error))failureBlock;

/// get_tag_index
+ (void)get_tag_index_WithSiteUrlStr:(NSString *)siteUrlString success:(void (^)(NSArray *tagsArray, NSInteger tagsCount))successBlock failure:(void (^)(NSError *error))failureBlock;

/// get_author_index
+ (void)get_author_index_WithSiteUrlStr:(NSString *)siteUrlString queryString:(NSString *)queryString success:(void (^)(NSArray *postsArray, NSInteger postsCount))successBlock failure:(void (^)(NSError *error))failureBlock;

/// get_page_index
+ (void)get_page_index_WithSiteUrlStr:(NSString *)siteUrlString queryString:(NSString *)queryString success:(void (^)(NSArray *postsArray, NSInteger postsCount))successBlock failure:(void (^)(NSError *error))failureBlock;

/// get_nonce
+ (void)get_nonce_WithSiteUrlStr:(NSString *)siteUrlString queryString:(NSString *)queryString success:(void (^)(NSArray *postsArray, NSInteger postsCount))successBlock failure:(void (^)(NSError *error))failureBlock;






/**
 *  2、 Posts  需要JsonApi 插件 https://wordpress.org/plugins/json-api/  并在 Json Api 设置中开启 Posts 模块
 */
#pragma mark  2️⃣ Posts



/// create_post
+ (void)create_post_WithSiteUrlStr:(NSString *)siteUrlString queryString:(NSString *)queryString success:(void (^)(NSArray *postsArray, NSInteger postsCount))successBlock failure:(void (^)(NSError *error))failureBlock;

/// update_post
+ (void)update_post_WithSiteUrlStr:(NSString *)siteUrlString queryString:(NSString *)queryString success:(void (^)(NSArray *postsArray, NSInteger postsCount))successBlock failure:(void (^)(NSError *error))failureBlock;

/// delete_post
+ (void)delete_post_WithSiteUrlStr:(NSString *)siteUrlString queryString:(NSString *)queryString success:(void (^)(NSArray *postsArray, NSInteger postsCount))successBlock failure:(void (^)(NSError *error))failureBlock;





/**
 *  3、 Respond  需要JsonApi 插件 https://wordpress.org/plugins/json-api/    并在 Json Api 设置中开启 Respond 模块
 */
#pragma mark  3️⃣ Respond


/// submit_comment
+ (void)submit_comment_WithSiteUrlStr:(NSString *)siteUrlString queryString:(NSString *)queryString success:(void (^)(NSArray *postsArray, NSInteger postsCount))successBlock failure:(void (^)(NSError *error))failureBlock;





/**
 *  4、 Widgets  需要JsonApi 插件 https://wordpress.org/plugins/json-api/    并在 Json Api 设置中开启 Widgets 模块
 */
#pragma mark  4️⃣ Widgets


/// get_sidebar
+ (void)get_sidebar_WithSiteUrlStr:(NSString *)siteUrlString queryString:(NSString *)queryString success:(void (^)(NSArray *postsArray, NSInteger postsCount))successBlock failure:(void (^)(NSError *error))failureBlock;






@end










