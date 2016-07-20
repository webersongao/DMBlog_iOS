//
//  WBSConfig.m
//  WBSBlog
//
//  Created by Weberson on 16/7/20.
//  Copyright © 2016年 Weberson. All rights reserved.
//

#import "WBSConfig.h"

@implementation WBSConfig

/**
 *  获取是否夜间模式
 *
 *  @return 是否夜间模式
 */
+ (BOOL)getMode
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    return [[userDefaults objectForKey:@"mode"] boolValue];
}

/**
 *  获取MetaWeblog API的授权信息
 *
 *  @return ApiInfo
 */
+(WBSApiInfo *)getAuthoizedApiInfo
{
    //获取相关存储信息
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL isJSONAPIEnable = [[userDefaults objectForKey:@"isJSONAPIEnable"] boolValue];
    NSString *baseURL = [userDefaults objectForKey:@"baseURL"];
    NSString *username = [userDefaults objectForKey:@"mw_username"];
    NSString *password = [userDefaults objectForKey:@"mw_password"];
    NSString *cookie = [userDefaults objectForKey:@"generate_auth_cookie"];
    //初始化ApiInfo
    WBSApiInfo *apiInfo = nil;
    if (isJSONAPIEnable) {
        apiInfo = [[WBSApiInfo alloc]initWithBaseURL:baseURL andGenerateAuthCookie:cookie];
    }else{
        apiInfo = [[WBSApiInfo alloc] initWithXmlrpc:baseURL username:username password:password];
    }
    //结果处理
    return apiInfo;
}

/**
 *  是否启用JSON API（注意：如果启用了，需要服务端支持，https://github.com/terwer/TGBlogJsonApi）
 *
 *  @return JSON API开启状态
 */
+(BOOL)isJSONAPIEnable {
    //获取相关存储信息
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL isJSONAPIEnable = [[userDefaults objectForKey:@"isJSONAPIEnable"] boolValue];
    return isJSONAPIEnable;
}

/**
 *  是否显示页面（默认只显示文章）
 *
 *  @return 是否显示页面
 */
+(BOOL)isShowPage{
    //获取相关存储信息
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL isShowPage = [[userDefaults objectForKey:@"isShowPage"] boolValue];
    return isShowPage;
}

/**
 *  是否针对Wordpress优化
 *
 *  @return 是否针对Wordpress优化
 */
+(BOOL)isWordpressOptimization{
    //获取相关存储信息
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL isWordpressOptimization = [[userDefaults objectForKey:@"isWordpressOptimization"] boolValue];
    return isWordpressOptimization;

}

@end
