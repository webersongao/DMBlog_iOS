//
//  WBSBaseCoreApi.h
//  WBSBlog
//
//  Created by Weberson on 2017/2/9.
//  该API 需要WordPress 的 Json Api  插件支持
//  Copyright © 2017年 Weberson. All rights reserved.
//
// 该文件
// 该文件为 JSON Api 的 Core Widgets Widgets Widgets 四个Controllers的基本api 实现代码
// 关于 JsonApi 的 Controllers的说明参看 https://wordpress.org/plugins/json-api/other_notes/#1.2.-Controllers

#import <Foundation/Foundation.h>
#import "WBSNetworking.h"
#import "WBSJsonMacro.h"

@interface WBSBaseCoreApi : NSObject


/********************* 公共属性 *************************/
/// posts
@property (nonatomic) NSInteger postsCount;
@property (nonatomic) NSArray *postsArray;
@property (nonatomic) NSInteger pagesCount;



/********************* 公共方法 *************************/

// 获取JSON API 插件的功能版本信息
-(void)GetJsonApiVersionInfo;

/**
 *  1、Post  需要JsonApi 插件 https://wordpress.org/plugins/json-api/
 */
#pragma mark  1️⃣ Post
/// 获取文章 getPosts
- (void)getPostsWithSiteUrlStr:(NSString *)siteUrlString queryString:(NSString *)queryString success:(void (^)(NSArray *postsArray, NSInteger postsCount))successBlock failure:(void (^)(NSError *error))failureBlock;


/**
 *  2、 Setting  需要JsonApi 插件 https://wordpress.org/plugins/json-api/
 */
#pragma mark  2️⃣ Setting

@end
