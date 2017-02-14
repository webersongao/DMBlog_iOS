//
//  WBSJsonRequest.m
//  WBSBlog
//
//  Created by Weberson on 2017/1/22.
//  Copyright © 2017年 Weberson. All rights reserved.
//

#import "WBSJsonRequest.h"
#import "WBSJsonApi.h"
#import "WordPressApi.h"
#import "NetworkingCenter.h"
#import "WBSPostModel.h"
#import "WBSCategoryModel.h"
#import "WBSTagModel.h"
#import "WBSCommentModel.h"
#import "WBSVersioInfoModel.h"


@interface WBSJsonRequest ()

@end


@implementation WBSJsonRequest

// 获取JSONAPI 插件版本信息
+(void)GetJsonApiVersionInfoWithSuccessBlock:(void (^)(id versioInfo))successBlock failure:(void (^)(NSError *error))failureBlock{
    //http://www.swiftartisan.com/api/info/
    NSString *siteUrlStr = [WBSUtils getObjectforKey:WBSSiteBaseURL];
    [WBSJsonApi GetJsonApiVersionInfoWithSiteURLStr:siteUrlStr success:^(id versionInfoModel) {
        
        successBlock(versionInfoModel);
        
    } failure:^(NSError *error) {
        // 失败
        failureBlock(error);
    }];
}

/// 用户登录
+ (void)userLogin:(void (^) (BOOL isLoginSuccess,NSString * errorMsg)) LoginSuccessblock userNameStr:(NSString *)userName PassWordStr:(NSString *)PassWord  isJsonAPi:(BOOL)isJsonApi{
    
    NSString *siteUrlStr = [WBSUtils getObjectforKey:WBSSiteBaseURL];
    if (isJsonApi) {
        // 使用JSON API登陆
        NSString *queryStr = [NSString stringWithFormat:@"username=%@&password=%@",userName,PassWord];
        
        [WBSJsonApi userLoginWithSiteUrlStr:siteUrlStr queryString:queryStr inSSLSecure:NO success:^(NSDictionary *resultDict) {
            // 成功
            NSString *status = [resultDict objectForKey:@"status"];
            
            if ([status isEqualToString:@"ok"]) {
                NSString *cookieNameStr = resultDict[@"cookie_name"];
                NSString *cookieStr = resultDict[@"cookie"];
                [WBSUtils saveObjectforKey:cookieStr forKey:WBSSiteAuthCookie];
                [WBSUtils saveObjectforKey:cookieNameStr forKey:WBSSiteAuthCookieName];
                [WBSUtils saveObjectforKey:siteUrlStr forKey:WBSSiteBaseURL];
                [WBSUtils saveObjectforKey:userName forKey:WBSUserUserName];
                [WBSUtils saveObjectforKey:PassWord forKey:WBSUserPassWord];
                [SingleObject shareSingleObject].isLogin = YES;
                
                // 保存用户数据
                NSDictionary *userDict = [resultDict objectForKey:@"user"];
                WBSUserModel * userModel = [WBSUserModel WBSUserModelWithDic:userDict];
                [WBSUtils saveObjectforKey:userModel.uid forKey:WBSUserUID];
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
                
                NSString * errorStr = [NSString stringWithFormat:@"请求错误：%@", resultDict[@"error"]];
                [SingleObject shareSingleObject].isLogin = NO;
                LoginSuccessblock(NO,errorStr);
                
            }
            
        } failure:^(NSError *error) {
            // 失败
            NSString * errorStr = [NSString stringWithFormat:@"请求错误：%@", [error localizedDescription]];
            [SingleObject shareSingleObject].isLogin = NO;
            LoginSuccessblock(NO,errorStr);
        }];
        
    }else{
        // 使用XMLRPC 登陆  暂时不支持Https
        siteUrlStr = [WBSUtils getObjectforKey:WBSSiteXmlrpcURL];
        [WordPressApi loginInWithURL:siteUrlStr
                            username:userName
                            password:PassWord
                             success:^(NSURL *xmlrpcURL) {
                                 [WBSUtils saveObjectforKey:siteUrlStr forKey:WBSSiteBaseURL];
                                 [WBSUtils saveObjectforKey:[xmlrpcURL absoluteString] forKey:WBSSiteXmlrpcURL];
                                 [WBSUtils saveObjectforKey:userName forKey:WBSUserUserName];
                                 [WBSUtils saveObjectforKey:PassWord forKey:WBSUserPassWord];
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


/// 获取最近文章
+ (void)getRecentPostsWithQueryString:(NSString *)queryString success:(void (^)(NSArray *postsModelArray, NSInteger postsCount))successBlock failure:(void (^)(NSError *error))failureBlock{
    NSString *siteUrlStr = [WBSUtils getObjectforKey:WBSSiteBaseURL];
    
    [WBSJsonApi get_recent_posts_WithSiteUrlStr:siteUrlStr queryString:queryString success:^(NSArray *postsModelArray, NSInteger postsCount) {
        // 成功
        successBlock(postsModelArray,postsCount);
    }failure:^(NSError *error) {
        // 失败
        //Trigger failure block
        failureBlock(error);
        
    }];
    
}


/// 获取文章 get_posts
+ (void)getPostsWithQueryString:(NSString *)queryString success:(void (^)(NSArray *postsArray, NSInteger postsCount ,BOOL isIgnoreStickyPosts))successBlock failure:(void (^)(NSError *error))failureBlock{
    NSString *siteUrlStr = [WBSUtils getObjectforKey:WBSSiteBaseURL];
    
    [WBSJsonApi get_Posts_WithSiteUrlStr:siteUrlStr queryString:queryString success:^(NSArray *postsModelArray, NSInteger postsCount, BOOL isIgnoreStickyPosts) {
        // 成功
        successBlock(postsModelArray,postsCount,isIgnoreStickyPosts);
    } failure:^(NSError *error) {
        // 失败
        //Trigger failure block
        failureBlock(error);
    }];
    
}

















/// 网络请求
+ (void)postToRequestPostTextData:(void (^) (id obj,id msg, NSError *err))block andSiteUrlStr:(NSString *)siteUrl userNameStr:(NSString *)userName PassWordStr:(NSString *)PassWord{
    
}


@end
