//
//  WBSPostJsonApi.h
//  WBSJsonApi
//
//  Created by Weberson on 2017/1/26.
//  该API 需要 Json Api 插件支持 https://wordpress.org/plugins/json-api/ 
//  Copyright © 2017年 Weberson. All rights reserved.
//
// 该文件主要包含 【博客文章】 的 增 删 改 查 以及 用户评论 等操作

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface WBSPostJsonApi : NSObject

@property (nonatomic) NSInteger postsCount;
@property (nonatomic) NSArray *postsArray;
@property (nonatomic) NSInteger pagesCount;


/**
 *  1、 Post  需要JsonApi 插件 https://wordpress.org/plugins/json-api/
 */
#pragma mark  1️⃣ Post
/// 获取文章 getPosts
- (void)getPostsWithURL:(NSString*)urlString success:(void (^)(NSArray *postsArray, NSInteger postsCount))successBlock failure:(void (^)(NSError *error))failureBlock;




/**
 *  2、 Setting  需要JsonApi 插件 https://wordpress.org/plugins/json-api/
 */
#pragma mark  2️⃣ Setting





@end





