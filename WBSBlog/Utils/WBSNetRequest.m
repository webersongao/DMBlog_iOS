//
//  WBSNetRequest.m
//  WBSBlog
//
//  Created by Weberson on 2017/1/22.
//  Copyright © 2017年 Weberson. All rights reserved.
//

#import "WBSNetRequest.h"
#import "NetworkingCenter.h"
#import "TGMetaWeblogAuthApi.h"

@implementation WBSNetRequest


/// 用户登录
+ (void)postToLogin:(void (^) (BOOL isLoginSuccess,NSString * errorMsg)) LoginSuccessblock SiteUrlStr:(NSString *)siteUrl userNameStr:(NSString *)userName PassWordStr:(NSString *)PassWord  isJsonAPi:(BOOL)isJsonApi{
    weakSelf(self)
    if (isJsonApi) {
        // 使用JSON API登陆
        NSString *requestURL = [NSString stringWithFormat:@"%@/user/generate_auth_cookie/?username=%@&password=%@", siteUrl, userName, PassWord];
        
        KLog(@"----jsonApi登陆：login request URL:%@", requestURL);
        //获取作者数据
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager GET:requestURL parameters:nil
             success:^(AFHTTPRequestOperation *operation, NSDictionary *result) {
                 
                 KLog(@"status:%@", [result objectForKey:@"status"]);
                 NSString *status = [result objectForKey:@"status"];
                 if ([status isEqualToString:@"ok"]) {
                     NSString *cookieStr = result[@"cookie"];
                     [WBSUtils saveDataWithValue:cookieStr forKey:WBSSiteAuthCookie];
                     [WBSUtils saveDataWithValue:siteUrl forKey:WBSSiteBaseURL];
                     [WBSUtils saveDataWithValue:userName forKey:WBSUserUserName];
                     [WBSUtils saveDataWithValue:PassWord forKey:WBSUserPassWord];
                     [SingleObject shareSingleObject].isLogin = YES;
                     
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
        //对baseUrl进行包装  暂时不支持Https
        NSString * baseSiteURL = [NSString stringWithFormat:@"http://%@/%@",siteUrl,@"xmlrpc.php"];
        [TGMetaWeblogAuthApi signInWithURL:baseSiteURL
                                  username:userName
                                  password:PassWord
                                   success:^(NSURL *xmlrpcURL) {
                                       KLog(@"xmlrpc登录--xmlrpc--:%@", xmlrpcURL);
                                       [WBSUtils saveDataWithValue:siteUrl forKey:WBSSiteBaseURL];
                                       [WBSUtils saveDataWithValue:userName forKey:WBSUserUserName];
                                       [WBSUtils saveDataWithValue:PassWord forKey:WBSUserPassWord];
                                       [SingleObject shareSingleObject].isLogin = YES;
                                       LoginSuccessblock(YES,nil);
                                       
                                   }
                                   failure:^(NSError *error) {
                                       NSString * errorStr = [NSString stringWithFormat:@"请求错误：%@", [error localizedDescription]];
                                       [SingleObject shareSingleObject].isLogin = NO;
                                       LoginSuccessblock(NO,errorStr);
                                       
                                   }];
    }
    
    
    
    
}


/// 网络请求
+ (void)postToRequestPostTextData:(void (^) (id obj,id msg, NSError *err))block andSiteUrlStr:(NSString *)siteUrl userNameStr:(NSString *)userName PassWordStr:(NSString *)PassWord{
    
}


@end
