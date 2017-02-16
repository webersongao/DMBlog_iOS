//
//  WBSNetRequest.h
//  WBSBlog
//
//  Created by Weberson on 2017/1/22.
//  Copyright © 2017年 Weberson. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    JSONAPIControllerTypeCore = 0,
    JSONAPIControllerTypePosts,
    JSONAPIControllerTypeRespond,
    JSONAPIControllerTypeWidgets,
    JSONAPIControllerTypeUser,
} JSONAPIControllerType;

typedef enum : NSUInteger {
    JSONAPIPostTypeDefault = 0,  // 默认是 post 类型
    JSONAPIPostTypePost,
    JSONAPIPostTypeTemp,
} JSONAPIPostType;

@interface WBSNetRequest : NSObject

@property (nonatomic, strong) NSString *jsonSiteUrl;  //!< JSON API 站点地址
@property (nonatomic, strong) NSString *xmlSiteUrl;   //!< XMLRPC 站点地址

+ (instancetype)sharedRequest;

/// 获取JSONAPI 插件版本信息
-(void)GetJsonApiVersionInfoWithControllerType:(JSONAPIControllerType)controllerType SuccessBlock:(void (^)(id versioInfo))successBlock failure:(void (^)(NSError *error))failureBlock;

/// 用户登录
- (void)userLoginWithSiteBaseUrlStr:(NSString *)siteBaseUrlStr successBlock:(void (^) (BOOL isLoginSuccess,NSString * errorMsg)) LoginSuccessblock userNameStr:(NSString *)userName PassWordStr:(NSString *)PassWord  isJsonAPi:(BOOL)isJsonApi;

/// 获取最近文章 Recent_Posts
- (void)getRecentPosts_WithCount:(NSInteger)count page:(NSInteger)page postType:(JSONAPIPostType)postType success:(void (^)(NSArray *postsArray, NSInteger postsCount))successBlock failure:(void (^)(NSError *error))failureBlock;

/// 获取文章 get_posts
- (void)getPosts_WithCount:(NSInteger)count page:(NSInteger)page postType:(JSONAPIPostType)postType IgnoreStickyPosts:(BOOL)isIgnoreStickyPosts success:(void (^)(NSArray *postsArray, NSInteger postsCount ,BOOL isIgnoreStickyPosts))successBlock failure:(void (^)(NSError *error))failureBlock;

/// 获取指定文章 get_post
- (void)getPost_WithPostId:(NSInteger)postId postSlug:(NSString *)postSlug postType:(JSONAPIPostType)postType success:(void (^)(NSArray *postsArray, NSInteger postsCount))successBlock failure:(void (^)(NSError *error))failureBlock;



@end













