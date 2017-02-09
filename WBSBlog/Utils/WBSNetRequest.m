//
//  WBSNetRequest.m
//  WBSBlog
//
//  Created by Weberson on 2017/1/22.
//  Copyright © 2017年 Weberson. All rights reserved.
//

#import "WBSNetRequest.h"
#import "NetworkingCenter.h"
#import "WordPressApi.h"

@implementation WBSNetRequest


/// 用户登录
+ (void)postToLogin:(void (^) (BOOL isLoginSuccess,NSString * errorMsg)) LoginSuccessblock SiteUrlStr:(NSString *)siteUrl userNameStr:(NSString *)userName PassWordStr:(NSString *)PassWord  isJsonAPi:(BOOL)isJsonApi{
    
    if (isJsonApi) {
        // 使用JSON API登陆
        NSString *requestURL = [NSString stringWithFormat:@"http://%@/api/user/generate_auth_cookie/?username=%@&password=%@&insecure=cool", siteUrl, userName, PassWord];
        KLog(@"----jsonApi登陆：login request URL:%@", requestURL);
        //获取作者数据
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager GET:requestURL parameters:nil
             success:^(AFHTTPRequestOperation *operation, NSDictionary *result) {
                 
                 NSString *status = [result objectForKey:@"status"];
                 
                 if ([status isEqualToString:@"ok"]) {
                     NSString *cookieNameStr = result[@"cookie_name"];
                     NSString *cookieStr = result[@"cookie"];
                     [WBSUtils saveDataWithValue:cookieStr forKey:WBSSiteAuthCookie];
                     [WBSUtils saveDataWithValue:cookieNameStr forKey:WBSSiteAuthCookieName];
                     [WBSUtils saveDataWithValue:siteUrl forKey:WBSSiteBaseURL];
                     [WBSUtils saveDataWithValue:userName forKey:WBSUserUserName];
                     [WBSUtils saveDataWithValue:PassWord forKey:WBSUserPassWord];
                     [SingleObject shareSingleObject].isLogin = YES;
                     
                     // 保存用户数据
                     NSDictionary *userDict = [result objectForKey:@"user"];
                     WBSUserModel * userModel = [WBSUserModel WBSUserModelWithDic:userDict];
                     [WBSUtils saveDataWithValue:userModel.uid forKey:WBSUserUID];
                     NSDictionary *administratorDict = [userDict objectForKey:@"capabilities"];
                     // 是否是管理员
                     if ([administratorDict objectForKey:@"administrator"]) {
                         userModel.isAdmin = YES;
                     }else{
                         userModel.isAdmin = NO;
                     }
                     [SingleObject shareSingleObject].user = userModel;
                     // 保存用户数据到数据库
                     [[FMDBManger sharedFMDBManger]insertUserToUserInformationTableWith:userModel];
                     
                     LoginSuccessblock(YES,nil);
                     
                 } else {
                     
                     NSString * errorStr = [NSString stringWithFormat:@"请求错误：%@", result[@"error"]];
                     [SingleObject shareSingleObject].isLogin = NO;
                     LoginSuccessblock(NO,errorStr);
                     
                 }
             }
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 
                 NSString * errorStr = [NSString stringWithFormat:@"请求错误：%@", [error localizedDescription]];
                 [SingleObject shareSingleObject].isLogin = NO;
                 LoginSuccessblock(NO,errorStr);
             }];
        
    }else{
        // 使用XMLRPC 登陆
        // 对baseUrl进行包装  暂时不支持Https
        
        [WordPressApi loginInWithURL:siteUrl
                           username:userName
                           password:PassWord
                            success:^(NSURL *xmlrpcURL) {
                                
                                [WBSUtils saveDataWithValue:siteUrl forKey:WBSSiteBaseURL];
                                [WBSUtils saveDataWithValue:[xmlrpcURL absoluteString] forKey:WBSSiteXmlrpcURL];
                                [WBSUtils saveDataWithValue:userName forKey:WBSUserUserName];
                                [WBSUtils saveDataWithValue:PassWord forKey:WBSUserPassWord];
                                [SingleObject shareSingleObject].isLogin = YES;
                                LoginSuccessblock(YES,nil);
                                
                                KLog(@"-----登录成功--网址：%@ --",[xmlrpcURL absoluteString]);
                            } failure:^(NSError *error) {
                                KLog(@"-----登录失败啦----");
                                NSString * errorStr = [NSString stringWithFormat:@"登录失败：%@", [error localizedDescription]];
                                [SingleObject shareSingleObject].isLogin = NO;
                                LoginSuccessblock(NO,errorStr);
                            }];
        
        
    }
    
    
    
    
}


/// 网络请求
+ (void)postToRequestPostTextData:(void (^) (id obj,id msg, NSError *err))block andSiteUrlStr:(NSString *)siteUrl userNameStr:(NSString *)userName PassWordStr:(NSString *)PassWord{
    
}


@end
