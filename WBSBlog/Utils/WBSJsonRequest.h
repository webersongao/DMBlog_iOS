//
//  WBSJsonRequest.h
//  WBSBlog
//
//  Created by Weberson on 2017/1/22.
//  Copyright © 2017年 Weberson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WBSJsonRequest : NSObject

/// 获取JSONAPI 插件版本信息
+(void)GetJsonApiVersionInfoWithSuccessBlock:(void (^)(id versioInfo))successBlock failure:(void (^)(NSError *error))failureBlock;

/// 用户登录
+ (void)userLogin:(void (^) (BOOL isLoginSuccess,NSString * errorMsg)) LoginSuccessblock userNameStr:(NSString *)userName PassWordStr:(NSString *)PassWord  isJsonAPi:(BOOL)isJsonApi;

/// 获取最近文章 Recent_Posts
+ (void)getRecentPostsWithQueryString:(NSString *)queryString success:(void (^)(NSArray *postsModelArray, NSInteger postsCount))successBlock failure:(void (^)(NSError *error))failureBlock;

/// 获取文章 get_posts
+ (void)getPostsWithQueryString:(NSString *)queryString success:(void (^)(NSArray *postsModelArray, NSInteger postsCount ,BOOL isIgnoreStickyPosts))successBlock failure:(void (^)(NSError *error))failureBlock;



@end
