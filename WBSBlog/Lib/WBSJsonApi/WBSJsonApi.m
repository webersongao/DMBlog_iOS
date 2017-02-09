//
//  WBSJsonApi.h
//  WBSJsonApi
//
//  Created by Weberson on 2017/1/26.
//  该API 需要WordPress安装JsonApi 插件 涉及到”用户信息“以及“用户登陆” 还需要Json Api-User 插件支持
//  Copyright © 2017年 Weberson. All rights reserved.
//
// 该文件主要包含 【博客用户】 的 注册 删除 修改 搜索 等操作，【博客文章】的 增 删 改 查 参看 WBSPostJsonApi 类

#import "WBSJsonApi.h"

@implementation WBSJsonApi


/**
 *  User
 */
#pragma mark  About User

/// 用户登陆 Login
+ (void)userLoginWithURL:(NSString *)siteUrl username:(NSString *)userName password:(NSString *)password insecure:(BOOL)insecure success:(void (^)(NSDictionary *resultDict))success failure:(void (^)(NSError *error))failure{
    
    NSString *requestURL = [NSString stringWithFormat:@"http://%@/api/user/generate_auth_cookie/?username=%@&password=%@%@", siteUrl, userName, password,insecure?@"":@"&insecure=cool"];
    
    //获取作者数据
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:requestURL parameters:nil
         success:^(AFHTTPRequestOperation *operation, NSDictionary *result) {
             
             NSString *status = [result objectForKey:@"status"];
             
             if ([status isEqualToString:@"ok"]) {
                 
                 success(result);
                 
             } else {
                 NSDictionary *ErrorDict= [NSDictionary dictionaryWithObject:@"WBSUserJsonApi result block error" forKey:@"errorStr"];
                 success(ErrorDict);
                 
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             
             failure(error);
         }];
    
}

@end
