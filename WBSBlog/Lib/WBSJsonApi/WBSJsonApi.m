//
//  WBSJsonApi.h
//  WBSJsonApi
//
//  Created by Weberson on 2017/1/26.
//  该API 需要WordPress 的Json Api User 插件支持
//  Copyright © 2017年 Weberson. All rights reserved.
//
// 该文件主要包含 【博客用户】 的 注册 删除 修改 搜索 等操作，【博客文章】的 增 删 改 查 参看 WBSBaseCoreApi 类

#import "WBSJsonApi.h"

@implementation WBSJsonApi


/**
 *  User
 */
#pragma mark  About User

/// 用户登陆 Login
+ (void)userLoginWithSiteUrlStr:(NSString *)siteUrlString queryString:(NSString *)QueryString inSSLSecure:(BOOL)inSSLSecure success:(void (^)(NSDictionary *resultDict))success failure:(void (^)(NSError *error))failure{
    
    NSString *requestURL = [NSString stringWithFormat:@"%@/%@/%@/?%@%@",siteUrlString,KAPI_base_URL,KUser_Generate_auth_cookie,QueryString,inSSLSecure?@"":@"&insecure=cool"];
    
    [WBSNetworking GETRequest:requestURL parameters:nil success:^(id responseObject) {
        // 成功
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            
            NSString *status = [responseObject objectForKey:@"status"];
            
            if (![status isEqualToString:@"ok"]) {
                // login fail
                responseObject = [NSDictionary dictionaryWithObject:@"WBSUserJsonApi result block error" forKey:@"errorStr"];
            }
        }
        
        success(responseObject);
        
    } failure:^(NSError *error) {
        // 失败
        failure(error);
    }];
}

@end
