//
//  WBSJsonApi.h
//  WBSJsonApi
//
//  Created by WebersonGao on 2017/1/26.
//  Copyright © 2017年 WebersonGao. All rights reserved.
//
// 该文件主要包含 【博客用户】 的 注册 删除 修改 搜索 等操作，【博客文章】的 增 删 改 查 参看 WBSBaseCoreApi 类

#import "WBSJsonApi.h"

@implementation WBSJsonApi


/**
 *  User
 */
#pragma mark  About User

/// 用户登陆 POST Login
+ (void)post_UserLogin_WithSiteUrlStr:(NSString *)siteUrlString userNameStr:(NSString *)userName passWordStr:(NSString *)passWord inSSLSecure:(BOOL)inSSLSecure success:(void (^)(id responseObject,NSString *cookieName,NSString *cookie))success failure:(void (^)(NSError *error))failure{
    
    NSString *requestURL = [NSString stringWithFormat:@"%@/%@/%@/",siteUrlString,KBase_Api,KUser_Generate_auth_cookie];
    
    NSMutableDictionary *parameterDict = [NSMutableDictionary dictionary];
    [parameterDict setObject:checkNull(userName) forKey:@"username"];
    [parameterDict setObject:checkNull(passWord) forKey:@"password"];
    if (!inSSLSecure) {
        // 不使用https
        [parameterDict setObject:@"cool" forKey:@"insecure"];
    }
    
    [WBSNetworking POSTRequest:requestURL parameters:parameterDict success:^(id responseObject) {
        // 成功
        NSString *cookieNameStr = @"";
        NSString *cookieStr = @"";
        
        if ([responseObject isKindOfClass:[NSDictionary class]] &&[[responseObject objectForKey:@"status"]isEqualToString:@"ok"]) {
            
            NSString *status = [responseObject objectForKey:@"status"];
            
            if (![status isEqualToString:@"ok"]) {
                // login fail
                cookieStr =@"";
                cookieNameStr = @"";
            }else{
                cookieNameStr = responseObject[@"cookie_name"];
                cookieStr = responseObject[@"cookie"];
                // 保存用户数据
                NSDictionary *userDict = [responseObject objectForKey:@"user"];
                WBSUserModel * userModel = [WBSUserModel WBSUserModelWithDic:userDict];
                NSDictionary *administratorDict = [userDict objectForKey:@"capabilities"];
                // 是否是管理员
                if ([administratorDict objectForKey:@"administrator"]) {
                    userModel.isAdmin = YES;
                }else{
                    userModel.isAdmin = NO;
                }
                
                responseObject = userModel;
            }
        }else{
            cookieStr = @"";
            cookieNameStr = @"";
            responseObject = [[NSDictionary alloc]initWithObjects:@[@"error",[responseObject objectForKey:@"error"] ] forKeys:@[@"status",@"error"] ];
        }
        
        success(responseObject,cookieNameStr,cookieStr);
        
    } failure:^(NSError *error) {
        // 失败
        failure(error);
    }];
    
}

@end
